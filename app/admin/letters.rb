ActiveAdmin.register Letter do
  index do
    column :program
    column "Contenido" do |letter|
      truncate( letter.body_1, length: 200, separator: ' ' )
    end
    column :updated_at
    default_actions
  end
end
