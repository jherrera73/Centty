class AnswerYesController < ApplicationController
  
  before_filter :authenticate
  before_filter :ensure_not_answered
  
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(:response => true)
    @answer.user = current_user
    
    @answer.save
    respond_to do |format|
      format.html { redirect_to questions_path, notice: 'You answered yes' }
      format.json { render json: @answer, status: :created, location: @answer }
    end
  end
end
