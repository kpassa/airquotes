# -*- coding: utf-8 -*-
class Country < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :users

  validates :name, :code, :currency_symbol, :presence => true
  
  after_destroy :ensure_this_country_has_no_users

  def to_s
    name
  end

  private
  
  def ensure_this_country_has_no_users
    raise "Hay usuarios en este país!" unless users.empty?
  end
  
end


