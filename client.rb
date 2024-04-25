require 'selenium-webdriver'
require 'yaml'
require_relative 'domain/mystery_from_browser'

class Client
  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.timeouts.implicit_wait = 500
  end
  def get_all_mystery_links
    # @driver = Selenium::WebDriver.for :chrome
    # @driver.manage.timeouts.implicit_wait = 500
    takarash_url = 'https://huntersvillage.jp/huntercat/mystery-kits'

    urls = (2..19).map {|i| "#{takarash_url}/page/#{i}"}
    all_url = [takarash_url] + urls

    links = Array.new
 
    all_url.map do |url|
      @driver.get url
      sleep 1
      elements = @driver.find_elements(css: '.bgBox01 .comButton a')
      elements.each do |element|
        links.push element.attribute('href')
      end
    end

    links
  end

  def get_mystery_content(url)
    @driver.get url

    return MysteryFromBrowser.new(
      @driver.find_element(css: 'p.topTitle').text.split("\n")[1],
      url,
      @driver.find_element(id: 'resultDetail img').attribute('src'),
      @driver.find_element(css: 'ul.txtList01').text,
      @driver.find_element(css: '.section').text,
    )
  end
end