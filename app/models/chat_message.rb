class ChatMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  def message_for(user)
    if self.user == user
      self.body
    else
      self.public_body
    end
  end
end
