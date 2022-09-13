

# 个人空间源码

一直以来都想做一个个人网站，无奈没有时间，现在终于有点时间啦～
之前比较重要的内容会添加进来，后续再慢慢维护。

组件
---

![](https://img.shields.io/badge/博客框架-hexo-informational)
![](https://img.shields.io/badge/主题-butterfly-yellow)
![](https://img.shields.io/badge/统计信息-busuanzi-ff69b4)
![](https://img.shields.io/badge/评论系统-Twikoo-orange)
[![](https://img.shields.io/badge/地址-luckyu.com.cn-success)](https://luckyu.com.cn)


步骤和功能
---

- [x] 网站工信局和公安备案
- [x] 域名解析
- [x] 服务器
- [x] 域名跳转&防火墙
    - `nginx`&`ufw`
- [x] 代码环境
    - [x] 主题
    - [x] 博客配置
    - [x] 添加背景音乐
    - [x] 照片墙&视频等
- [x] 评论系统
    - [x] 邮件提醒
    - [x] 重启和备份
    - [x] 评论不显示
        - `index.html`后缀与否代表不同页面，在`twikoo.init({...`添加`path: window.location.pathname.replace('index.html','')`即可
- [x] 添加吸底
    - 使用网易云榜单
    - 使用随机榜单时，随机榜单字幕有重复问题
- [ ] pwa


背景音乐demo:

```md
{% meting "1901371647" "netease" "song" "autoplay" "mutex:true" "preload:auto" %}
<div class="aplayer no-destroy" data-id="1441758494" data-server="netease" data-type="song" data-autoplay="false" data-lrcType="-1"></div>
```

- server可选：netease（网易云音乐），tencent（QQ音乐），kugou（酷狗音乐），xiami（虾米音乐），baidu（百度音乐）。建议网易云
- type可选：song（歌曲），playlist（歌单），album（专辑），search（搜索关键字），artist（歌手）。添加单曲选的歌曲，歌单选择playlist，可以自行尝试。
- id获取示例: 打开网易云音乐，选择喜欢的歌单，在网页版打开，获取歌单list，填入即可。使用的时候将上边的ID号换为自己喜欢的歌单即可。注意歌单中不能包括VIP音乐，否则无法解析。建议单独建立一个歌单，以后有喜欢的音乐添加进去，网页也会自动同步添加。
- lrcType设置为 -1默认显示歌词，放在fixed模式下比较合适。
