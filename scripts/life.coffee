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
    station_name = ''
    if res.match[1] is 'keke'
      url = 'http://transit.yahoo.co.jp/station/time/22958/'
      station_name = 'ふたこたまがわ'
    else
      url = 'http://transit.yahoo.co.jp/station/time/22507/?gid=3410'
      station_name = 'いーだばし'

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
          res.send("""つぎに #{station_name}からでるでんしゃは、#{hour}じ#{timetable_minute}ふん です！ """)
          break;


  new cronJob('0 0 * * * *', () ->
    channel_id = process.env.CAPYBARA_CHANNEL_ID
    date_now = new Date(moment().tz("Asia/Tokyo").format('YYYY/MM/DD hh:mm:ss'))
    url = 'http://www.yodobashi.com/%E4%BB%BB%E5%A4%A9%E5%A0%82-Nintendo-Nintendo-Switch-Joy-Con-L-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%96%E3%83%AB%E3%83%BC-R-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%AC%E3%83%83%E3%83%89-Nintendo-Switch%E6%9C%AC%E4%BD%93/pd/100000001003431566/'
    console.log("#{date_now} --- cron acceccing to yodobashi site...")

    request url, (_, res) ->
      $ = cheerio.load res.body
      sales_info = $('.salesInfo').text()

      index = sales_info.indexOf('販売休止中です')
      if index isnt -1
        console.log("#{date_now} --- is salling...? please confirm it !")    
        robot.messageRoom(channel_id, 'switchうってるかも！かくにんしてください！')
        robot.messageRoom(channel_id, 'http://www.yodobashi.com/%E4%BB%BB%E5%A4%A9%E5%A0%82-Nintendo-Nintendo-Switch-Joy-Con-L-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%96%E3%83%AB%E3%83%BC-R-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%AC%E3%83%83%E3%83%89-Nintendo-Switch%E6%9C%AC%E4%BD%93/pd/100000001003431566/')
      else
        console.log("#{date_now} --- not sales yet...")    
  , null, true, "Asia/Tokyo").start()

  robot.respond /どうよ/i, (res) ->
    date_now = new Date(moment().tz("Asia/Tokyo").format('YYYY/MM/DD hh:mm:ss'))
    url = 'http://www.yodobashi.com/%E4%BB%BB%E5%A4%A9%E5%A0%82-Nintendo-Nintendo-Switch-Joy-Con-L-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%96%E3%83%AB%E3%83%BC-R-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%AC%E3%83%83%E3%83%89-Nintendo-Switch%E6%9C%AC%E4%BD%93/pd/100000001003431566/'
    console.log("#{date_now} --- robot acceccing to yodobashi site...")

    request url, (_, http_res) ->
      $ = cheerio.load http_res.body
      sales_info = $('.salesInfo').text()
      index = sales_info.indexOf('販売休止中です')
      if index is -1
        console.log("#{date_now} --- is salling...? please confirm it !")    
        res.send('switchうってるかも！かくにんしてください！')
        res.send('http://www.yodobashi.com/%E4%BB%BB%E5%A4%A9%E5%A0%82-Nintendo-Nintendo-Switch-Joy-Con-L-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%96%E3%83%AB%E3%83%BC-R-%E3%83%8D%E3%82%AA%E3%83%B3%E3%83%AC%E3%83%83%E3%83%89-Nintendo-Switch%E6%9C%AC%E4%BD%93/pd/100000001003431566/')
      else
        console.log("#{date_now} --- not sales yet...")    
