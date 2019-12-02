# frozen_string_literal: true

class Residential::Checklist::CreateIntr < ApplicationInteraction
  object :property
  array :property_checklist

  validate :question_and_answer

  def execute
    checklist = property.property_checklists.build(property_checklist)
    return errors.merge! checklist.errors unless checklist.map(&:save)
    checklist
  end

  private

  # To check question and answer presence
  def question_and_answer
    property_checklist.each do |checklist|
      checklist = checklist.with_indifferent_access
      return errors.add(:base, I18n.t('checklist.question.cannot_blank')) if checklist[:energy_saving_checklist_id].blank?
      return errors.add(:base, I18n.t('checklist.answer.cannot_blank')) if checklist[:answer].blank?
    end
  end
end
