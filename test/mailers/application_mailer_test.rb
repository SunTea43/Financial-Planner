require "test_helper"

class ApplicationMailerTest < ActionMailer::TestCase
  test "should have default from address configured" do
    assert_not_nil ApplicationMailer.default[:from]
  end

  test "should use mailer layout" do
    assert_equal "mailer", ApplicationMailer._layout
  end
end
