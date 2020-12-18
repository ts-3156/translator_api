class Subscription < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :email, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :tax_rate, presence: true
  validates :checkout_session_id, presence: true
  validates :customer_id, presence: true # TODO stripe_customer_id
  validates :subscription_id, presence: true # TODO stripe_subscription_id

  scope :not_canceled, -> { where(canceled_at: nil) }
  scope :charge_not_failed, -> { where(charge_failed_at: nil) }

  PRODUCT_ID = ENV['STRIPE_PRODUCT_ID']
  PRICE_ID = ENV['STRIPE_PRICE_ID']
  TAX_ID = ENV['STRIPE_TAX_ID']
  PRODUCT_NAME = 'Deep Translator Pro'
  TAX_RATE = 0.1
  PRICE = 500
  TRIAL_DAYS = 14

  def canceled?
    canceled_at.present?
  end

  def cancel!
    Stripe::Subscription.delete(subscription_id)
    update!(canceled_at: Time.zone.now)
  end

  class << self
    def create_by(checkout_session:, raw_customer:, raw_subscription:)
      trial_end_at = raw_subscription.trial_end ? Time.zone.at(raw_subscription.trial_end) : Time.zone.now

      create!(
        user_id: checkout_session.client_reference_id,
        email: raw_customer.email,
        name: PRODUCT_NAME,
        price: PRICE,
        tax_rate: TAX_RATE,
        checkout_session_id: checkout_session.id,
        customer_id: checkout_session.customer,
        subscription_id: checkout_session.subscription,
        trial_end_at: trial_end_at,
      )
    end
  end
end
