
---
title: first blood
date: 2022-08-07 10:20:55
type: "untype"
---

# test

## more title

*字体样式test*


**待添加功能**

- [x] 首页背景
- [x] 滚动副标题
- [ ] 评论
    - 待审核
- [x] 添加音乐
  - `{% meting "1901371647" "netease" "song" "autoplay" "autoplay:true" "mutex:true" "preload:auto" %}`
  - `<div class="aplayer no-destroy" data-id="1441758494" data-server="netease" data-type="song"  data-autoplay="false" data-lrcType="-1"></div>`
    - server可选：netease（网易云音乐），tencent（QQ音乐），kugou（酷狗音乐），xiami（虾米音乐），baidu（百度音乐）。建议网易云
    - type可选：song（歌曲），playlist（歌单），album（专辑），search（搜索关键字），artist（歌手）。添加单曲选的歌曲，歌单选择playlist，可以自行尝试。
    - id获取示例: 打开网易云音乐，选择喜欢的歌单，在网页版打开，获取歌单list，填入即可。使用的时候将上边的ID号换为自己喜欢的歌单即可。注意歌单中不能包括VIP音乐，否则无法解析。建议单独建立一个歌单，以后有喜欢的音乐添加进去，网页也会自动同步添加。
    - lrcType设置为 -1默认显示歌词，放在fixed模式下比较合适。
- [ ] 添加吸底


demo:

```md
{% meting "1901371647" "netease" "song" "autoplay" "mutex:true" "preload:auto" %}
<div class="aplayer no-destroy" data-id="1441758494" data-server="netease" data-type="song" data-autoplay="false" data-lrcType="-1"></div>
```

{% meting "1901371647" "netease" "song" "autoplay" "mutex:true" "preload:auto" %}
<div class="aplayer no-destroy" data-id="1441758494" data-server="netease" data-type="song" data-autoplay="false" data-lrcType="-1"></div>


