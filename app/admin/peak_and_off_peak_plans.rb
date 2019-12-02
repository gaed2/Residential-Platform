ActiveAdmin.register PeakAndOffPeakPlan do
  permit_params :peak_start, :peak_end, :peak_off_start, :peak_off_end, :peak_price_type, :peak_price,
                :peak_off_price_type, :peak_off_price, :electricity_supplier_id

  filter :electricity_supplier, as: :select
  filter :peak_price_type, as: :select
  filter :peak_off_price_type, as: :select

  PEAK_OFF_PEAK_COLUMN = %i[electricity_supplier peak_price_type peak_price peak_off_price_type peak_off_price].freeze

  index do
    column :id
    column 'Peak Duration' do |peak_plan|
      peak_plan.peak_duration
    end
    column 'Peak Off Duration' do |peak_off_plan|
      peak_off_plan.peak_off_duration
    end
    (PEAK_OFF_PEAK_COLUMN - %w[peak_price peak_off_price]).each do |col|
      column col
    end
    column :peak_price do |plan|
      "#{plan.peak_price} #{plan.peak_price_in}"
    end
    column :peak_off_price do |plan|
      "#{plan.peak_off_price} #{plan.peak_off_price_in}"
    end
    actions
  end

  show do
    attributes_table do
      row 'Peak Duration' do |peak_plan|
        peak_plan.peak_duration
      end
      row 'Peak Off Duration' do |peak_off_plan|
        peak_off_plan.peak_off_duration
      end
      (PEAK_OFF_PEAK_COLUMN - %w[peak_price peak_off_price]).each do |row|
        row row
      end
      row :peak_price do |plan|
        "#{plan.peak_price} #{plan.peak_price_in}"
      end
      row :peak_off_price do |plan|
        "#{plan.peak_off_price} #{plan.peak_off_price_in}"
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :electricity_supplier
      f.input :peak_start, label: 'Peak start (hh:mm)'
      f.input :peak_end, label: 'Peak end (hh:mm)'
      f.input :peak_off_start, label: 'Peak off start (hh:mm)'
      f.input :peak_off_end, label: 'Peak off end (hh:mm)'
      f.input :peak_price_type, as: :select
      f.input :peak_price
      f.input :peak_off_price_type, as: :select
      f.input :peak_off_price
    end
    f.actions
  end
end
