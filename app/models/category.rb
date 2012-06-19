class Category < ActiveRecord::Base
  attr_accessible :name

  has_many :metrics

  validates_presence_of :name
end
