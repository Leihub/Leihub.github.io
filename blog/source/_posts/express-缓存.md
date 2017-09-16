---
title: express 缓存
date: 2017-09-16 22:18:25
tags: node
---

本文主要是记录做这个小实现遇到的问题和总结。
先说一下实现思路，在这里使用了npm的包（"memory-cache"）来做缓存，express做路由。重写了res.send,把设置缓存写进res.send 里面。完成send后把中间件转交给下一个中间件。这里缓存了整个页面。
```
var mcache = require("memory-cache")
var cache = function(duration){
    return function(req,res,next){
        var key = req.originUrl || req.url
        var mcachebody = mcache.get(key)
        if(mcachebody){
            res.send(mcachebody)
            return
        }else{
            res.sendResponse = res.send
            res.send = (body)=>{
                mcache.put(key,body,duration*1000) // duration 设置成多少秒
                res.sendResponse(body)
            }
            next()
        }
    }
}
```
核心设置缓存就是以上代码，在实际使用中
```
app.get("/",cache(10),(req,res)=>{
    setTimeout(()=>{
        res.render("index",{name:"hello",title:"sb",date:new Date()})
    },2000)
})
app.get('/user/:id',cache(10),(req,res)=>{
    setTimeout(()=>{
        if(req.params.id ==1){
            res.json({id:1,name:"hi"})
        }else if(req.params.id ==2){
            res.json({id:2,name:"lei"})
        }
    },1000)
})
app.use((req,res)=>{
    res.status(404).send("not found")
})
app.listen(3000,()=>{
    console.log("run on 3000 port")
})
```

在浏览器中打开localhost:3000，在2s后响应成功，设置了10s的缓存时间，10s内刷新整个页面都不会有改变（包括请求id） "localhost:3000/user/2" ，状态码也从200显示为304.这里顺便把状态码304搞懂了。

----
在第一次写这篇文的时候当时不知道还有一个缓存的状态码是200，后来去搞清楚了，还有一种状态码200，直接从本地浏览器的缓存，并没有跟后台发起请求，而304是发起请求询问后台这个缓存有效否，有效就直接从浏览器那里获得。关于http方面的内容本人没有很深究过，理解也较浅，这些也是自己所学习到的东西。

----

在实现的过程中主要遇到的问题就是http参数的请求解析没有搞清楚。解析http参数的方式主要是有以下几种。

 1. get请求查询类： /user?id=1;这里用query去解析参数出来。res.query.id //1
 2. get 路由类：本例中使用的 /user/2 ;param解析 res.param（参数）,也可以用res.params.参数,params的能力更强，可以解析更为复杂的路径。
### res.send()
用于向浏览器发送一个响应信息，如果是String则自动设置为content/type为text/html,如果是对象或者数组则设置为一个json对象，如果是数字就自动设置一个响应体  res.send(200) 返回一个OK。


