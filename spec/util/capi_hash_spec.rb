require 'digest'
require_relative '../../lib/snap_business/util/capi_hash'

describe 'capi_hash' do
  describe 'norm_and_hash_str' do
    [
      "abc123",
      "ABC123",
      "aBc123",
    ].each do |str|
      it "hashes the non-empty string #{str}" do
        expect(SnapBusinessSDK::CapiHash.norm_and_hash_str str).to eq(Digest::SHA256.hexdigest str.downcase)
      end
    end
  end

  describe 'norm_and_soundex_str' do
    {
      'Robert' => 'R163',
      'Rupert' => 'R163',
      'Rubin' => 'R150',
      'Ashcraft' => 'A261',
      'Ashcroft' => 'A261',
      'Tymczak' => 'T522',
      'Pfister' => 'P236',
      'Bob' => 'B100'
    }.each do |str, expected|
      it "it soundex hashes #{str} to #{expected}" do
        expect(SnapBusinessSDK::CapiHash.norm_and_soundex_str str).to eq expected
      end
    end
  end

  describe 'normalize_phone_num' do
    {
      "+44-447-234-2344" => "444472342344",
      "0044-447-234-2344" => "444472342344",
      "+44-0447-234-2344" => "444472342344",
      "+44 0447 234 2344" => "444472342344",
      "447-234-2344" => "14472342344",
      "4472342344" => "14472342344",
      "+1-447-234-2344" => "14472342344",
      "(447)-234-2344" => "14472342344",
      "447 234-2344" => "14472342344",
      "+1-(447) 234 2344" => "14472342344",
    }.each do |phone_num, expected|
      it "validates and removes extra characters for #{phone_num}" do
        expect(SnapBusinessSDK::CapiHash.normalize_phone_num phone_num).to eq expected
      end
    end

    {
      "" => nil,
      nil => nil,
      "  " => nil,
    }.each do |phone_num, expected|
      it "rejects invalid phone number #{phone_num}" do
        expect(SnapBusinessSDK::CapiHash.normalize_phone_num phone_num).to eq expected
      end
    end
  end
end
