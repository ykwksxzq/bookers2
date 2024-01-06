class Chat < ApplicationRecord

  belongs_to :user
  belongs_to :room

  validates :message, presence: true, length: { maximum: 140 }

  def owns?(other_user)
    self == other_user
  end

end
