class Metric < ActiveRecord::Base
  attr_accessible :category, :value, :at

  belongs_to :category
end
