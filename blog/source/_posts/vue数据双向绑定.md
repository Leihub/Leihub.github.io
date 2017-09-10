---
title: vue双向绑定的基本方法
date: 2017-09-10 16:18:47
tags: [vue,javascript]
categories: vue
---

---

vue的数据实现双向绑定主要是使用Object.defineProperty。本文所写的内容都是在拜读了某个大神的博文记录一下。
这里是用set 更新model和view层。寻找一个需要绑定的属性，将绑定属性的值传给内部class 的key 根据key来查找data[key]. 实现双向的核心就是监听input 实时更新view层。
1. 查找到绑定的属性
2. 实施数据的绑定

```
   class MVVM {
     constructor(options) {
         this.input = options.input
         this.output = options.output
         let data = this.data = options.data

         let key = null

         Array.from(this.input.attributes).forEach((attr) => {
             if (attr.name == "model") {
                 key = attr.value
             }
         })

         if (key && data[key]) {
             let value = data[key];
             this.input.value = value;
             this.output.textContent = value
            //开始绑定数据
             this.defineReactive(data, key, value)
         }
     }

     defineReactive(data, key, val) {
     //监听输入数据
         this.input.addEventListener('input', (e) => {
             this.data[key] = e.target.value;
         }, false)
      
         Object.defineProperty(data, key, {
             enumerable: true,
             configurable: false,
             get: () => val,
             set: (newVal) => {
                 if (newVal == val) {
                     return
                 }
                 val = newVal
                 this.notify(newVal)
             }
         })
     }
     //视图更新
     notify(val){
       this.output.textContent = val
     }
}
```
