require_relative '../util/capi_hash'

module SnapBusinessSDK
  module CapiEventExt
    def email=(email_plaintext)
      self.hashed_email = CapiHash.norm_and_hash_str email_plaintext
    end

    def mobile_ad_id=(mobile_ad_id_plaintext)
      self.hashed_mobile_ad_id = CapiHash.norm_and_hash_str mobile_ad_id_plaintext
    end

    def idfv=(idfv_plaintext)
      self.hashed_idfv = CapiHash.norm_and_hash_str idfv_plaintext
    end

    def phone_number=(phone_number_plaintext)
      self.hashed_phone_number = CapiHash.norm_and_hash_phone_num phone_number_plaintext
    end

    def ip_address=(ip_address_plaintext)
      self.hashed_ip_address = CapiHash.norm_and_hash_str ip_address_plaintext
    end

    def first_name=(first_name_plaintext)
      self.hashed_first_name_sha = CapiHash.norm_and_hash_str first_name_plaintext
      self.hashed_first_name_sdx = CapiHash.norm_and_soundex_str first_name_plaintext
    end

    def middle_name=(middle_name_plaintext)
      self.hashed_middle_name_sha = CapiHash.norm_and_hash_str middle_name_plaintext
      self.hashed_middle_name_sdx = CapiHash.norm_and_soundex_str middle_name_plaintext
    end

    def last_name=(last_name_plaintext)
      self.hashed_last_name_sha = CapiHash.norm_and_hash_str last_name_plaintext
      self.hashed_last_name_sdx = CapiHash.norm_and_soundex_str last_name_plaintext
    end

    def city=(city_plaintext)
      self.hashed_city_sha = CapiHash.norm_and_hash_str city_plaintext
      self.hashed_city_sdx = CapiHash.norm_and_soundex_str city_plaintext
    end

    def state=(state_plaintext)
      self.hashed_state_sha = CapiHash.norm_and_hash_str state_plaintext
      self.hashed_state_sdx = CapiHash.norm_and_soundex_str state_plaintext
    end

    def zip=(zip_plaintext)
      self.hashed_zip = CapiHash.norm_and_hash_str zip_plaintext
    end

    def dob=(dob_plaintext)
      # TODO Parse and hash DD and MM after the format of unhashedDobStr is finalized
    end
  end
end
