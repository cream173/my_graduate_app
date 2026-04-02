class HealthRecordsController < ApplicationController
  before_action :set_health_record, only: %i[ show edit update destroy ]

  # GET /health_records or /health_records.json
  def index
    @health_records = HealthRecord.all.order(created_at: :desc)
  end

  # GET /health_records/1 or /health_records/1.json
  def show
  end

  # GET /health_records/new
  def new
    @health_record = HealthRecord.new
  end

  # GET /health_records/1/edit
  def edit
  end

  # POST /health_records or /health_records.json
  def create
    @health_record = HealthRecord.new(health_record_params)
    @health_record.user = current_user

    respond_to do |format|
      if @health_record.save
        format.html { redirect_to health_records_path, notice: "体調を記録しました" }
        format.json { render :show, status: :created, location: @health_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @health_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /health_records/1 or /health_records/1.json
  def update
    respond_to do |format|
      if @health_record.update(health_record_params)
        format.html { redirect_to health_records_path, notice: "体調記録を更新しました", status: :see_other }
        format.json { render :show, status: :ok, location: @health_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @health_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /health_records/1 or /health_records/1.json
  def destroy
    @health_record.destroy!

    respond_to do |format|
      format.html { redirect_to health_records_path, notice: "体調記録を削除しました", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_health_record
      @health_record = HealthRecord.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def health_record_params
      params.expect(health_record: [ :user_id, :recorded_at, :feeling, :fatigue_level, :stress_level, :sleep_level, :memo, symptom_ids: [] ])
    end
end
