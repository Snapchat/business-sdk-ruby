require_relative '../../lib/snap_business/api/conversion_api'
require_relative '../../lib/snap_business/util/constants'

describe 'conversion_api' do
  describe 'initialize' do
    it 'initializes with all optional fields provided' do
      is_debugging = false
      launchpad_url = 'some.domain.com'
      logger = Logger.new(STDOUT)
      capi = SnapBusinessSDK::ConversionApi.new 'token',
        launchpad_url: launchpad_url,
        logger: logger,
        is_debugging: is_debugging

      expect(capi.use_launchpad).to be true
      expect(capi.config.host).to eq launchpad_url
      expect(capi.client.default_headers['User-Agent']).to eq SnapBusinessSDK::Constants::USER_AGENT_WITH_PAD
      expect(capi.logger).to eq logger
      expect(capi.is_debugging).to eq is_debugging
    end
  end

  describe 'launchpad_url' do
    it 'sets the provided launchpad url' do
      launchpad_url = 'some.domain.com'
      capi = SnapBusinessSDK::ConversionApi.new 'token', launchpad_url: launchpad_url

      expect(capi.use_launchpad).to be true
      expect(capi.config.host).to eq launchpad_url
      expect(capi.client.default_headers['User-Agent']).to eq SnapBusinessSDK::Constants::USER_AGENT_WITH_PAD
    end

    it 'uses the default endpoint when not set' do
      capi = SnapBusinessSDK::ConversionApi.new 'token'

      expect(capi.use_launchpad).to be false
      expect(capi.config.host).to eq SnapBusinessSDK::Constants::PROD_DOMAIN
      expect(capi.client.default_headers['User-Agent']).to eq SnapBusinessSDK::Constants::USER_AGENT
    end
  end

  describe 'is_debugging' do
    it 'sets debugging to false by default' do
      capi = SnapBusinessSDK::ConversionApi.new 'token'

      expect(capi.is_debugging).to be false
    end

    it 'sets debugging to true' do
      debugging = true
      capi = SnapBusinessSDK::ConversionApi.new 'token', is_debugging: debugging

      expect(capi.is_debugging).to be true
    end
  end

  describe 'send_events' do
    it 'sends events asynchronously' do
      capi = SnapBusinessSDK::ConversionApi.new 'token'
      capi_event = SnapBusinessSDK::CapiEvent.new(
        pixel_id: 'pixel-id',
        event_conversion_type: 'WEB',
        event_type: 'PURCHASE',
        timestamp: 1656022510346,
      )
      capi_event.email = 'usr1@gmail.com'
      capi_event.ip_address = '202.117.0.20'
      capi_event.phone_number = '123-456-7890'
      capi_events = [capi_event]

      header = {}
      request = { body: capi_events, header_params: header }
      response = SnapBusinessSDK::Response.new status: '200'
      expect(capi.default_api).to receive(:send_data).with(request).and_return(response)

      promise = capi.send_events capi_events
      promise.execute.wait
      expect(promise.value).to eq response
    end
  end

  describe 'send_events_sync' do
    it 'sends events synchronously' do
      capi = SnapBusinessSDK::ConversionApi.new 'token'
      capi_event = SnapBusinessSDK::CapiEvent.new(
        pixel_id: 'pixel-id',
        event_conversion_type: 'WEB',
        event_type: 'PURCHASE',
        timestamp: 1656022510346,
      )
      capi_event.email = 'usr1@gmail.com'
      capi_event.ip_address = '202.117.0.20'
      capi_event.phone_number = '123-456-7890'
      capi_events = [capi_event]

      header = {}
      request = { body: capi_events, header_params: header }
      response = SnapBusinessSDK::Response.new status: '200'
      expect(capi.default_api).to receive(:send_data).with(request).and_return(response)

      actual_response = capi.send_events_sync capi_events
      expect(actual_response).to eq response
    end

    it 'sends events synchronously to launchpad' do
      launchpad_url = 'some.domain.com'
      capi = SnapBusinessSDK::ConversionApi.new 'token', launchpad_url: launchpad_url
      capi_event = SnapBusinessSDK::CapiEvent.new(
        pixel_id: 'pixel-id',
        event_conversion_type: 'WEB',
        event_type: 'PURCHASE',
        timestamp: 1656022510346,
      )
      capi_event.email = 'usr1@gmail.com'
      capi_event.ip_address = '202.117.0.20'
      capi_event.phone_number = '123-456-7890'
      capi_events = [capi_event]

      header = { SnapBusinessSDK::Constants::CAPI_PATH_HEADER => SnapBusinessSDK::Constants::CAPI_PATH }
      request = { body: capi_events, header_params: header }
      response = SnapBusinessSDK::Response.new status: '200'
      expect(capi.default_api).to receive(:send_data).with(request).and_return(response)

      actual_response = capi.send_events_sync capi_events
      expect(actual_response).to eq response
    end
  end

  describe 'send_test_events' do
    it 'sends test events synchronously' do
      capi = SnapBusinessSDK::ConversionApi.new 'token'
      capi_event = SnapBusinessSDK::CapiEvent.new(
        pixel_id: 'pixel-id',
        event_conversion_type: 'WEB',
        event_type: 'PURCHASE',
        timestamp: 1656022510346,
      )
      capi_event.email = 'usr1@gmail.com'
      capi_event.ip_address = '202.117.0.20'
      capi_event.phone_number = '123-456-7890'
      capi_events = [capi_event]

      header = {}
      request = { body: capi_events, header_params: header }
      response = SnapBusinessSDK::TestResponse.new status: '200'
      expect(capi.default_api).to receive(:send_test_data).with(request).and_return(response)

      actual_response = capi.send_test_events capi_events
      expect(actual_response).to eq response
    end

    it 'sends test events synchronously to launchpad' do
      launchpad_url = 'some.domain.com'
      capi = SnapBusinessSDK::ConversionApi.new 'token', launchpad_url: launchpad_url
      capi_event = SnapBusinessSDK::CapiEvent.new(
        pixel_id: 'pixel-id',
        event_conversion_type: 'WEB',
        event_type: 'PURCHASE',
        timestamp: 1656022510346,
      )
      capi_event.email = 'usr1@gmail.com'
      capi_event.ip_address = '202.117.0.20'
      capi_event.phone_number = '123-456-7890'
      capi_events = [capi_event]

      header = { SnapBusinessSDK::Constants::CAPI_PATH_HEADER => SnapBusinessSDK::Constants::CAPI_PATH_TEST }
      request = { body: capi_events, header_params: header }
      response = SnapBusinessSDK::TestResponse.new status: '200'
      expect(capi.default_api).to receive(:send_test_data).with(request).and_return(response)

      actual_response = capi.send_test_events capi_events
      expect(actual_response).to eq response
    end
  end

  describe 'get_test_event_logs' do
    it 'gets test event logs' do
      asset_id = 'test-asset-id'
      capi = SnapBusinessSDK::ConversionApi.new 'token'
      header = {}
      request = { header_params: header }
      response = SnapBusinessSDK::ResponseLogs.new status: '200'
      expect(capi.default_api).to receive(:conversion_validate_logs).with(asset_id, request).and_return(response)

      actual_response = capi.get_test_event_logs asset_id
      expect(actual_response).to eq response
    end
  end

  describe 'get_test_event_stats' do
    it 'gets test event stats' do
      asset_id = 'test-asset-id'
      capi = SnapBusinessSDK::ConversionApi.new 'token'
      header = {}
      request = { header_params: header }
      response = SnapBusinessSDK::ResponseStats.new status: '200'
      expect(capi.default_api).to receive(:conversion_validate_stats).with(asset_id, request).and_return(response)

      actual_response = capi.get_test_event_stats asset_id
      expect(actual_response).to eq response
    end
  end
end
