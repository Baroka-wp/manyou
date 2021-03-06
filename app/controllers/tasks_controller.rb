class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  PER = 10

  # GET /tasks
  # GET /tasks.json
  def index
    if params[:sort_expired]
      @tasks = Task.page(params[:page]).per(PER)
      @tasks = @tasks.order(deadline: :desc)
    else
      @tasks = Task.page(params[:page]).per(PER)
      @tasks = @tasks.order(created_at: :desc)
    end

    if params[:sort_priority_high]
      @tasks = Task.page(params[:page]).per(PER)
      @tasks = @tasks.order(priority: :desc)
    end

    if params[:task].present?
      if params[:task][:title].present? && params[:task][:status].present?
        #両方title and statusが成り立つ検索結果を返す
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")
        @tasks = @tasks.where(status: params[:task][:status])

        #渡されたパラメータがtask titleのみだったとき
      elsif params[:task][:title].present?
        @tasks = @tasks.where('title LIKE ?', "%#{params[:task][:title]}%")

        #渡されたパラメータがステータスのみだったとき
      elsif params[:task][:status].present?
        @tasks = @tasks.where(status: params[:task][:status])
      end
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end
    # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :status, :priority)
  end
end
