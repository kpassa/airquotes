ActiveAdmin.register Coverage do
  index do
    column :program
    column :description
    default_actions
  end
end
