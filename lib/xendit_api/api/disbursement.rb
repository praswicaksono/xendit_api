require 'xendit_api/api/base'
require 'xendit_api/model/disbursement'

module XenditApi
  module Api
    class Disbursement < XenditApi::Api::Base
      PATH = '/disbursements'.freeze

      def create(params, headers = {})
        response = client.post_response(PATH, params, headers)
        XenditApi::Model::Disbursement.new(response.body.merge(payload: response.body.to_json, request_id: response.headers['request-id']))
      end

      def find_by_external_id(external_id, headers = {})
        where_by_external_id(external_id, headers).first
      end

      def where_by_external_id(external_id, headers = {})
        response = client.get_response("#{self.class::PATH}/?external_id=#{external_id}", nil, headers)
        disbursements = []
        response.body.each do |disbursement|
          disbursements << XenditApi::Model::Disbursement.new(disbursement.merge(payload: response.body.to_json, request_id: response.headers['request-id']))
        end
        disbursements
      end
    end
  end
end
