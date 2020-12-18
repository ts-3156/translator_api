# == Schema Information
#
# Table name: credentials
#
#  id            :bigint           not null, primary key
#  user_id       :bigint           not null
#  access_token  :text(65535)      not null
#  refresh_token :text(65535)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_credentials_on_created_at  (created_at)
#  index_credentials_on_user_id     (user_id) UNIQUE
#
class Credential < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :access_token, presence: true
  validates :refresh_token, presence: true, uniqueness: true
end
