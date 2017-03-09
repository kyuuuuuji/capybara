module.exports = (robot) ->

  robot.hear /わっしょい/i, (res) ->
    res.send """
    ```
　　　　　 /)      /)
　　　 _／　　￣￣ 　＼    わっしょい！
　　／　　　　　　　　  ヽ
　/　　　　●　　　　　●  ヽ
　!　　　　　　 　 ▼　 　 l
　ヽ_ 　 　　　   人    ノ
　　　゛゛ーＪ―――――――J''
    ```
    """

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

  robot.hear /もやし/i, (res) ->
    res.send 'うっうー！'
