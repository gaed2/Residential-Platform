# frozen_string_literal: true

class Residential::Checklist::UpdateIntr < ApplicationInteraction
  object :property
  array :property_checklist

  validate :question_and_answer

  def execute
    update_records, create_records = energy_checklist_collection
    return errors.merge! update_records.errors unless PropertyChecklist.update(update_records.keys, update_records.values)
    if create_records.present?
      checklist_outcome = Residential::Checklist::CreateIntr.run(property: property, property_checklist: create_records)
      errors.merge! checklist_outcome.errors unless checklist_outcome.valid?
    end
    property
  end

  private

  def energy_checklist_collection
    update_records = {}
    create_records = []
    property_checklist.each do |data|
      if data['id'].present?
        update_records.merge!(data['id'] => { 'energy_saving_checklist_id' => data['energy_saving_checklist_id'],
                                              'answer' => data['answer']
                              })
      else
        create_records.push({energy_saving_checklist_id: data['energy_saving_checklist_id'], answer: data['answer']})
      end
    end
    return update_records, create_records
  end

  # To check question and answer presence
  def question_and_answer
    property_checklist.each do |checklist|
      checklist = checklist.with_indifferent_access
      return errors.add(:base, I18n.t('checklist.question.cannot_blank')) if checklist[:energy_saving_checklist_id].blank?
      return errors.add(:base, I18n.t('checklist.answer.cannot_blank')) if checklist[:answer].blank?
    end
  end
end
