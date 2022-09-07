# snap_business_sdk

SnapBusinessSDK - the Ruby gem for the Snap Conversions API

No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)

This SDK is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 1.0.0
- Package version: 1.0.0
- Build package: org.openapitools.codegen.languages.RubyClientCodegen

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build snap_business_sdk.gemspec
```

Then either install the gem locally:

```shell
gem install ./snap_business_sdk-1.0.0.gem
```

(for development, run `gem install --dev ./snap_business_sdk-1.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'snap_business_sdk', '~> 1.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/GIT_USER_ID/GIT_REPO_ID, then add the following in the Gemfile:

    gem 'snap_business_sdk', :git => 'https://github.com/GIT_USER_ID/GIT_REPO_ID.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:

```ruby
# Load the gem
require 'snap_business_sdk'

# Setup authorization
SnapBusinessSDK.configure do |config|
  # Configure Bearer authorization (JWT): bearerAuth
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = SnapBusinessSDK::DefaultApi.new
asset_id = 'asset_id_example' # String | 

begin
  result = api_instance.conversion_validate_logs(asset_id)
  p result
rescue SnapBusinessSDK::ApiError => e
  puts "Exception when calling DefaultApi->conversion_validate_logs: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://tr.snapchat.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*SnapBusinessSDK::DefaultApi* | [**conversion_validate_logs**](docs/DefaultApi.md#conversion_validate_logs) | **GET** /v2/conversion/validate/logs | 
*SnapBusinessSDK::DefaultApi* | [**conversion_validate_stats**](docs/DefaultApi.md#conversion_validate_stats) | **GET** /v2/conversion/validate/stats | 
*SnapBusinessSDK::DefaultApi* | [**send_data**](docs/DefaultApi.md#send_data) | **POST** /v2/conversion | 
*SnapBusinessSDK::DefaultApi* | [**send_test_data**](docs/DefaultApi.md#send_test_data) | **POST** /v2/conversion/validate | 


## Documentation for Models

 - [SnapBusinessSDK::CapiEvent](docs/CapiEvent.md)
 - [SnapBusinessSDK::Response](docs/Response.md)
 - [SnapBusinessSDK::ResponseErrorRecords](docs/ResponseErrorRecords.md)
 - [SnapBusinessSDK::ResponseLogs](docs/ResponseLogs.md)
 - [SnapBusinessSDK::ResponseLogsLog](docs/ResponseLogsLog.md)
 - [SnapBusinessSDK::ResponseStats](docs/ResponseStats.md)
 - [SnapBusinessSDK::ResponseStatsData](docs/ResponseStatsData.md)
 - [SnapBusinessSDK::ResponseStatsTest](docs/ResponseStatsTest.md)
 - [SnapBusinessSDK::TestResponse](docs/TestResponse.md)
 - [SnapBusinessSDK::ValidatedFields](docs/ValidatedFields.md)
 - [SnapBusinessSDK::ValidatedFieldsItems](docs/ValidatedFieldsItems.md)


## Documentation for Authorization


### bearerAuth

- **Type**: Bearer authentication (JWT)

