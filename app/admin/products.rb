# -*- coding: utf-8 -*-
ActiveAdmin.register Product do
  menu :parent => "Configuración"
  
  index do
    column :country
    column :program
    column :coverage
    column :active
    default_actions
  end

end
