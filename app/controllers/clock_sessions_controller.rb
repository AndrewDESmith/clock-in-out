class ClockSessionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :get_user_full_name, only: [:index, :show, :new, :total]
  before_action :find_clock_session, only: [:show, :edit, :update, :destroy, :user_full_name]

  def index
    last_clock_session_for_user
    @clock_sessions = ClockSession.all
  end

  def show
  end

  def new
    # Ensure that the user clocks out before being able to clock in again.
    if last_clock_session_for_user && @last_clock_session.clock_out.blank?
      redirect_to edit_clock_session_path(@last_clock_session.id)
    else
      @clock_session = current_user.clock_sessions.build
    end
  end

  def create
    @clock_session = current_user.clock_sessions.build(clock_session_params)
    if @clock_session.valid?
      @clock_session.save
      redirect_to clock_sessions_path, :flash => { :success => "#{current_user.first_name} clocked in."}
    else
      render 'new', :status => :unprocessable_entity, :flash => { :error => "Could not clock in." }
    end
  end

  def edit
    return render_not_found(:forbidden) if @clock_session.user != current_user
  end

  def update
    return render_not_found(:forbidden) if @clock_session.user != current_user
    if @clock_session.update(clock_session_params)
      redirect_to clock_sessions_path, :flash => { :success => "Successfully clocked out." }
    else
      render 'edit', :status => :unprocessable_entity, :flash => { :error => "Could not update clock session." }
    end
  end

  def last_clock_session_for_user
    if current_user && current_user.clock_sessions.last
      @last_clock_session = current_user.clock_sessions.last
    else
      nil
    end
  end

  def total
    return unless params[:begin]
    @beginning = "#{params[:begin][:year]}-#{params[:begin][:month]}-#{params[:begin][:day]}"
    @ending = "#{params[:end][:year]}-#{params[:end][:month]}-#{params[:end][:day]}"
    @total = current_user.total_user_session_time_for_date_range(@beginning, @ending)
  end

  private
  def get_user_full_name
    @user_full_name = "#{current_user.first_name} #{current_user.last_name}" if current_user
  end

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
