class Client < ApplicationRecord
    has_many :invoices, dependent: :destroy
    has_one_attached :featured_image
    has_rich_text :description
    validates :name, :featured_image, presence: true

    validates :email,
        presence: true,
        uniqueness: true,
        format: {
            with: URI::MailTo::EMAIL_REGEXP
        }
end
