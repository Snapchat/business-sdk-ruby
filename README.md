
# CAPI Business SDK in Ruby
## Introduction
The Snapchat Conversions API (CAPI) allows you to pass web, app, and offline events to Snap via a Server-to-Server (S2S) integration. Similar to our other Direct Data Integrations, Snap Pixel and App Ads Kit (SDK), by passing these events, you can access post-view and post-swipe campaign reporting to measure performance and incrementality. Depending on the data shared and timeliness of integration, it’s also possible to leverage events passed via Conversions API for solutions such as custom audience targeting, campaign optimization, Dynamic Ads, and more.

Business SDK is an API client that facilitates requests and authentication processes with CAPI as if they were local functions of the supported languages. There have been similar products (e.g. Facebook Business SDK for Conversion API), which largely simplified the integration for advertising platforms. To improve the developer experience and CAPI adoption, we bundle the dedicated CAPI client, hashing libraries, and code examples into one SDK that is available in multiple languages. In addition, our CAPI Business SDK paves the way for Privacy-Enhancing Technologies in CAPI v2, with seamless integration of the Launch Pad.

## Installation
### Build gem from source

To build the Ruby code into a gem:

```shell
gem build snap_business_sdk.gemspec
```

Then install the gem locally:

```shell
gem install <path-to-gem>
```

Finally add this to the Gemfile:

    gem 'snap_business_sdk', '~> 1.0.0'

## Getting Started
### Sending Production Events
Please follow the [installation](#installation) procedure and then run the following code to send conversion events to Snap Conversion API. More conversion parameters are expected to be provided in practice, and you can find more examples under the `examples` directory.

```ruby
# Load the gem
require 'snap_business_sdk'

# provide your pixel id and api auth token here
PIXEL_ID = '<insert-pixel-id>'
TOKEN = '<insert-capi-token>'

# create a new capi object
capi = SnapBusinessSDK::ConversionApi.new TOKEN

# create a sample purchase event
event = SnapBusinessSDK::CapiEvent.new()
event.pixel_id = PIXEL_ID
event.event_conversion_type = 'WEB'
event.event_type = 'PURCHASE'
event.timestamp = (Time.now.to_f * 1000).to_i
event.event_tag = 'event_tag_example'
event.uuid_c1 = '34dd6077-e3a0-4b1c-9f91-a690ea0e335d'
event.item_category = 'item_category_example'
event.item_ids = 'item_ids_example'
event.description = 'description_example'
event.number_items = 'number_items_example'
event.price = 'price_example'
event.currency = 'USD'
event.transaction_id = 'transaction_id_example'
event.level = 'level_example'
event.client_dedup_id = 'client_dedup_id_example'
event.search_string = 'search_string_example'
event.page_url = 'page_url_example'
event.sign_up_method = 'sign_up_method_example'

# these fields will be automatically hashed before being sent to CAPI
event.email = 'usr1@gmail.com'
event.ip_address = '202.117.0.20'
event.phone_number = '123-456-7890'
event.first_name = 'test_first'
event.middle_name = 'test_middle'
event.last_name = 'test_last'
event.city = 'test_city'
event.state = 'test_state'
event.zip = 'test_zip'

# call the api
prom = capi.send_event event

# optionally wait for the async request to complete if you want to handle responses
prom.wait

puts "Response: #{prom.value}"
```

### Send a batch of CAPI events (up to 2000)
```ruby
# Load the gem
require 'snap_business_sdk'

# provide your pixel id and api auth token here
PIXEL_ID = '<insert-pixel-id>'
TOKEN = '<insert-capi-token>'

# create a new capi object
capi = SnapBusinessSDK::ConversionApi.new TOKEN

# create a sample purchase event
event0 = SnapBusinessSDK::CapiEvent.new(
  pixel_id: PIXEL_ID,
  event_conversion_type: 'WEB',
  event_type: 'PURCHASE',
  timestamp: (Time.now.to_f * 1000).to_i,
)
event0.email = 'usr1@gmail.com'
event0.ip_address = '202.117.0.20'
event0.phone_number = '123-456-7890'

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
```

### Sending Test Events
Snap’s Conversion API provides the validate, log, and stats endpoints for advertisers to test their events and obtain more information on how each of the test event was processed.

Creating and setting up a test event is the same as setting up to send a production event. Clients must simply call the SendTestEvent function instead of the production functions.

The stats and logs should be called after sending and receiving a successful response from the test event endpoint.
```ruby
# send a test event, this show what fields are problematic
resp = capi.send_test_event event

# get a history of validated events for a given pixel id
resp_logs = capi.get_test_event_logs PIXEL_ID
resp_stats = capi.get_test_event_stats PIXEL_ID
```
## General usage
### Initiate ConversionApi
If a [Snap Launchpad](https://github.com/Snapchat/launchpad) has been set up under your domain, and you wish to send conversion events there instead of the public Snap owned `tr.snapchat.com` API, instantiate the `ConversionApi` object with the your launchpad's domain
```ruby
SnapBusinessSDK::ConversionApi.new TOKEN, launchpad_url: 'launchpad_url'
```    
Otherwise, you can initiate the instance using the default endpoint with
```ruby
SnapBusinessSDK::ConversionApi.new TOKEN
```

### CAPI auth token
To use the Conversions API, you need to use the access token for auth. See [here](https://marketingapi.snapchat.com/docs/conversion.html#auth-requirements) to generate the token.
### Build conversion events
Please check with the section [Conversion Parameters](https://marketingapi.snapchat.com/docs/conversion.html#additional-data-formatting-guidelines) and provide as much information as possible when creating the `CapiEvent` object. All fields listed here should be supported by the SDK.

Every CAPI attribute has a corresponding setter in the `CapiEvent` class following the `snake_case` naming convention.

At least one of the following parameters is required in order to successfully send events via the Conversions API. When possible, we recommend passing all of the below parameters to improve performance:
-   `hashed_email`
-   `hashed_phone`
-   `hashed_ip and user_agent`
-   `hashed_mobile_ad_id`

Any setter starting with the “hashed” prefix (ie. `hashedEmail`) accepts hashed values only (see [Data Hygiene](https://marketingapi.snapchat.com/docs/conversion.html#data-hygiene)). Please use the plaintext setter (ie. `email`) to have the SDK hash the plaintext value on your behalf.

We highly recommend passing cookie1 `uuid_c1`, if available, as this will increase your match rate. You can access a 1st party cookie by looking at the `_scid` value under your domain if you are using the Pixel SDK.
    
### Send events asynchronously
Conversion events can be sent individually via `send_event(CapiEvent capi_event)`.
Conversion events can be reported in batch using `send_events(Array<CapiEvent> capi_events)` if they are buffered in your application. Please check example/send_events.rb for more details. We recommend a 1000 QPS limit for sending us requests. You may send up to 2000 events per batch request, and can thus send up to 2M events/sec. Sending more than 2000 events per batch will result in a 400 error.
    
By default, both functions aboveEvents are asynchronous, so you can send and forget. The response is logged if debug mode is enabled. Else, you can wait on the response object as this SDK uses `concurrent-ruby` (see [Promise](https://ruby-concurrency.github.io/concurrent-ruby/1.1.5/Concurrent/Promise.html)).
    
### Debugging Mode
When debugging mode is turned on, the SDK will log events, API call response and exceptions using the standard Ruby [Logger](https://ruby-doc.org/stdlib-2.7.0/libdoc/logger/rdoc/Logger.html). You may override this logger with your own when instantiating a ConversionApi object  
```ruby
SnapBusinessSDK::ConversionApi.new TOKEN, logger: Logger.new(STDOUT)
```
