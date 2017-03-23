cronJob = require('cron').CronJob
request = require('request');
cheerio = require('cheerio');
moment = require('moment-timezone');

module.exports = (robot) ->

  # okane add kaka 12000
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

  new cronJob('0 0 7 * * 1-5', () ->
    url = 'http://www.kotsu.metro.tokyo.jp/subway/schedule/'
    channel_id = process.env.CAPYBARA_CHANNEL_ID
    robot.messageRoom(channel_id, 'おーえどせんが おくれてないか みてきます')
    console.log(new Date + ' --- cron acceccing to subway site...')

    request url, (_, res) ->
      $ = cheerio.load res.body
      delay_info = $('.routeOedo').next().text();
      if delay_info isnt ''
        message = """みてきました！ こんなことが かいてありました
        #{delay_info}"""
      else
        message = """うまくいきませんでした、ごめんなさい…
        url はっておきますね
        #{url}"""

      robot.messageRoom(channel_id, message)

  , null, true, "Asia/Tokyo").start()

  robot.respond /でんしゃ/i, (res) ->
    url = 'http://www.kotsu.metro.tokyo.jp/subway/schedule/'
    console.log(new Date + ' --- robot acceccing to subway site...')

    request url, (_, http_res) ->
      $ = cheerio.load http_res.body
      delay_info = $('.routeOedo').next().text();
      if delay_info isnt ''
        message = """みてきました！ こんなことが かいてありました
        #{delay_info}"""
      else
        message = """うまくいきませんでした、ごめんなさい…
        url はっておきますね
        #{url}"""

      res.send(message)

  robot.respond /かえる (keke|kaka)/i, (res) ->
    url = ''
    if res.match[1] is keke
      url = 'http://transit.yahoo.co.jp/station/time/22958/'
    else
      url = 'http://transit.yahoo.co.jp/station/time/22507/?gid=3410'

    console.log(moment().tz("Asia/Tokyo").format() + ' --- robot acceccing to timetable site...')
    request url, (_, http_res) ->
      $ = cheerio.load http_res.body
      date_now = new Date(moment().tz("Asia/Tokyo").format('YYYY/MM/DD hh:mm:ss'))
      hour = date_now.getHours()
      minute = date_now.getMinutes()

      timetable_minutes = []
      $("#hh_#{hour} td ul li dl dt").each ->
        time = $ @
        timetable_minutes.push(time.text())

      # 5, 11, 14 ...のような形で入っている
      for timetable_minute in timetable_minutes
        if timetable_minute > minute
          res.send("""つぎに ふたごたまがわからでるでんしゃは、#{hour}じ#{timetable_minute}ふん です！ """)
          break;


