class ClockSessionsController < ApplicationController
  before_action :find_clock_session, only: [:show, :edit, :update, :destroy, :user_full_name]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @clock_sessions = ClockSession.all
  end

  def show
    @user_full_name = user_full_name
  end

  def new
    @clock_session = current_user.clock_sessions.build
  end

  def create
    @clock_session = current_user.clock_sessions.build(clock_session_params)
    if @clock_session.valid?
      @clock_session.save
      redirect_to @clock_session, :flash => { :success => "#{current_user.first_name} clocked in."}
    else
      render 'new', :status => :unprocessable_entity, :flash => { :error => "Could not clock in." }
    end
  end

  def user_full_name
    "#{@clock_session.user.first_name} #{@clock_session.user.last_name}"
  end

  private
  def find_clock_session
    @clock_session = ClockSession.find_by_id(params[:id])
    return render_not_found if @clock_session.blank?
  end

  def clock_session_params
    params.require(:clock_session).permit(:id, :user_id, :clock_out, :created_at, :updated_at)
  end

  def render_not_found(status=:not_found)
    render :plain => "#{status.to_s.titleize}", :status => status
  end
end
