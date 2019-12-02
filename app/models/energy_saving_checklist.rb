class EnergySavingChecklist < ApplicationRecord
  has_many :property_checklists, dependent: :destroy

  scope :by_heading, ->(heading) { where("LOWER(heading) ILIKE ?", "%#{heading}%") }
  scope :by_question, ->(question) { where("LOWER(question) ILIKE ?", "%#{question}%") }
end
