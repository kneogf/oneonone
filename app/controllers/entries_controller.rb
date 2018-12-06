class EntriesController < ApplicationController
  def create
  	@entry = current_user.entries.new(entry_params)
  	if @entry.save
        flash[:notice] = "チャレンジを送りましました"
        redirect_to @entry.job, notice: "チャレンジが認められました。"
    else
        flash[:alert] = "チャレンジが認められませんでした"
        redirect_to :back
    end
  end

  private

  def entry_params
  	params.require(:entry).permit(:user_id, :job_id, :messages)
  end
end
