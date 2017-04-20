class Show < ApplicationRecord
  has_attached_file :medium, default_url: "/images/:style/missing.png"
  has_attached_file :original, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :medium, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_attachment_content_type :original, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end
