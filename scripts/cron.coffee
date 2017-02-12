cronJob = require('cron').CronJob
cheerio = require('cheerio');
request = require('request');


module.exports = (robot) ->

  # Crontabの設定方法と一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  new cronJob('0 0 10-18 * * 2,4', () ->
    # 公式HPを叩く
    url = 'http://www.shufu.co.jp/contents/kapibara/'
    channel_id = process.env.CAPYBARA_CHANNEL_ID
    console.log('cron acceccing to capybara-san site...')

    request url, (_, res) ->
      $ = cheerio.load res.body
      comic_url = $('#comic_box img').attr('src')

      current_comic_url = robot.brain.get('capybara_comic') ? '';

      if comic_url isnt current_comic_url
        message = """あたらしい よんこまが こうしんされました！
        みつけてきました！ どうぞ！
        #{url}#{comic_url}"""

        robot.messageRoom(channel_id, message)
        robot.brain.set('capybara_comic', comic_url)


  ).start()
