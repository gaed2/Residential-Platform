class ApplicationInteraction < ActiveInteraction::Base

  def assign_attrs(record, attributes)
    attributes.each do |attribute|
      record.send("#{attribute}=", (send attribute)) if send "#{attribute}?"
    end
  end
end
