# -*- coding: utf-8 -*-
require File.expand_path('lib/email_format_validator.rb')

class User < ActiveRecord::Base
  belongs_to :country
  has_secure_password
  
  has_many :estimates

  attr_protected :password_digest

  validates :username, :password, :password_confirmation, :name, :country_id, :address_1, :phone, :presence => true
  validates :email, :email_format => true  # Uses my own email validator
  validate :username_must_have_only_word_chars
  validate :phone_must_be_valid
  validate :email_must_be_valid

  def address
    if address_2
      [ address_1, address_2 ].join(", ")
    else
      address_1
    end
  end

  def to_s
    name
  end

  after_destroy :ensure_no_estimates_exist
  
  private

  def ensure_no_estimates_exist
    raise "Este usuario tiene cotizaciones en el sistema!" unless estimates.empty?
  end

  def phone_must_be_valid
    unless phone && phone.gsub(/\D/,'') =~ /^\d{8}$/
      self.errors.add(:phone, "no es válido")
    end
  end

  def email_must_be_valid
    
  end

  def username_must_have_only_word_chars
    if username && username =~ /\W/
      self.errors.add(:username, "debe contener sólo letras a-z, números o \"_\"")
    end
  end
  
end
