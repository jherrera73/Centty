class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :questions, :dependent => :destroy
  has_many :answers
  
  default_scope :order => 'username ASC'
  
  attr_accessible :username, :password, :password_confirmation
  
  after_create :enable_api!
  
  def enable_api!
    generate_api_key!
  end

  def disable_api!
    update_column(:api_key, "")
  end

  def api_is_enabled?
    !api_key.empty?
  end
  
  def total_questions
    questions.count
  end
  
  def total_responses
    answers.count
  end
  
  private
    
  def secure_hash(string)
    Digest::SHA2::hexdigest(string)
  end
    
  def secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def generate_api_key!
    update_column(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
  end
  
end
# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  username          :string(255)
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  api_key           :string(255)
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

