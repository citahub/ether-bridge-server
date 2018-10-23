# frozen_string_literal: true

class Api::V1::EthToEbcsController < ApplicationController
  # GET /api/v1/eth_to_ebcs/:address
  def index
    eth_to_ebcs = EthToEbc.where(address: params[:address]).order(created_at: :desc).page(params[:page]).per(params[:per_page])

    render json: {
      result: {
        count: eth_to_ebcs.total_count,
        eth_to_ebcs: ActiveModelSerializers::SerializableResource.new(eth_to_ebcs, each_serializer: ::EthToEbcSerializer)
      }
    }
  end
end
