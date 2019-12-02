class AddPdfReportToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :pdf_report, :string
  end
end
