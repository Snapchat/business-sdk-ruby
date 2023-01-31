require 'digest'
require 'soundex'

module SnapBusinessSDK
  class CapiHash
    class << self
      PHONE_NUM_PATTERN = /^((\+|00)(\d+)[\-\s])?0?(.+)/
      PHONE_NUM_REPLACE_PATTERN = /[^\d.]/

      def norm_and_hash_str(str)
        if blank? str
          nil
        else
          Digest::SHA256.hexdigest str.strip.downcase
        end
      end

      def norm_and_soundex_str(str)
        if blank? str
          nil
        else
          Soundex.new(str.strip.downcase).soundex.upcase
        end
      end

      def norm_and_hash_phone_num(phone_num)
        normalized_phone_num = normalize_phone_num phone_num
        if normalized_phone_num.nil?
          nil
        else
          Digest::SHA256.hexdigest normalized_phone_num
        end
      end

      def normalize_phone_num(phone_num)
        if blank? phone_num
          return nil
        end

        phone_num.match(PHONE_NUM_PATTERN) do |m|
          country_code = (m[3] || "").gsub PHONE_NUM_REPLACE_PATTERN, ""
          num = (m[4] || "").gsub PHONE_NUM_REPLACE_PATTERN, ""

          if blank? country_code
            country_code = "1"
          end

          if blank? num
            nil
          else
            country_code + num
          end
        end
      end

      def blank?(str)
        str.respond_to?(:empty?) ? str.empty? : str.nil?
      end
    end
  end
end
