# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /草/i, (res) ->
    res.send """
    ```
  　　/)――ヘ
　　 _／　　　　＼
　 ／　 ●　　　● ヽ    もっしゃもっしゃ
　｜　　　　 ▼　　 |
　｜　　　　 人　 ノ
　 U￣U￣￣￣￣U￣
    ```
    """

  robot.hear /かえりた/i, (res) ->
    res.send """
    ```
  　　/)――ヘ
　　 _／　　　　＼
　 ／　 ●　　　● ヽ    わかるー
　｜　　　　 ▼　　 |
　｜　　　　 人　 ノ
　 U￣U￣￣￣￣U￣
    ```
    """

  robot.hear /退社/i, (res) ->
    res.send """
    ```
  　　/)――ヘ
　　 _／　　　　＼
　 ／　 ●　　　● ヽ    おつかれやでー
　｜　　　　 ▼　　 |
　｜　　　　 人　 ノ
　 U￣U￣￣￣￣U￣
    ```
    """

  robot.hear /たいしゃ/i, (res) ->
    res.send """
    ```
  　　/)――ヘ
　　 _／　　　　＼
　 ／　 ●　　　● ヽ    おつかれやでー
　｜　　　　 ▼　　 |
　｜　　　　 人　 ノ
　 U￣U￣￣￣￣U￣
    ```
    """

  robot.respond /やかましい/i, (res) -> 
    res.send """
    ```
  　　/)――ヘ
　　 _／　　　　＼
　 ／　 ●　　　● ヽ    えへへ
　｜　//　　 ▼　// |
　｜　　　　 人　 ノ
　 U￣U￣￣￣￣U￣
    ```
    """

  # okane kaka 12000
  robot.hear /okane (keke|kaka) ([0-9]*)/i, (res) ->
    user = res.match[1]
    req_money = res.match[2]
    # ユーザーに紐づく借金額を取得して加算
    money = robot.brain.get(user) ? 0
    money = money + req_money

    robot.brain.set(user, money)
    res.send "#{user} は いま #{money} えんのしゃっきん！ おぼえました。"
    
  robot.hear /okane list (keke|kaka)/i, (res) ->
    user = res.match[1]
    money = robot.brain.get(res.match[1])
    mention = "@#{user}"

    res.send "@#{user} のしゃっきんは #{money} えんです。 はらってくださいね。" 

  robot.hear /okane ok (keke|kaka) ([0-9]*)/i, (res) ->
    user = res.match[1]
    req_money = res.match[2]
    # ユーザーに紐づく借金額を取得して減算
    money = robot.brain.get(user) ? 0

    if req_money > money
      res.send "そんなに かりてないです…"
    else
      money = money - req_money
      res.send "#{user} は #{req_money} かえしました！ のこりのしゃっきんは #{money} です。"

  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  # robot.hear /I like pie/i, (res) ->
  #   res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
