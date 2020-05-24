desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  require 'line/bot'  # gem 'line-bot-api'

  client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }

  calender = Calender.find_by(date: Date.today.in(1.days))
  next_day = Calender.where('date > ?', calender.date).where(garbage_type: calender.garbage_type).first.date.strftime('%m月%d日')
  today_garbage = {burnable: '燃えるゴミ', unburnable: '燃えないごみ・古紙類', petbottle: 'ペットボトル', cans: '缶', others: 'ビン・古着・危険ごみ・白色トレイ'}[calender.garbage_type&.to_sym]

  if today_garbage
    push =
      "こんばんはグワァー。\n明日は#{today_garbage}だグワァー。\nもし忘れると次は#{next_day}に捨てるハメになるグワ。\n絶対に忘れないで欲しいグワァー。"
    user_ids = User.all.pluck(:line_id)
    message = {
      type: 'text',
      text: push
    }
    response = client.multicast(user_ids, message)
  end
  "OK"
end
