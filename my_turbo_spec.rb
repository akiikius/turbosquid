require 'selenium-webdriver'
require 'rspec/expectations'
require 'junit_report_generator'


def setup
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

def get_notification_message
  @notification_message = @driver.find_element(:class, 'ErrorMessage').text
end

def retry_if_message_contains(fail_message)
  count = 0
  yield
  until !@notification_message.include? fail_message || count == 3
    yield
    count =+ 1
  end
end

run {
  retry_if_message_contains 'Wrong Password or Member Name' do

    @driver.navigate.to ('http://www.turbosquid.com')
    @driver.find_element(:id, 'nav-Login').click
    @driver.find_element(:id, 'txtName').send_keys('akks')
    @driver.action.send_keys(:tab)
    @driver.find_element(:id, 'txtPassword').send_keys('xoxoxo')
    @driver.action.send_keys(:tab)
    @driver.find_element(:class, 'btnPopLogin').click
    first_window = @driver.window_handle
    flag =  @driver.find_element(:class, 'ErrorMessage').text
    all_windows = @driver.window_handles
    new_window = all_windows.select {|this_window| this_window!= first_window}
    @driver.switch_to.window(first_window)
    @driver.switch_to.window(new_window)
    @driver.action.move_to(flag)
    get_notification_message
  end
  @notification_message.should =~ /Action successful/
}