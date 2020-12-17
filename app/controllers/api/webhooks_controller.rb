module Api
  class WebhooksController < BaseController

    skip_before_action :verify_authenticity_token

    def create
      event = construct_webhook_event
      process_webhook_event(event)
      head :ok
    rescue JSON::ParserError => e
      logger.warn "#{controller_name}##{action_name} Invalid payload exception=#{e.inspect}"
      head :bad_request
    rescue Stripe::SignatureVerificationError => e
      logger.warn "#{controller_name}##{action_name} Invalid signature exception=#{e.inspect}"
      head :bad_request
    rescue => e
      logger.warn "#{controller_name}##{action_name} Unknown error exception=#{e.inspect}"
      logger.info e.backtrace.join("\n")
      head :bad_request
    end

    private

    def construct_webhook_event
      payload = request.body.read
      sig_header = request.headers['HTTP_STRIPE_SIGNATURE']
      Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_ENDPOINT_SECRET'])
    end

    def process_webhook_event(event)
      case event.type
      when 'checkout.session.completed'
        checkout_session_completed(event.data.object)
      else
        logger.info "Unhandled stripe webhook event type=#{event.type} value=#{event.inspect}"
      end
    end

    def checkout_session_completed(checkout_session)
      subscription = nil
      user_id = checkout_session.client_reference_id
      user = User.find(user_id)
      subscription_id = checkout_session.subscription

      if user.has_subscription?
        Stripe::Subscription.delete(subscription_id)

        send_message("`#{Rails.env}:checkout_session_completed` already purchased user_id=#{user.id}")
      else
        raw_customer = Stripe::Customer.retrieve(checkout_session.customer)
        raw_subscription = Stripe::Subscription.retrieve(subscription_id)

        ApplicationRecord.transaction do
          subscription = Subscription.create_by(checkout_session: checkout_session, raw_customer: raw_customer, raw_subscription: raw_subscription)
          user.pro_licenses.create!(subscription_id: subscription.id)
        end

        Stripe::Subscription.update(subscription_id, { metadata: { user_id: user_id, sub_id: subscription.id } })

        send_message("`#{Rails.env}:checkout_session_completed` success user_id=#{user.id} subscription_id=#{subscription.id}")
      end
    rescue => e
      if subscription
        send_message("`#{Rails.env}:checkout_session_completed` subscription may be insufficient subscription=#{subscription.inspect} exception=#{e.inspect}")
      end
      raise
    end

    def send_message(message)
      # SendMessageToSlackWorker.perform_async(:subscriptions, message)
      logger.warn "#send_message: #{message}"
    rescue => e
      logger.warn "#{controller_name}##{action_name}: #send_message is failed exception=#{e.inspect} caller=#{caller[0][/`([^']*)'/, 1] rescue ''} message=#{message}"
    end
  end
end
