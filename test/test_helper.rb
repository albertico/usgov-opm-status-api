# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "usgov/opm/status/api"

require "webmock/minitest"
require "minitest/autorun"

# Currently, the intent is to allow the test suite to reach the real API endpoints as a
# a default,but make the HTTP library fail in certain tests to make sure that errors are
# being properly raised. As such, we will configure WebMock to block all network requests
# but will immediately disable WebMock globally. Disabling has the effect of allowing
# connections to be established regardless of the 'disable_net_connect!' configuration.
# Tests that require HTTP connections to fail or return certain responses will have to
# enable WebMock before their tests, stub the HTTP calls, and re-enable WebMock afterwards.
#
# See the following Github issue comment for additional context:
#  - https://github.com/bblimke/webmock/issues/897#issuecomment-690891902
#
WebMock.disable_net_connect!
WebMock.disable!
