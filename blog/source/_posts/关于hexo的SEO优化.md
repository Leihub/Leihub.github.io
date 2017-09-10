---
title: 关于hexo的SEO优化
date: 2017-03-29 16:34:26
tags: [SEO,hexo]
categories: hexo
---
搞了两天的博客从初建到考虑优化问题。由于本人是前端初涉者，所以对优化方面考虑比较多，网站的访问速度低了无疑是影响了用户体验。当然自己创建了博客就必然想让更多的人看见访问你的网站。所以优化变得更为重要。本文主要讲SEO优化方面，访问速度方面优化以后再讲。
hexo的优化主要是百度收录和谷歌收录。这里就讲一讲怎么做。
### 谷歌收录
做谷歌收录很简单而且收录的速度也很快，差不多第二天就能搜到网站了。
1.安装sitemap,在这里把百度的sitemap一起install了
```
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
```
在站点的config_yml文件中加入，这两行是在自动生成sitemap文件。
```
sitemap
  path: sitemap.xml
baidusitemap:
  path: baidusitemap.xml
```
注意这里加入之后要把站点config里面的url设置为自己的站点，不然hexo g之后生成的都是yoursite.com/sitemap.xml。这是我踩的坑之一。每次hexo g 之后 sitemap文件就变回原样。（这里对后面的设置站点工具有很大的作用）。
```
# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: https://leihoyoa.top/
```
#### 注册google search console
网站：<a href="https://www.google.com/webmasters/">search console</a>

添加自己的站点，验证的坑在上一篇文章已经说过了。此步很简单，在index.html的head里面加入<meta>验证代码就行了。验证结束后打开抓取里面的站点地图添加sitemap文件并测试，一般不会有错误，有错误修改就好了。我以前的错误就是url那里没有修改。
#### 添加蜘蛛协议
robots.txt 放置在 \source 目录下。在谷歌站点工具里面也设置并提交。
```
#hexo robots.txt
User-agent: *
Allow: /
Allow: /archives/
Disallow: /vendors/
Disallow: /js/
Disallow: /css/
Disallow: /fonts/
Disallow: /vendors/
Disallow: /fancybox/

Sitemap: https://leihoyoa.top/search.xml
Sitemap: https://leihoyoa.top/sitemap.xml
Sitemap: https://leihoyoa.top/baidusitemap.xml
```

![g2](http://onklxoiqv.bkt.clouddn.com/g2.png)

#### 设置抓取
![g1](http://onklxoiqv.bkt.clouddn.com/g1.png)
设置要抓取的子页面,我的显示重定向是由于我这里的站点是http:// 我设置了https://，所以重定向了https。状态有完成，部分完成，重定向等。

### 百度收录
百度收录跟谷歌是差不多的步骤，就是收录时间比较久，应该是一个考察期吧。
#### sitemap 方式提交
把baidusitemap.xml加入到网页抓取的链接提交栏。
![b1](http://onklxoiqv.bkt.clouddn.com/b1.png)

#### 自动推送
这里的自动推送就是在主题config里面设置baidu_push。本人用的Next主题，其他主题还是采用百度提供的方式做。
```
baidu_push: true
```

#### 主动推送

这种推送方式网上经验很多，可以安装一个插件工具。
```
npm install hexo-baidu-url-submit --save
```
安装好插件后，在站点配置文件中添加以下代码
```
baidu_url_submit:
  count: 3   ##最近提交的3个链接
  host: leihoyoa.top   ##你的百度站长工具平台提交的域名
  token: fwOrgoccmirV  ##你的密钥
  path: baidu_urls.txt  ## 会自动生成存放最近提交的链接
```
**复制该代码的时候最好把注释删除了。**我踩的坑之一。 
在deploy加一个type：baidu_url_submitter
```
deploy:
- type: git
  repo: 
      github: 
- type: baidu_url_submitter   
```
hexo g 一下就会生成baidu_urls.txt文件了。然后就提交了。
### 题外话
title优化
更改index.swig文件(your-hexo-site\themes\next\layout);
将代码
```
{% block title %} {{ config.title }} {% endblock %}
```
修改成：
```
{% block title %} {{ theme.keywords }} - {{ config.title }}{{ theme.description }} {% endblock %}
```
可以做到关键词，网站描述，网站标题显示在标题里。

本人第一次写博客写的不好就将看看，不明白的可以联系我。