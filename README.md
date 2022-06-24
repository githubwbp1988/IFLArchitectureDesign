# IFLArchitectureDesign

谈起架构，是个很大很大的词，在开发行业里似乎又是个很虚很虚的词，一般情况下，我都是很少去阐述，更多的是应用到自己平时的工作跟解决问题中

人人都可以谈架构，毕竟谈起来又不需要备案，合适与否，无从可知

架构，最终是要落实到项目上，是否有定式可言

本着敬畏之心，试着展开一些，当然，一篇文章没办法谈论多宏大的项目架构跟多优秀的优化设计，只能本着从解决问题的解读阐述一些观念，重点还是在于思想

这里不在于谈论对与错，没有什么意义，但是可以相较出更好与更适合


让我们开始

文中涉及demo下载地址 [github](https://github.com/githubwbp1988/IFLArchitectureDesign)


# 先呈现最初阶的代码

这里我们实现了一个tableView，cell操作加减数字

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/28f862809e7647968f1402e56cdc5874~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8f5a2759ae7840628fa899c90ca11ae3~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8a322c6a96cb4d8cac06f2d40a4b6ffb~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/71b05c6ea8bd4206a630bf701fcc8d41~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/be00441f0b4142e595170e08216f2f91~tplv-k3u1fbpfcp-watermark.image?)

这样的代码很好理解，但是，是不用思考的代码逻辑，但却违背了mvc的规范，

- cell里可以直接操作model数据的修改

- 视图（tableView）在viewcontroller里，跟控制粘在了一起


# 改为mvc设计

## 1.把控制器中的数据源剥离

单独构建一个datasource

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0fd2e71195e843179563bfe9c9777fdd~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b9996c35c889449390fced3251314e43~tplv-k3u1fbpfcp-watermark.image?)

viewController被改成这样

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3058252c4249454da5566b8fe0cce22c~tplv-k3u1fbpfcp-watermark.image?)

datasource 这样

> ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e05deb636b9d4e60ae9651086ee17e00~tplv-k3u1fbpfcp-watermark.image?)

cell 中的操作到数据同步逻辑断了

> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/18c9784d710743fab305d4d5a7acfd01~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/250df07858f2491d8b5a9ef229d95364~tplv-k3u1fbpfcp-watermark.image?)

datasource抽离之后，目前视图是正常的

## cell中直接操作model，对model的侵入过深，调整为把操作通过控制器穿出来

操作脱离cell传出时，需要indexPath依赖

> ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/07a5ead4814744fe8208ef72b5dabe63~tplv-k3u1fbpfcp-watermark.image?)

如果想最小粒度保障操作与数据状态同步，cell传递出操作，响应的换回操作后的数据返回

注意：循环引用问题

但如果操作跟数据变化同步不是即时的话，如果存在异步，可能cell会被销毁，这个时候需要采用代理的方式，model更新之后，控制器需要协调reloadData

其实，这个时候，一个相对合乎`MVC`规范的设计就成型了

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/852d6087bdb9423e9e435a8bb5a170fd~tplv-k3u1fbpfcp-watermark.image?)

貌似还是有些些问题


## 2.把view从控制器抽离

如果view复杂的话，就需要把view从controller中分离，保障controller职责的清晰

> ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/2ec85fa16b3e491298300fc9bf654dd7~tplv-k3u1fbpfcp-watermark.image?)

现在controller里代码意图更明确了，view就是一个笼统的view，controller并不关注里面的细枝末节

## 3.MVC是有缺陷么？人为缺陷还是设计本身呢？

开发时间久了，经常会听到这样一个说法，mvc会随着项目的复杂度，controller会变得越来越臃肿.........

我并不认同这种说法，按照这样的逻辑，不管哪种设计，项目复杂了，各种客观的主观的原因，一不小心都会使一些代码变得臃肿，我倒认为这不是MVC的缺陷


就像最后的view从controller抽离，view最终要的是需要数据源，控制器就是想办法把view需要的交付出去，而且还必须明智，就是view只需要拿，具体怎么拿到的，我就简单放到view的初始化里

....看样子说的又太轻松了，你或许心里可能会说，就是个demo，谁都知道，仅仅这样三言两语就说MVC多好，这个demo就是MVC思想如何如何

我不否认，因为我也无法把MVC的原理做到工匠一般通过一篇文章说全说透，只能尽可能尽最大能力把一些问题通过这小小代码阐述些，也欢迎有时间有精力的同学不吝指正

这里我想参考之前的一篇文章，是关于flutter的，其中有关于flutter与原生channel通信，如何精明的设计block，感兴趣的同学可以简单看下 [Flutter引擎源码分析(二) - channel原生通信](https://juejin.cn/post/7108044181372665886/)


## 4.自然而然引出另一个问题

目前代码阐述的还是简单的demo MVC说明，如果view变得更复杂呢，业务上很远的view 甚至controller 相互之间会有交集，而且view也会变得复杂得多得多，controller需要协调的控制业务也不单单是demo里那么纯粹

我觉得那是对MVC有些悲观了，MVC本身就不是罗塞塔那么生生堆成一个庞然大物，最后尾大不掉，那是因为MVC 分层分块的，简单的说就是 业务逻辑视图不断拆分拆分，每个拆分都可以作为一个MVC去设计。 我自认为目前是没有能力把这块说的很具体很透彻了，除非拿一个相当大体量的项目来拆解，显示在这篇文章里就不现实了

不过另一种设计模式 俗称的MVP，可能更利于说明上述的问题应该怎么编排


# MVP模式

见（二）尽快更文

文中涉及demo下载地址 [github](https://github.com/githubwbp1988/IFLArchitectureDesign)




