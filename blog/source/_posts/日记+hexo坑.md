﻿---
title: 日记+hexo坑
date: 2017-03-29 11:42:10
tags: 日记
categories: hexo,日记
---

搞了两天的博客快搞好，遇坑无数。到公司已经是第四周，距离上次做事已经闲了两周了。无聊的学习也无法集中，搞博客也是干无聊的事。接下来就谈谈博客的一些坑吧。
先谈谈**YML**的坑。部署博客主要就是要修改config.yml 其中值得注意的就是在**冒号后面要有一个空格**，还有就是一个属性有几个对象而下面写的对象不能顶格写。推荐一个在线检查语法工具YMLlint。这个和主题的配置文件有错误hexo g 都会出错。若果提交出错最好检查配置文件的语法问题。新手问题！！！
再有就是配置主题就不说怎么配置了，谷歌百度一大堆教程，简单点就是config的修改。
遇到费时很久的坑就是**部署百度站点和谷歌站点验证**的时候。因为第一次做，看教程也是完全按照教程步骤。
- 加上meta信息验证
- hexo c
- hexo g
- hexo d
- 刷新页面去站长工具点击完成验证。

然并卵，每次一刷新meta信息就自动删除，谷歌很久都没找到是什么原因。大概还是新手，不是很懂hexo的工作。在刷知乎偶尔看见一个谈hexo g 的回答。hexo g 对于新手来说可能就是一个命令，其实这是在生成静态页面，而hexo c 我一命令就出现错误 没有该命令。谷歌挺久发现应该是hexo clean。当你在index.html中加入meta并保存后，你再clean ，g 就是重新生成的index 和相关文件。g一次都是重新生成，你以前的修改都不见了。所以**正确的姿势**应该是hexo g后再去加入 meta 然后deployer，这样就能完成验证。

<iframe frameborder="no" border="0" marginwidth="0" marginheight="0" width=0 height=0 src="//music.163.com/outchain/player?type=2&id=436514312&auto=1&height=66"></iframe>


