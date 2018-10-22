class Api::V1::EbcToEthsController < ApplicationController
  # GET /api/v1/ebc_to_eths/:address
  def index
    ebc_to_eths = EbcToEth.where(address: params[:address]).order(created_at: :desc).page(params[:page]).per(params[:per_page])

    render json: {
      result: {
        count: ebc_to_eths.total_count,
        ebc_to_eths: ActiveModelSerializers::SerializableResource.new(ebc_to_eths, each_serializer: ::EbcToEthSerializer)
      }
    }
  end
end
