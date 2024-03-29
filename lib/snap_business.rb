=begin
#Snap Conversions API

#No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)

The version of the OpenAPI document: 1.0.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 6.0.1

=end

# Common files
require 'snap_business/api_client'
require 'snap_business/api_error'
require 'snap_business/version'
require 'snap_business/configuration'

# Models
require 'snap_business/models/capi_event'
require 'snap_business/models/response'
require 'snap_business/models/response_error_records'
require 'snap_business/models/response_logs'
require 'snap_business/models/response_logs_log'
require 'snap_business/models/response_stats'
require 'snap_business/models/response_stats_data'
require 'snap_business/models/response_stats_test'
require 'snap_business/models/test_response'
require 'snap_business/models/validated_fields'
require 'snap_business/models/validated_fields_items'

# APIs
require 'snap_business/api/default_api'
require 'snap_business/api/conversion_api'

module SnapBusinessSDK
  class << self
    # Customize default settings for the SDK using block.
    #   SnapBusinessSDK.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
