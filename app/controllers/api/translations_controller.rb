module Api
  class TranslationsController < BaseController

    skip_before_action :verify_authenticity_token

    before_action :register_trial_license

    rescue_from StandardError do |e|
      logger.warn "Unhandled exception: #{e.inspect}"
      logger.info e.backtrace.join("\n")
      render json: { message: 'Internal server error' }, status: :internal_server_error
    end

    def create
      request = TranslationRequest.from_params(params)

      if request.valid?
        request.save!
        api_response = request.perform_translate
        response = TranslationResponse.from_api_response(request.id, api_response)

        if response.valid?
          response.save!
          render json: {
            request_text: request.text,
            response_text: response.text,
            source_lang: request.source_lang,
            target_lang: request.target_lang,
            detected_source_language: response.detected_source_language
          }
        else
          logger.warn "Response validation error: #{response.errors.full_messages}"
          render json: { message: 'Invalid translation response' }, status: :bad_request
        end
      else
        logger.warn "Request validation error: #{request.errors.full_messages}"
        keys = request.errors.messages.values.flatten.select { |key| %w(limit_chars_per_translation limit_total_chars).include?(key) }
        render json: { message: 'Invalid translation request', keys: keys }, status: :bad_request
      end
    end

    private

    def register_trial_license
      if params[:license_key].match?(/\Alk_trial_/) && !TrialLicense.exists?(key: params[:license_key])
        TrialLicense.create!(key: params[:license_key])
      end
    end
  end
end
