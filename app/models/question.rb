class Question < ActiveRecord::Base
  acts_as_taggable
  
  attr_accessible :title
  
  default_scope :order => 'created_at DESC'
  
  belongs_to :user
  
  has_many :answers, :dependent => :destroy
  
  validates :title, :presence => { :message => 'Question cant be blank' }
  
  def yes_responses
    answers.where(:response => true).count
  end
  
  def no_responses
    answers.where(:response => false).count
  end
  
  def consensus
    yes = yes_responses
    no = no_responses
    
    if yes == 0 && no == 0
      "No responses yet!"
    elsif yes > no
      "Yes!"
    elsif yes < no
      "No!"
    elsif yes == no
      "Not sure!"
    end
  end
  
  def my_answer(user)
    answers.where(:user_id => user).first
  end
  
end
# == Schema Information
#
# Table name: questions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  title      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

