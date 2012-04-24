class AnswerNoController < ApplicationController
  
  before_filter :authenticate
  before_filter :ensure_not_answered
   
  def create
    @answer = @question.answers.build(:response => false, :user_id => current_user)
    @answer.user = current_user
    @answer.save
    
    respond_to do |format|
      format.html { redirect_to questions_path, notice: 'You answered no' }
      format.json { render json: @answer, status: :created, location: @answer }
    end
  end
  
end
