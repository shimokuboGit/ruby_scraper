require 'rubygems'
require 'csv'
require 'date'
require 'time'
require_relative 'client'
require_relative 'domain/mystery_from_browser'
require_relative 'domain/mystery_from_browsers'
require_relative 'domain/mystery'
require_relative 'domain/mysteries'
require_relative 'export'

class Main
  def self.extract_start_date(mystery_content)
    match_date = mystery_content.match(/(\d{4})年(\d{2})月(\d{2})日/)
    if match_date
      date = match_date[1..3].join('-')
    else
      date = nil
    end
    date
  end

  @client = Client.new

  links = @client.get_all_mystery_links
  # links = Array.new
  # links.push('https://huntersvillage.jp/quest/na-record')

  mystery_from_browsers = MysteryFromBrowsers.new
  links.map do |link|
    sleep 1
    mystery_from_browsers.push(@client.get_mystery_content(link))
  end

  mysteries = Mysteries.new
  mystery_from_browsers.mystery_from_browsers.map do |mystery_from_browser|
    puts mystery_from_browser

    mysteries.push(Mystery.new(
      [ *'a'..'z', *'A'..'Z', *0..9].sample(22).join,
      nil,
      nil,
      mystery_from_browser.title,
      mystery_from_browser.image,
      mystery_from_browser.url,
      nil,
      (mystery_from_browser.story + '<br><br>' + mystery_from_browser.content).gsub(/\n/, '<br>'),
      nil,
      extract_start_date(mystery_from_browser.content),
      nil,
      1,
      nil,
      nil,
      nil,
      Time.new,
      false,
      '自宅',
      '自宅',
      '持ち帰り謎解き',
      'タカラッシュ',
      false
    ))
  end

  export = Export.new
  export.add_row(mysteries)
  export.exclude_deplicate_mystery

end
