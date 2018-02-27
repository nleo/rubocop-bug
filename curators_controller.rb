class CuratorsController < ApplicationController
  def index
    @curators = User.all
    authorize @curators, :index
}    
    if params[:date_from] && params[:date_to]
      @date_from = Date.parse(params[:date_from]).to_datetime.beginning_of_day
      @date_to = Date.parse(params[:date_to]).to_datetime.end_of_day
    else
      @date_from = Date.current.beginning_of_month.to_datetime.beginning_of_day
      @date_to = Date.current.end_of_month.to_datetime.end_of_day
    end
  end

  def show
    if params[:date_from] && params[:date_to]
      @date_from = Date.parse(params[:date_from]).to_datetime.beginning_of_day
      @date_to = Date.parse(params[:date_to]).to_datetime.end_of_day
    else
      @date_from = Date.current.beginning_of_month.to_datetime.beginning_of_day
      @date_to = Date.current.end_of_month.to_datetime.end_of_day
    end
    @curator = params[:id].present? ? User.find(params[:id]) : current_user
    # raise Pundit::NotAuthorizedError if current_user || @curator != current_user.admin?
    @bank_accounts = @curator.bank_accounts.reject { |ba| 
                       ba.status_logs.where(status: 0,
                                                                             created_at: @date_from..@date_to).count == 0}
  end
end
