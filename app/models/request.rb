class Request < ApplicationRecord
  enum status: {pending: 0, approved: 1, rejected: 2}
  after_update :send_rejection_email, if: :rejected?
  belongs_to :user
  has_many :borrow_books, dependent: :destroy

  validates :status, presence: true

  private

  def send_rejection_email
    RequestMailer.rejection_email(self).deliver_now
  end
end
