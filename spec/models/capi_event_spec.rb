require 'digest'

describe 'capi_event' do
  describe 'email' do
    it 'hashes plaintext arguments' do
      val = 'test@test.com'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.email = val
      expect(capi_event.hashed_email).not_to be_empty
      expect(capi_event.hashed_email).not_to eq val
    end
  end

  describe 'mobile_ad_id' do
    it 'hashes plaintext arguments' do
      val = 'test-ad-id'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.mobile_ad_id = val
      expect(capi_event.hashed_mobile_ad_id).not_to be_empty
      expect(capi_event.hashed_mobile_ad_id).not_to eq val
    end
  end

  describe 'idfv' do
    it 'hashes plaintext arguments' do
      val = 'test-idfv'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.idfv = val
      expect(capi_event.hashed_idfv).not_to be_empty
      expect(capi_event.hashed_idfv).not_to eq val
    end
  end

  describe 'phone_number' do
    it 'hashes plaintext arguments' do
      val = '0044-447-234-2344'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.phone_number = val
      expect(capi_event.hashed_phone_number).not_to be_empty
      expect(capi_event.hashed_phone_number).not_to eq val
    end
  end

  describe 'ip_address' do
    it 'hashes plaintext arguments' do
      val = 'test-ip_address'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.ip_address = val
      expect(capi_event.hashed_ip_address).not_to be_empty
      expect(capi_event.hashed_ip_address).not_to eq val
    end
  end

  describe 'first_name' do
    it 'hashes plaintext arguments' do
      val = 'test-first_name'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.first_name = val
      expect(capi_event.hashed_first_name_sha).not_to be_empty
      expect(capi_event.hashed_first_name_sha).not_to eq val
      expect(capi_event.hashed_first_name_sdx).not_to be_empty
      expect(capi_event.hashed_first_name_sdx).not_to eq val
    end
  end

  describe 'middle_name' do
    it 'hashes plaintext arguments' do
      val = 'test-middle_name'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.middle_name = val
      expect(capi_event.hashed_middle_name_sha).not_to be_empty
      expect(capi_event.hashed_middle_name_sha).not_to eq val
      expect(capi_event.hashed_middle_name_sdx).not_to be_empty
      expect(capi_event.hashed_middle_name_sdx).not_to eq val
    end
  end

  describe 'last_name' do
    it 'hashes plaintext arguments' do
      val = 'test-last_name'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.last_name = val
      expect(capi_event.hashed_last_name_sha).not_to be_empty
      expect(capi_event.hashed_last_name_sha).not_to eq val
      expect(capi_event.hashed_last_name_sdx).not_to be_empty
      expect(capi_event.hashed_last_name_sdx).not_to eq val
    end
  end

  describe 'city' do
    it 'hashes plaintext arguments' do
      val = 'test-city'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.city = val
      expect(capi_event.hashed_city_sha).not_to be_empty
      expect(capi_event.hashed_city_sha).not_to eq val
      expect(capi_event.hashed_city_sdx).not_to be_empty
      expect(capi_event.hashed_city_sdx).not_to eq val
    end
  end

  describe 'state' do
    it 'hashes plaintext arguments' do
      val = 'test-state'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.state = val
      expect(capi_event.hashed_state_sha).not_to be_empty
      expect(capi_event.hashed_state_sha).not_to eq val
      expect(capi_event.hashed_state_sdx).not_to be_empty
      expect(capi_event.hashed_state_sdx).not_to eq val
    end
  end

  describe 'zip' do
    it 'hashes plaintext arguments' do
      val = 'test-zip'
      capi_event = SnapBusinessSDK::CapiEvent.new
      capi_event.zip = val
      expect(capi_event.hashed_zip).not_to be_empty
      expect(capi_event.hashed_zip).not_to eq val
    end
  end

  def hash(str)
    Digest::SHA256.hexdigest str.downcase
  end
end
