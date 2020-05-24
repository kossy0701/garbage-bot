require 'line/bot'

class LinebotController < ApplicationController

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end
    calender = Calender.find_by(date: Date.today)
    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          input = event.message['text']
          case input
          when /.*(明日|あした).*/
            push = "明日は#{calender.garbage_type_str}だグワァー。"
          when /.*(明後日|あさって).*/
            push = "明後日は#{calender.garbage_type_str}だグワァー。"
          when /.*(かわいい|可愛い|カワイイ|きれい|綺麗|キレイ|素敵|ステキ|すてき|面白い|おもしろい|ありがと|すごい|スゴイ|スゴい|好き|頑張|がんば|ガンバ).*/
            push = "ありがとうグワァー。おいら頑張っちゃうグワァー。"
          when /.*(こんにちは|こんばんは|初めまして|はじめまして|おはよう).*/
            push =
              "こんにちはグワァー。今日もゆるキャラグランプリ１位を目指して大胸筋を鍛えるグワァー。"
          else
            push = "その言葉初めて聞いたグワァー。なんのゆるキャラグワか？"
          end
        else
          push = "そんなもの見せられても困るグワァー。"
        end
        message = {
          type: 'text',
          text: push
        }
        client.reply_message(event['replyToken'], message)
      when Line::Bot::Event::Follow
        line_id = event['source']['userId']
        User.create(line_id: line_id)
      when Line::Bot::Event::Unfollow
        line_id = event['source']['userId']
        User.find_by(line_id: line_id).destroy
      end
    }
    head :ok
  end

  private

    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
end
