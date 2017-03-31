---
title: 浅谈原生js的ajax学习
date: 2017-03-31 09:17:41
tags: [ajax,javascript]
categories: javascript
---
写这篇谈ajax的文章主要是为了记录在很久不写ajax，出了一个很低级的问题其本质还是自己没有把ajax搞的很明白。
### ajax是用来干什么的
简单说ajax就是用来与后台进行交互而不用刷新整个页面，而ajax的实现主要是靠XHR对象实现。
### XHR对象
XHR是XMLHttpRequest的缩写。而要实现ajax主要就是操作这个XHR对象，在IE版本之下并不支持此对象而是ActiveXObject。再ie7下就是ActiveX了。
```
function creatXHR(){
	if(typeof XMLHttpRequest !='undefined'){
		return new XMLHttpRequest;
	}else if(typeof ActiveXObject !='undefined'){
		if(typeof arguments.callee.activeXString != 'string'){
			var versions =['MSXML2.XMLHttp.6.0','MSXML2.XMLHttp3.0','MSXML2.XMLHttp'],
			i,len;
			for(i=0,len=versions.length,i<len,i++){
				try{
					new ActiveXObject(versions[i]);
					arguments.callee.activeXString = version[i];
					break;
				}catch(ex){
					//
				}
			}
		}
		return new ActiveXObject(arguments.callee.activeXString);
		
	}else{
		throw new Error("NO XHR object available");
	}
}
```
以上代码就是在兼容性更好的创建一个XHR对象。
接下来就是要准备发送请求给服务器了，那么会用到xhr的open方法。
#### open()
```
xhr.open('',url,async);
```
第一个参数是请求的方式，eg GET,POST,PUT...详见http的请求类型
第二个参数是请求链接，有相对路径和绝对路径（后面跨域会说最好使用绝对路径）
第三个参数是同步还是异步方式，false-同步，true-异步。
open方法起的一个启动发送请求的作用，此时还没有发送请求。要发送请求需要用send方法。
#### send()
```
xhr.send(null/data);
```
send传入一个参数，null则是不需要向服务器发送数据通常可以省略，为了不出错最好写上。data则是需要向服务器发送的数据，通常是和POST方式一起使用。
发送完请求之后，服务器就该为此次请求返回响应，在浏览器接收到响应就会给XHR对象扩充几个属性。
responseText:响应主体返回的主体。
responseXML:如果响应内容类型是xml则会显示响应xml数据，不是则为null
status：响应状态码。详情见http
statusText：状态码的说明。
在发送异步请求时需要监测响应过程的活动阶段，XHR对象的readystate属性。
#### readystate
readystate主要分为几个值代表不同的阶段。
- 0：未初始化，没有调用open方法
- 1：启动，已经调用open但是还没有send
- 2：发送，调用了send但是还没有接收到响应
- 3：接收，接收到部分响应
- 4：完成，已经接收到全部响应，可以使用了。

通常需要对收到的数据做出一些反应则是通过readystatechange事件进行检测每次readystate变化，而我们只有在readystate为4后才可以用相关数据。所以可以这样写一些代码当响应完成获取到数据怎么用。
```
xhr.onreadystatechange=function(){
    if(xhr.readystate == 4){
        if(xhr.status == 200){
            alert(xhr.responseText);
        }else{
            alert(xhr.status);
        }
    }
}
```

#### abort()
abort方法主要是用于取消请求。

本人在写一个ajax的时候犯了一个低级错误，而本质上还是没有意识到某个细节。一切想得有点自以为了，代码如下。
```
function testajax(){
	var request = new XMLHttpRequest;
	request.open('GET','url');
	request.send();
	if(request.readyState==4){
		if(request.status == 200){
			console.log(request);
			var rps=request.response;
			var obj = JSON.parse(rps);
			console.log(obj);
			if(data.Id==obj.ResponseStatus.Extension.Id&&data.Value==obj.ResponseStatus.Extension.Value){
				alert(obj.IsShowFloat);
			}else{
				alert(obj.ResponseStatus.Errors[0].Message);
			}
			
		}else{
			alert("响应失败状态码"+request.status);
		}
};
testajax();
```
这段代码在大致看来可能会觉得是对的，在控制台调试的时候并不能打印出request的相关信息。但是把console 放在if 外面又能够打印出。这就说明在函数执行的时候根本没有进入到if代码块去，其实这段代码的错误就是没有添加readystatechange的事件处理程序，没有监测到readystate的变化。所以进不去if。需要把整个if代码块放在readystatechange的事件处理程序里面就是对的了。
本文也主要是记录下自己踩的坑，如有没讲对的地方望指出。

