ActiveAdmin.register EnergySavingChecklist do
  permit_params :heading, :question
  remove_filter :property_checklists, :updated_at

  collection_action :autocomplete_energy_saving_checklist_heading, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    checklist_headings = EnergySavingChecklist.select(:heading).by_heading(params[:term])
    render json: checklist_headings
  end

  collection_action :autocomplete_energy_saving_checklist_question, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    checklist_questions = EnergySavingChecklist.select(:question).by_question(params[:term])
    render json: checklist_questions
  end

  filter :heading_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/energy_saving_checklists/autocomplete_energy_saving_checklist_heading'
          }
  }, label: 'Heading contains', required: false


  filter :question_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/energy_saving_checklists/autocomplete_energy_saving_checklist_question'
          }
  }, label: 'Question contains', required: false

  index do
    column :id
    column :heading
    column :question
    actions
  end

  show do
    attributes_table do
      row :heading
      row :question
    end
  end
end
