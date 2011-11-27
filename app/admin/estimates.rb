ActiveAdmin.register Estimate do
  scope :for_active_products

  index do
    column :country do |estimate|
      estimate.user.country.to_s
    end
    column :program
    column :coverage

    column :user do |estimate|
      estimate.user.name
    end
    column :client
    column :created_at
    
    default_actions
  end

  show do |estimate|
    render estimate
  end


end
