class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update]

  def index
    
    per_page = 15
    
    if params[:search].blank?
      @users = User.paginate :per_page => per_page, :page => params[:page]
    else
      search_string = params[:search]
      @users = User.paginate :per_page => per_page, 
                             :conditions => ['username like ?', "#{search_string}%"], 
                             :page => params[:page]
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
    
  end
  
  def show
    
    per_page = 15
    
    @user = User.find(params[:id])
    @questions = @user.questions.paginate :per_page => per_page, :page => params[:questions_page]
    @answers = @user.answers.paginate :per_page => per_page, :page => params[:answers_page]
    @following = @user.following.paginate :per_page => per_page, :page => params[:following_page]
    @followers = @user.followers.paginate :per_page => per_page, :page => params[:followers_page]
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end
  
  def new
    @user = User.new
  end
  
  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_url, notice: 'Registration Successful.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to root_url, notice: 'Successfully updated profile.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
