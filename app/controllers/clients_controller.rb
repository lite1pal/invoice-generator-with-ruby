class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy]
  allow_unauthenticated_access only: %i[ show index ]

  def index
    @clients = Client.all
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to @client, notice: "Client was updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique
    @client.errors.add(:email, "has been taken")
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @client.destroy
    redirect_to clients_path
  end

  private
    def set_client
      @client = Client.find(params[:id])
    end

    def client_params
      params.expect(client: [ :name, :description, :featured_image, :company, :tax_id, :address, :phone, :email ])
    end
end
