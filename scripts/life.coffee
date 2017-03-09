module.exports = (robot) ->

  # okane kaka 12000
  robot.hear /okane add (keke|kaka) ([0-9]*)/i, (res) ->
    user = res.match[1]
    req_money = Number(res.match[2])
    # ユーザーに紐づく借金額を取得して加算
    money = robot.brain.get(user) ? 0
    money = money + req_money

    robot.brain.set(user, money)
    res.send "#{user} は いま #{money} えんのしゃっきん！ おぼえました。"
    
  robot.hear /okane status (keke|kaka)/i, (res) ->
    user = res.match[1]
    money = robot.brain.get(res.match[1])

    end_message = "はらってくださいね。"
    if money == 0
      end_message = "ゆうのう！"

    res.send "@#{user} のしゃっきんは #{money} えんです。 #{end_message}" 

  robot.hear /okane ok (keke|kaka) ([0-9]*)/i, (res) ->
    user = res.match[1]
    req_money = Number(res.match[2])
    # ユーザーに紐づく借金額を取得して減算
    money = robot.brain.get(user) ? 0

    if req_money > money
      res.send "そんなに かりてないです…"
    else
      money = money - req_money
      robot.brain.set(user, money)
      res.send "#{user} は #{req_money} かえしました！ のこりのしゃっきんは #{money} えんです。"

  robot.hear /okane clear (keke|kaka)/i, (res) ->
    user = res.match[1]

    robot.brain.set(user, 0)
    res.send "#{user} の しゃっきんは 0 えん に なりました！"
