require 'date'
require 'concurrent'
require 'snap_business_sdk'

PIXEL_ID = '<insert-pixel-id>'
TOKEN = '<insert-capi-token>'

capi = SnapBusinessSDK::ConversionApi.new TOKEN

event0 = SnapBusinessSDK::CapiEvent.new()
event0.pixel_id = PIXEL_ID
event0.event_conversion_type = 'WEB'
event0.event_type = 'PURCHASE'
event0.timestamp = DateTime.now.strftime('%Q')
event0.email = 'usr1@gmail.com'
event0.ip_address = '202.117.0.20'
event0.phone_number = '123-456-7890'
event0.event_tag = 'event_tag_example'
event0.uuid_c1 = '34dd6077-e3a0-4b1c-9f91-a690ea0e335d'
event0.item_category = 'item_category_example'
event0.item_ids = 'item_ids_example'
event0.description = 'description_example'
event0.number_items = 'number_items_example'
event0.price = 'price_example'
event0.currency = 'USD'
event0.transaction_id = 'transaction_id_example'
event0.level = 'level_example'
event0.client_dedup_id = 'client_dedup_id_example'
event0.search_string = 'search_string_example'
event0.page_url = 'page_url_example'
event0.sign_up_method = 'sign_up_method_example'
event0.first_name = 'test_first'
event0.middle_name = 'test_middle'
event0.last_name = 'test_last'
event0.city = 'test_city'
event0.state = 'test_state'
event0.zip = 'test_zip'

event1 = SnapBusinessSDK::CapiEvent.new(
  pixel_id: PIXEL_ID,
  event_conversion_type: 'WEB',
  event_type: 'PURCHASE',
  timestamp: DateTime.now.strftime('%Q'),
)
event1.email = 'usr2@gmail.com'
event1.ip_address = '202.117.0.21'
event1.phone_number = '123-456-7891'

# create and execute api calls
prom0 = capi.send_event event0
prom1 = capi.send_events [event0, event1]

# optionally wait for both to complete if you wish to handle responses
all = Concurrent::Promise.zip(prom0, prom1).wait
all.value.each_with_index do |resp, i|
  puts "Request #{i} status: #{resp.status} resp: #{resp}"
end
