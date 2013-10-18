window.SocialShareButton =
  openUrl : (url) ->
    window.open(url)
    false

  share : (el) ->
    site = $(el).data('site')
    title = encodeURIComponent($(el).parent().data('title') || '')
    img = encodeURIComponent($(el).parent().data("img") || '')
    url = encodeURIComponent($(el).parent().data("url") || '')
    if url.length == 0
      url = encodeURIComponent(location.href)
      
    if gon.gaqOn && gon.signedIn
      if url.indexOf("channel") != -1
        if gon.hashCode == gon.broadcast_session
          console.log "直播頻道-#{site} 主播分享 #{gon.hashCode}" 
          ga('send', 'event', '主播分享', "直播頻道-#{site}", gon.hashCode);
        else
          console.log "直播頻道-#{site} 聽眾分享 #{gon.hashCode}" 
          ga('send', 'event', '聽眾分享', "直播頻道-#{site}", gon.hashCode);
      else if url.indexOf("records") != -1
        if gon.hashCode == gon.broadcast_session
          console.log "直播紀錄-#{site} 主播分享 #{gon.hashCode}"
          ga('send', 'event', '主播分享', "直播紀錄-#{site}", gon.hashCode);
        else
          console.log "直播紀錄-#{site} 聽眾分享 #{gon.hashCode}"
          ga('send', 'event', '聽眾分享', "直播紀錄-#{site}", gon.hashCode);
    else if gon.gaqOn
      if url.indexOf("channel") != -1
        console.log "直播頻道-#{site} 聽眾分享 NA"
        ga('send', 'event', '聽眾分享', "直播頻道-#{site}", 'NA');
      else if url.indexOf("records") != -1
        console.log "直播記錄-#{site} 聽眾分享 NA"
        ga('send', 'event', '聽眾分享', "直播記錄-#{site}", 'NA');  
      
    switch site
      when "weibo"
        SocialShareButton.openUrl("http://service.weibo.com/share/share.php?url=#{url}&type=3&pic=#{img}&title=#{title}")
      when "twitter"
        SocialShareButton.openUrl("https://twitter.com/home?status=#{title}: #{url}")
      when "douban"
        SocialShareButton.openUrl("http://shuo.douban.com/!service/share?href=#{url}&name=#{title}&image=#{img}")
      when "facebook"
        SocialShareButton.openUrl("http://www.facebook.com/sharer.php?t=#{title}&u=#{url}")
      when "qq"
        SocialShareButton.openUrl("http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=#{url}&title=#{title}&pics=#{img}")
      when "tqq"
        SocialShareButton.openUrl("http://share.v.t.qq.com/index.php?c=share&a=index&url=#{url}&title=#{title}&pic=#{img}")
      when "baidu"
        SocialShareButton.openUrl("http://hi.baidu.com/pub/show/share?url=#{url}&title=#{title}&content=")
      when "kaixin001"
        SocialShareButton.openUrl("http://www.kaixin001.com/rest/records.php?url=#{url}&content=#{title}&style=11&pic=#{img}")
      when "renren"
        SocialShareButton.openUrl("http://widget.renren.com/dialog/share?resourceUrl=#{url}&srcUrl=#{url}&title=#{title}&pic=#{img}&description=")
      when "google_plus"
        SocialShareButton.openUrl("https://plus.google.com/share?url=#{url}&t=#{title}")
      when "google_bookmark"
        SocialShareButton.openUrl("https://www.google.com/bookmarks/mark?op=edit&output=popup&bkmk=#{url}&title=#{title}")
      when "delicious"
        SocialShareButton.openUrl("http://www.delicious.com/save?url=#{url}&title=#{title}&jump=yes&pic=#{img}")
      when "plurk"
        SocialShareButton.openUrl("http://www.plurk.com/?status=#{title}: #{url}&qualifier=shares")
      when "tumblr"
        get_tumblr_extra = (param) ->
          cutom_data = $(el).attr("data-#{param}")
          encodeURIComponent(cutom_data) if cutom_data

        tumblr_params = ->
          path = get_tumblr_extra('type') || 'link'

          params = switch path
            when 'text'
              title = get_tumblr_extra('title') || title
              "title=#{title}"
            when 'photo'
              title = get_tumblr_extra('caption') || title
              source = get_tumblr_extra('source') || img
              "caption=#{title}&source=#{source}"
            when 'quote'
              quote = get_tumblr_extra('quote') || title
              source = get_tumblr_extra('source') || ''
              "quote=#{quote}&source=#{source}"
            else # actually, it's a link clause
              title = get_tumblr_extra('title') || title
              url = get_tumblr_extra('url') || url
              "name=#{title}&url=#{url}"


          "/#{path}?#{params}"

        SocialShareButton.openUrl("http://www.tumblr.com/share#{tumblr_params()}")
    false
