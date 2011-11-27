# -*- coding: utf-8 -*-
ActiveAdmin.register Letter do
  menu :parent => "Configuración"  

  show do |letter|
    letter.html do
      "<div style=\"font-weight:bold; text-align:center; padding-top:4em;padding-bottom:4em;\">(La tabla va aquí!)</div>"
    end
  end
  
end
