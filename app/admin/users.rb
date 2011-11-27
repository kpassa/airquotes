ActiveAdmin.register User do

  index do
    column :country
    column :username
    column :name
    column :address
    column :phone
    column :estimates do |user|
      user.estimates.count.to_s
    end
    
    default_actions
  end

  form do |f|
    f.inputs "Acceso" do
      f.input :username
      f.input :password
      f.input :password_confirmation
    end

    f.inputs "Datos Personales" do
      f.input :country
      f.input :name
      f.input :title
      f.input :address_1
      f.input :address_2
      f.input :phone
    end
    f.buttons
  end

  controller do

    def destroy
      @user = User.find( params[:id] )
      begin
        @user.destroy
      rescue Exception => e
        flash[:notice] = e.message
      end

      redirect_to admin_users_url
    end
    
  end

end
