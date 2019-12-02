ActiveAdmin.register PropertyCategory do
  permit_params :property_category, :name, :icon
  remove_filter :property_sub_categories, :status, :updated_at, :icon

  filter :name, as: :select

  index do
    column :id
    column :name
    column :icon do |category|
      image_tag category.icon.url(:thumb)
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :icon do |category|
        image_tag category.icon.url(:thumb)
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :icon
    end
    f.actions
  end
end
