class Client < ApplicationRecord
    has_one_attached :featured_image
    has_rich_text :description
    validates :name, :featured_image, presence: true
end
