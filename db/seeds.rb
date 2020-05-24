require 'csv'

CSV.read('./db/master_datas/calender.csv', headers: true).each do |row|
  type =
    case row[1]
      when '燃えるゴミ'
        :burnable
      when '燃えないゴミ・古紙類'
        :unburnable
      when 'ペットボトル'
        :petbottle
      when '缶'
        :cans
      when 'ビン・古着・危険ごみ・白色トレイ'
        :others
      end

  Calender.create!(date: row[0], garbage_type: type)
end
