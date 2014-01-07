class Memory < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  after_initialize do
    self.fixtures = ' ' * 1600 if self.new_record?
  end
end
