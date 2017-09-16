---
title: NodeDNSParse 记录
date: 2017-09-11 23:27:28
tags: [node]
categories: node
---

本个小日志主要记录一个node小项目，查询域名的ip地址。主要用到的node 模块有FS,URL,DNS，Query Strings
## FS
    fs 主要用于读取文件渲染静态页面,读取文件函数代码如下。
```
function readFileHandle(req,res,filename,type){
 fs.readFile(filename,function(err,type){
    if(err){
        //这里有一个错误处理函数
        utils.HandleError(err,type)
        res.writeHead(404)
        res.end("404")
    }else{
        \\....
    }
 })
 }
```

static 文件放在public目录下，例如读取index文件.

```
exports.index = function(){
    var pathname = "../../public/html/index.html"
    var filename = path.join(__dirname,pathname)
    readFile.readFileHandle(req,res,filename,"welcome to homepage")
}
```
## URL
URL 主要用到它的解析功能获取到查询参数.在前端页面中发送请求会传入hostname 参数到服务来，url获取这个参数去完成后面的动作。
```
var url = url.parse(req.url).query
```
这里就直接获取到包含参数的那段代码,下面是URL的组成，在这里我们获取的就是query那段，接下里就获取的query传入到querystring处理获得从前端传过来的houstname参数。
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                    href                                     │
├──────────┬┬───────────┬─────────────────┬───────────────────────────┬───────┤
│ protocol ││   auth    │      host       │           path            │ hash  │
│          ││           ├──────────┬──────┼──────────┬────────────────┤       │
│          ││           │ hostname │ port │ pathname │     search     │       │
│          ││           │          │      │          ├─┬──────────────┤       │
│          ││           │          │      │          │ │    query     │       │
"  http:   // user:pass @ host.com : 8080   /p/a/t/h  ?  query=string   #hash "
│          ││           │          │      │          │ │              │       │
└──────────┴┴───────────┴──────────┴──────┴──────────┴─┴──────────────┴───────┘
```
##  Query Strings
将查询参数解析成一个对象用来直接获取到hostname传入到DNS的解析中，这里的返回会是一个对象。假设传入的是hostname="weibo.come"&&a=1.它会被解析成
```
{
    hostname:"weibo.com",
    a:1,
}
```
```
var query = query_string.parse(url)
```
##  DNS
    DNS用一个resolve4 API 可直接解析获得ip地址.dns 接收到前面的query 对象。
```
dns.resolve4(query['hostname'],function(err,addresses){
    if(err){
        utils.HandleError(err,"URL parse err")
        res.writeHead(404)
        res.end("错误")
    }else{
        res.writeHead(200)
        res.end(JSON.stringify(addresses)
    }
})
```

## 常规模块 router做路由
```
    exports.router = function(req,res){
        var url = url.parse(req.url)
        var pathname = url.pathname
        
        utils.record("PATH:" + pathname)
        switch(pathname){
            case '/dns':
                DNSService.dnsparse(req,res,pathname)
                break;
            case '':
            case '/':
            case '/index':
                readFile.index(req,res)
                break;
            default:
                readFile.static(req,res,pathname)
        }
    }
```
这个小项目的主要思路就是这样，难点就是api 的使用，需要参照接口文档来做。后期看能不能用express 重构。