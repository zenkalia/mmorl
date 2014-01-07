class Portal < ActiveRecord::Base
  belongs_to :exit_room, class_name: 'Room', foreign_key: 'exit_room_id'
  belongs_to :entry_room, class_name: 'Room', foreign_key: 'entry_room_id'
end
