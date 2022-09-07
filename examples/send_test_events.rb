require 'date'
require 'concurrent'
require 'snap_business_sdk'

PIXEL_ID = '<insert-pixel-id>'
TOKEN = '<insert-capi-token>'

capi = SnapBusinessSDK::ConversionApi.new TOKEN

event0 = SnapBusinessSDK::CapiEvent.new(
  pixel_id: PIXEL_ID,
  event_conversion_type: 'WEB',
  event_type: 'PURCHASE',
  timestamp: DateTime.now.strftime('%Q').to_i,
)
event0.email = 'usr1@gmail.com'
event0.ip_address = '202.117.0.20'
event0.phone_number = '123-456-7890'

event1 = SnapBusinessSDK::CapiEvent.new(
  pixel_id: PIXEL_ID,
  event_conversion_type: 'WEB',
  event_type: 'PURCHASE',
  timestamp: DateTime.now.strftime('%Q').to_i,
)
event1.email = 'usr2@gmail.com'
event1.ip_address = '202.117.0.21'
event1.phone_number = '123-456-7891'

# create and send two requests synchronously
resp0 = capi.send_test_event event0
resp1 = capi.send_test_events [event0, event1]

all = [resp0, resp1]
all.each_with_index do |resp, i|
  puts "Request #{i} status: #{resp.status}"
end

# grab the logs and stats
resp_logs = capi.get_test_event_logs PIXEL_ID
resp_stats = capi.get_test_event_stats PIXEL_ID
puts "Test event logs: #{resp_logs}"
puts "Test event stats: #{resp_stats}"
