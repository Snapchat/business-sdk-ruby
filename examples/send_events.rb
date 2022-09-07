require 'concurrent'
require 'snap_business_sdk'

PIXEL_ID = '<insert-pixel-id>'
TOKEN = '<insert-capi-token>'

capi = SnapBusinessSDK::ConversionApi.new TOKEN

event0 = SnapBusinessSDK::CapiEvent.new(
  pixel_id: PIXEL_ID,
  event_conversion_type: 'WEB',
  event_type: 'PURCHASE',
  timestamp: 1656022510346,
)
event0.email = 'usr1@gmail.com'
event0.ip_address = '202.117.0.20'
event0.phone_number = '123-456-7890'

event1 = SnapBusinessSDK::CapiEvent.new(
  pixel_id: PIXEL_ID,
  event_conversion_type: 'WEB',
  event_type: 'PURCHASE',
  timestamp: 1656022510346,
)
event1.email = 'usr2@gmail.com'
event1.ip_address = '202.117.0.21'
event1.phone_number = '123-456-7891'

# create and execute api calls
prom0 = capi.send_event event0
prom1 = capi.send_events [event0, event1]

# optionally wait for both to complete if you wish to handle responses
all = Concurrent::Promise.zip(prom0, prom0).wait
all.value.each_with_index do |resp, i|
  puts "Request #{i} status: #{resp.status}"
end

# send test events to the validation endpoint
# prom = capi.send_test_events [event0, event1]
# prom.wait
# puts "Test request status: #{prom.value.status}"
