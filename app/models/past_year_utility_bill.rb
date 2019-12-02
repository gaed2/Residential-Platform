class PastYearUtilityBill < ApplicationRecord

  mount_uploader :file, UtilityBillUploader
  belongs_to :property
end
