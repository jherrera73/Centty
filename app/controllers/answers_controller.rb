class AnswersController < ApplicationController
  
  before_filter :authenticate
   
  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @answer = current_user.answers.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end
  
end