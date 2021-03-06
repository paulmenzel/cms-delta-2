class Constant < ActiveRecord::Base

  belongs_to :project

  default_scope { order('category ASC, value ASC') }
  
  scope :category, ->(category) { where('constants.category = ?', category) unless category.nil? }
  scope :global, ->{ where(:project_id => nil) }
  

  validates_presence_of :category, :name, :value, :art


  def self.method_missing(name, args = nil)

    unless args.nil?
      return self.where(:category => name).where(:value => args[:id].to_s).first
    else
      return self.where(:category => name)
    end

    super.method_missing name

  end

end
