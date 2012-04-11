# encoding: UTF-8

clavier = Category.create :name => "Frappe clavier"
clavier.metrics.create :value => 180, :at => Date.today - 2.days
clavier.metrics.create :value => 190, :at => Date.today - 1.days
clavier.metrics.create :value => 200, :at => Date.today

course = Category.create :name => "Course à pied"
course.metrics.create :value => 4, :at => Date.today - 2.days
course.metrics.create :value => 3, :at => Date.today - 1.days
course.metrics.create :value => 12, :at => Date.today