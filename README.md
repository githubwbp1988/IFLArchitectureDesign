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



文中涉及demo下载地址 [github](https://github.com/githubwbp1988/IFLArchitectureDesign)



# 从MVC基础上稍微演化一下

> ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/822602e06c154a25bea2ea2d5a11b8fd~tplv-k3u1fbpfcp-watermark.image?)


> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b5879b57e49940b081a599052dcd2347~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8cb4aa057a504cffa2c4052449effcb0~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/99dc3031c81a4709b8783e265790fb28~tplv-k3u1fbpfcp-watermark.image?)


与上篇文章MVC有些许的不一样，首先原来的controller弱化，由presenter来驱动，其实就是代理的驱动角色，现在的viewController其实就是原来view的角色了

还记得上篇文章 数据源怎么来的，viewController get到的，主要交代的是MVC布局关系，并没有涉及网络

如果加上网络部分，上文中构建好的MVC模式轻易就会被搞乱，因为基础的架构设计部分约束性不强，不自律的人也很容慢穿透这个MVC设计，慢慢就丧失了它的框架职责

可以把 [iOS架构设计（一）- MVC](https://juejin.cn/post/7112825508261265421) 中的ViewController核心代码在MVP模式下一样在ViewController补充完整 [代码](https://github.com/githubwbp1988/IFLArchitectureDesign)，操作之后你些许会发现别扭，如果有这样的感觉，那就相信这种感觉，带着这种感觉，一步步践行MVP的演化

正文开始前，这里就是让大家感受下这个小小的区别，接下来再复杂



# 带着感受，MVP再次调整

你会发现上面的调整 与 MVC 大同小异，感觉很像，那没关系，接下来，就彻底清空上一步的mvp初始铺垫，再次重新开始

这不是在浪费你的时间，前面的操作也是刻意的，这样做让大家心里能够装一些想当然的东西，然后打破它，再构建，过了很长时间以后，如果再考虑架构设计，你脑子里可能就会摒弃掉固有的东西，这样才会深刻起来


## context

context是为了不管在项目代码中什么位置，都能轻松获取到依赖

> ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3322cd7602be403095f4787e818e9b9b~tplv-k3u1fbpfcp-watermark.image?)

这种写法很怪，像是多此一举，不过要注意下当中的`weak`修饰

> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f39d276a37854296aeeb57e0543aad66~tplv-k3u1fbpfcp-watermark.image?)


## baseViewController

viewController 只会保留一些基本的关联桥接职能

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/74aef049b96946a59325ac5d3782d689~tplv-k3u1fbpfcp-watermark.image?)

presenter interactor view 不仅仅是mvp思想传达，重要的是，要从代码构建类上，让开发者更容易的get到这个信息

更有甚者，构建MVP这些基础代码可以通过执行脚本来自动生成，这样的话一个项目里，设计思想才会潜移默化的移植到潜意识里的规范手册里

毕竟代码还是靠程序猿去实现的，每个人都能清楚的意会这个设计模式，并写出风格一样的代码，那对于项目团队而言，是有很多好处的，效率肯定是没得说，而且协作之间的耦合也会变得准确，在没有必要费心思的关键结点处就不需要花费太多的时间精力

我理解的 架构不就是服务于开发组么 维护有合适的规范可依 职责也可通过代码变得很明晰 这些全都可以通过这样的一个架构轻松落实，就跟合同一样，清清楚楚


## mvp架构模式下，viewController效果简单看下

> ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3ffb0e7d9dca4c7fa2613e794d68df00~tplv-k3u1fbpfcp-watermark.image?)

这就是效果

注意前两行代码顺序

> ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f937d2ecaa34403c80cf138ee9f127fe~tplv-k3u1fbpfcp-watermark.image?)

调试代码 [github](https://github.com/githubwbp1988/IFLArchitectureDesign)


presenter逻辑
> ![image.png](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/acda44bb9cac4e5bae4d6b2fd749599a~tplv-k3u1fbpfcp-watermark.image?)

presenter红框部分 就是基于代理来驱动的

可能你阅读之后又个感觉，代码云里雾里的，但代码量却不多，这样弄值得吗

非常值得！且耐心往后看


# 从MVC迁移一些逻辑过来

> ![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7641ac2abce244dab5aafbe989eaeb08~tplv-k3u1fbpfcp-watermark.image?)

这是出现了一个新的概念，adapter，俗称适配器，如果看过了文章（一），会看到上半部分的逻辑有点像MVC里controller里的block回调

这里我简单做个解释，说一下这样抽象的思想：

- MVP是presenter基于代理驱动的，所以MVC中的controller就沦为配置层，可以理解为初始化配置的操作

- view的数据渲染交给了适配器，preseter自会驱动适配器

- 对view自身来讲，adapter也可以尝试去按照数据源的概念去理解

- 按照稳重的MVP构想，执行项目的话就可以拷贝代码，按照相应的格式规则去编辑代码 文件 类，框架设计就好了，写代码会变得很轻松 大可以自己去下载代码在自己的项目里尝试一下

adapter同样需要在context里追加注册

> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/47c6fe944d15415eb740c3184688664a~tplv-k3u1fbpfcp-watermark.image?)


# 还有一个特别的宏

> ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8dd2c22bf975456bafd583ea38d6f4ef~tplv-k3u1fbpfcp-watermark.image?)

> ![image.png](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e02a050a97594f9d85212f4afba160e3~tplv-k3u1fbpfcp-watermark.image?)

这样处理的代码更直观，而且代码位置很明确，通过标准字符，读代码会变得相当有意思


说实话，我也有点高估自己的表达了，这个MVP真心不好阐述，得依赖代码才能表达得清晰些，有可能会造成误解，但那不是我的本意


[文中涉及mvp代码部分](https://github.com/githubwbp1988/IFLArchitectureDesign)


