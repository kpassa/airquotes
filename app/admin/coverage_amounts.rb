# -*- coding: utf-8 -*-
ActiveAdmin.register CoverageAmount do
  menu :parent => "Configuración"  
  scope :for_active_products

  index do
    column :product
    column :amount
    default_actions
  end
  
end
