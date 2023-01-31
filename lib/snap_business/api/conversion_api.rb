require 'concurrent'
require_relative '../util/constants'

module SnapBusinessSDK
  class ConversionApi
    attr_reader :use_launchpad
    attr_accessor :config
    attr_accessor :client
    attr_accessor :default_api

    # Creates a CAPI object to send conversion events with
    #
    # @param [String] long_lived_token token for authentication
    # @option opts [String] :launchpad_url endpoint for launchpand
    # @option opts [Boolean] :test_mode send events to test endpoints or not
    # @option opts [Boolean] :is_debugging enable debugging logs
    # @option opts [Logger] :logger custom logger
    def initialize(long_lived_token, opts = {})
      @is_debugging = false
      @use_launchpad = false

      @config = Configuration.new 
      config.access_token = long_lived_token
      @client = ApiClient.new config
      client.user_agent = SnapBusinessSDK::Constants::USER_AGENT
      client.default_headers[SnapBusinessSDK::Constants::METRICS_HEADER] = SnapBusinessSDK::Constants::METRICS_HEADER_VALUE
      client.default_headers['accept-encoding'] = ''

      if opts.key?(:'is_debugging')
        self.is_debugging = opts[:'is_debugging']
      end

      if opts.key?(:'launchpad_url')
        set_launchpad_url opts[:'launchpad_url']
      end

      if opts.key?(:'logger')
        self.logger = opts[:'logger']
      end

      # override host for certain endpoints
      @config.server_operation_index = {
        "DefaultApi.send_data": nil,
        "DefaultApi.send_test_data": nil,
        "DefaultApi.conversion_validate_logs": nil,
        "DefaultApi.conversion_validate_stats": nil,
      }

      @default_api = DefaultApi.new client
    end

    # @return [Boolean]
    def is_debugging
      config.debugging
    end

    # @return [Logger]
    def logger
      config.logger
    end

    # Send a single conversion event to CAPI asynchronously
    #
    # @param [CapiEvent] capi_event
    # @return [Concurrent::Promise]
    def send_event(capi_event)
      send_events [capi_event]
    end

    # Send multiple conversion event to CAPI asynchronously
    #
    # @param [Array<CapiEvent>] capi_events
    # @return [Concurrent::Promise]
    def send_events(capi_events)
      Concurrent::Promise.execute do
        send_events_sync(capi_events)
      end
    end

    # Send a single conversion event to CAPI synchronously
    #
    # @param [CapiEvent] capi_event
    # @return [Response]
    def send_event_sync(capi_event)
      send_events_sync [capi_event]
    end

    # Send multiple conversion event to CAPI synchronously
    #
    # @param [Array<CapiEvent>] capi_events
    # @return [Response]
    def send_events_sync(capi_events)
      headers = {}
      if use_launchpad
        headers[SnapBusinessSDK::Constants::CAPI_PATH_HEADER] = SnapBusinessSDK::Constants::CAPI_PATH
      end

      capi_events.each do |event|
        if is_debugging
          logger.info "[Snap Business SDK] Sending event: #{event.to_s}"
        end
        event.integration = SnapBusinessSDK::Constants::INTEGRATION_SDK
      end

      begin
        @default_api.send_data body: capi_events, header_params: headers
      rescue SnapBusinessSDK::ApiError => error
        if is_debugging
          logger.error "[Snap Business SDK] Failed to send event: #{error.to_s}"
        end
        SnapBusinessSDK::Response.new status: error.code.to_s, reason: error.response_body
      rescue => error
        if is_debugging
          logger.error "[Snap Business SDK] Exception occured: #{error.to_s}"
        end
        SnapBusinessSDK::Response.new status: 'FAILED', reason: error.to_s
      end
    end

    # Send a single conversion event to CAPI synchronously
    #
    # @param [CapiEvent] capi_event
    # @return [TestResponse]
    def send_test_event(capi_event)
      send_test_events [capi_event]
    end

    # Send multiple test conversion event to CAPI synchronously
    #
    # @param [Array<CapiEvent>] capi_events
    # @return [TestResponse]
    def send_test_events(capi_events)
      headers = {}
      if use_launchpad
        headers[SnapBusinessSDK::Constants::CAPI_PATH_HEADER] = SnapBusinessSDK::Constants::CAPI_PATH_TEST
      end

      capi_events.each do |event|
        if is_debugging
          logger.info "[Snap Business SDK] Sending test event: #{event.to_s}"
        end
        event.integration = SnapBusinessSDK::Constants::INTEGRATION_SDK
      end

      begin
        @default_api.send_test_data body: capi_events, header_params: headers
      rescue SnapBusinessSDK::ApiError => error
        if is_debugging
          logger.error "[Snap Business SDK] Failed to send test event: #{error.to_s}"
        end
        SnapBusinessSDK::TestResponse.new status: error.code.to_s, reason: error.response_body
      rescue => error
        if is_debugging
          logger.error "[Snap Business SDK] Exception occured: #{error.to_s}"
        end
        SnapBusinessSDK::TestResponse.new status: 'FAILED', reason: error.to_s
      end
    end

    # Get test event logs
    #
    # @param [String] asset_id
    # @return [ResponseLogs]
    def get_test_event_logs(asset_id)
      headers = {}

      begin
        @default_api.conversion_validate_logs asset_id, header_params: headers
      rescue SnapBusinessSDK::ApiError => error
        if is_debugging
          logger.error "[Snap Business SDK] Failed to get test event logs: #{error.to_s}"
        end
        SnapBusinessSDK::ResponseLogs.new status: error.code.to_s, reason: error.response_body
      rescue => error
        if is_debugging
          logger.error "[Snap Business SDK] Exception occured: #{error.to_s}"
        end
        SnapBusinessSDK::ResponseLogs.new status: 'FAILED', reason: error.to_s
      end
    end

    # Get test event stats
    #
    # @param [String] asset_id
    # @return [ResponseStats]
    def get_test_event_stats(asset_id)
      headers = {}

      begin
        @default_api.conversion_validate_stats asset_id, header_params: headers
      rescue SnapBusinessSDK::ApiError => error
        if is_debugging
          logger.error "[Snap Business SDK] Failed to get test event stats: #{error.to_s}"
        end
        SnapBusinessSDK::ResponseStats.new status: error.code.to_s, reason: error.response_body
      rescue => error
        if is_debugging
          logger.error "[Snap Business SDK] Exception occured: #{error.to_s}"
        end
        SnapBusinessSDK::ResponseStats.new status: 'FAILED', reason: error.to_s
      end
    end

    private

      # Set the launchpad url to use if instead of the public Snapchat endpoint
      #
      # @param [String] launchpad_url
      def set_launchpad_url(launchpad_url)
        @use_launchpad = !(launchpad_url.nil? || launchpad_url.strip.empty?)

        if use_launchpad
          client.user_agent = SnapBusinessSDK::Constants::USER_AGENT_WITH_PAD
          config.host = launchpad_url.strip

          if is_debugging
            logger.info "[Snap Business SDK] Launchpad host is set to #{@config.host}"
          end
        else
          client.user_agent = SnapBusinessSDK::Constants::USER_AGENT
        end
      end

      # Enables/disables logging
      #
      # @param [Boolean] is_enabled
      def is_debugging=(is_enabled)
        config.debugging = is_enabled
        if is_debugging
          config.logger.info "[Snap Business SDK] Debug mode is set to #{is_enabled}"
        end
      end

      # Set the logger used
      #
      # @param [Logger] logger
      def logger=(logger)
        config.logger = logger
        if is_debugging
          logger.info '[Snap Business SDK] Logger set'
        end
      end
  end
end
