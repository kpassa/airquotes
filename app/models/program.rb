class Program < ActiveRecord::Base
  has_many :products,  :dependent => :destroy
  has_one  :letter,    :dependent => :destroy
  has_many :coverages, :dependent => :destroy
  has_many :estimates

  has_attached_file :logo, :styles => {
    admin: "60x60",
    page: "260x160",
  }, :default_url => "program_logos/:style/missing.png"

  serialize :ignored_fields_list
  validates :name, :presence => true

  def to_s
    name
  end

  after_destroy :ensure_no_estimates_exist
  
  def self.complete?
    for p in Program.all
      return false unless p.coverages.first
    end
    true
  end

  def ignored_fields=(comma_separated_list)
    self.ignored_fields_list = comma_separated_list.split(",")
  end

  def ignored_fields
    ignored_fields_list ? ignored_fields_list.join(",") : ""
  end

  def ignored?(field)
    ignored_fields_list.index(field.to_s)
  end

private

  def ensure_no_estimates_exist
    raise "Hay cotizaciones para este programa!" unless estimates.empty?
  end
end
