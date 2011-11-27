# -*- coding: utf-8 -*-
ActiveAdmin.register Product do
  menu :parent => "Configuración"
  scope :active

  index do
    column :country
    column :program
    column :coverage
    column :active
    column :created_at do |product|
      product.created_at.strftime("%B %d %Y")
    end

    default_actions
  end

end
