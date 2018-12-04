class Job < ApplicationRecord
  belongs_to :user
  has_many :entries, dependent: :destroy #この一行を追加
end
