class Estimate < ActiveRecord::Base
  belongs_to :letter
  belongs_to :product
  belongs_to :user
  belongs_to :coverage

  has_one :client

  accepts_nested_attributes_for :client

  validate :policyholder_amount_is_greater_than_spouse_amount

  def self.inherited(child)
    child.instance_eval do
      def model_name
        Estimate.model_name
      end
    end
  end

  def policyholder_amount_is_greater_than_spouse_amount
    if policyholder_amount && spouse_amount
      self.errors.add(:spouse_amount, "debe de ser menos que la cantidad del titular.")
    end
  end

end
