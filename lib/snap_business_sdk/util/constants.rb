module SnapBusinessSDK
  module Constants
    API_VERSION = 'v2'
    PROD_DOMAIN = 'tr.snapchat.com'
    STAGING_DOMAIN = 'tr-shadow.snapchat.com'
    USER_AGENT = 'BusinessSDK/' + VERSION.to_s + '/Ruby'
    USER_AGENT_WITH_PAD = USER_AGENT + ' (LaunchPAD)'
    INTEGRATION_SDK = 'business-sdk'
    TEST_MODE_HEADER = 'X-CAPI-Test-Mode'
    CAPI_PATH_HEADER = 'X-CAPI-Path'
    METRICS_HEADER = 'X-CAPI-BusinessSDK'
    METRICS_HEADER_VALUE = 'Ruby/' + VERSION.to_s
    CAPI_PATH = '/' + API_VERSION + '/conversion'
    CAPI_PATH_TEST = CAPI_PATH + '/validate'
  end
end
