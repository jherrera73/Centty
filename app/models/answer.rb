class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user  
end
# == Schema Information
#
# Table name: answers
#
#  id          :integer         not null, primary key
#  question_id :integer
#  user_id     :integer
#  response    :boolean
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

