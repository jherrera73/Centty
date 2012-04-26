class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :questions, :dependent => :destroy
  
  has_many :answers
  
  has_many :relationships, :foreign_key => "follower_id", 
                           :dependent => :destroy
                           
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
                                   
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  default_scope :order => 'username ASC'
  
  attr_accessible :email, :username, :password, :password_confirmation
  
  after_create :enable_api!
  
  validate :excluded_login
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  
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
  
  def total_followers
    followers.count
  end
  
  def total_following
    following.count
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
  
  def excluded_login
    %w( admin root administrator superuser answer_no answer_yes answers application pages questions relationships user_sessions users ).each do |reserved_login|
      errors.add(:username, "is reserved") if username.downcase == reserved_login
    end
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
#  email             :string(255)
#

