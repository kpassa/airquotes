class Letter < ActiveRecord::Base
  belongs_to :program
  has_one :estimate
end
