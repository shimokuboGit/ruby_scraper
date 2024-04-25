require 'csv'
require_relative 'domain/mysteries'

class Export
  def add_row(mysteries)
    text =<<-EOS
id,prefecture_id,maker_id,title,img,url,story,content,place,startDate,endDate,minPeople,maxPeople,duration,price,created_at,subscription,prefecture,tag,category,maker,pickup
    EOS

    csv = CSV.generate(text, headers: true) do |csv|
      mysteries.mysteries.map do |mystery|
        csv.add_row(mystery)
      end
    end

    File.write('export_mystery.csv', csv)
  end

  def exclude_deplicate_mystery
    unless File.exist?('./mysteries_rows.csv') {
      return
    }
    exported_mysteries = CSV.table('./export_mystery.csv')
    existed_mysteries = CSV.table('./mysteries_rows.csv')

    exported_mysteries.delete_if do |exported_row|
      existed_mysteries.any? { |existed_row| existed_row[:title] == exported_row[:title] }
    end

    updated_csv = CSV.generate do |csv|
      csv << exported_mysteries.headers
      exported_mysteries.each do |row|
        csv << row
      end
    end

    File.write('./export_mystery.csv', updated_csv)
  end
end
