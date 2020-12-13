class Credential < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :access_token, presence: true
  validates :refresh_token, presence: true
end
