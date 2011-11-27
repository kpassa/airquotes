# -*- coding: utf-8 -*-
# From this page
# http://lindsaar.net/2010/1/31/validates_rails_3_awesome_is_true
# But I don't use the really long regexp because I don't understand it. 

class EmailFormatValidator < ActiveModel::EachValidator  
  def validate_each(object, attribute, value)  
    unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i  
      object.errors[attribute] << (options[:message] || "no es un correo electónico válido")  
    end  
  end  
end
