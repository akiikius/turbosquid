require 'selenium-webdriver'
require 'rspec'
require 'rspec/core/project_initializer/spec/spec_helper'
include RSpec::Matchers
require 'rspec/expectations'
require 'allure-rspec'
require 'uuid'
#require 'spec/runner/formatter/base_formatter'


class AbstractPage

  def initialize(driver)
    @driver = driver
  end

  def navigate_to_app_root
    @driver.navigate.to('http://www.turbosquid.com/')
    self
  end

  def navigate_to_login_page
    @driver.find_element(:id, 'nav-Login').click
    LoginPage.new(@driver)
  end

  def quit
    @driver.quit
  end
end

class LoginPage < AbstractPage

  def fill_in_username (username)
    @driver.find_element(:id, 'txtName')
        .send_keys (username)
    @driver.action.send_keys(:tab)
    self
  end

  def fill_in_password (password)
    @driver.find_element(:id, 'txtPassword')
        .send_keys (password)
    @driver.action.send_keys(:tab)
    self
  end

  def press_enter
    @driver.find_element(:class, 'btnPopLogin').click
    self
  end

  def print_image_titles
    #@driver.find_element(:partial_link_text, 'HORS').click
    #first_window = @driver.window_handle
    #bucking = @driver.find_element(:css, '#Asset19>table>tbody>tr>td>a>img')
    titles = @driver.find_elements(:tag_name, 'h3')
    titles.each do |item|
      puts 'the value for this item is: ' + item.text
      self
    end

    @driver.find_element(:partial_link_text, 'HORS').click
    #first_window = @driver.window_handle
    images = @driver.find_elements(:tag_name, 'a')

    images.each do |item|
      @driver.action.move_to(item).perform
      self
    end

    def html_report

      RSpec.configure do |config|
        #let(:app) { AbstractPage.new(driver) }
        #config.include AllureRSpec::Adaptor

        config.before(:each) do
          #let(:app) { AbstractPage.new(driver) }
          config.include AllureRSpec::Adaptor
          @driver = Selenium::WebDriver.for :firefox
        end

        config.after(:each) do |example|
          if example.exception
            example.attach_file('screenshot', File.new(
                @driver.save_screenshot(
                    File.join(Dir.pwd, "results/#{UUID.new.generate}.png"))))
            config.output_dir = 'TURBO2'
          end
          #@driver.quit
        end

        #AllureRSpec.configure do |config|
         # config.output_dir = 'TURBO2'
          #config.clean_dir = true # this is the default value
        #end
      end

    end
    #images.each do |item|
      #@driver.action.move_to(item).send_keys(:enter).perform
      #self
      #@driver.action.context_click(item).send_keys(:enter).perform

      #all_windows = @driver.window_handles
      #new_window = all_windows.select {|this_window| this_window != first_window}
      #@driver.switch_to.window(first_window)
      #@driver.switch_to.window(new_window)
      #@driver.action.move_to(images).perform
    #end
    #@driver.find_element(:partial_link_text, 'HORS').click
    #first_window = @driver.window_handle
    #bucking = @driver.find_element(:css, '#Asset19>table>tbody>tr>td>a>img')
    #all_windows = @driver.window_handles
    #new_window = all_windows.select {|this_window| this_window != first_window}
    #@driver.switch_to.window(first_window)
    #@driver.switch_to.window(new_window)
    #@driver.action.move_to(bucking).perform
    self
  end
end

RSpec.describe 'test' do
  let(:driver) { Selenium::WebDriver.for(:firefox) }
  let(:app) { AbstractPage.new(driver) }
  #after do
    #app.quit
  #end

  it 'logs user into turbosquid' do
    app.navigate_to_app_root
        .navigate_to_login_page
        .fill_in_username('Akiikius')
        .fill_in_password('ladyisadog')
        .press_enter
        .print_image_titles
        #.html_report
  end
end
