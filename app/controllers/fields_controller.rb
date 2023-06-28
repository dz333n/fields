class FieldsController < ApplicationController
  def index
    @fields = Field.all
  end

  def show
    @field = Field.find_by(id: params[:id])
  end

  def new; end

  def create
    field = ::Fields::Create.new(
      name: params[:name],
      polygons: params[:polygons]
    ).call

    render json: { id: field.id }
  end

  def destroy
    field = Field.find_by(id: params[:id])
    field.destroy!
    head :ok
  end
end
