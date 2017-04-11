## 解决的问题

由于`NavigationBar`的生命周期是与`UINavigationController`绑定的，所以`UINavigationController`的所有子`ViewController`都共用同一个`NavigationBar`,但是在实际开发的需求中，常常会有某个视图的导航栏颜色与其它视图的导航栏颜色不同。

修改某一个`viewController`的颜色也不难：

``` Swift
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barTintColor = UIColor.blue
}
    
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.barTintColor = UIColor.white
}
```    

只是每次需要这么多代码来解决一个看似很简单的问题，非常麻烦

**使用MMNavigationController后只需要一句代码，即可修改导航栏颜色：**

``` Swift
mm.navigationBarBackgroundColor = UIColor.blue
```

**并且支持全屏Pop手势**

效果图：

![2016-11-12 16_52_24.gif](http://upload-images.jianshu.io/upload_images/1748971-2d8a75c1236529e1.gif?imageMogr2/auto-orient/strip)


## 使用

**由于`Swift`不能重写`load`方法，所以需要在AppDelegate中调用`UIViewController.mm.load()`  
然后用`MMNavigationController`代替`UINavigationController`**

``` Swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    /** 高亮 **/
    UIViewController.mm.load()
    let rootViewController = MMNavigationController(rootViewController: NormalViewController())
    /** 高亮 **/
    
    rootViewController.hideBottomLine()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    return true
}
```


之后就可以在`ViewController`的`viewDidLoad`中设置如下属性了：

``` Swift
override func viewDidLoad() {
    super.viewDidLoad()

	 /// 修改当前ViewContoller的导航栏的背景颜色
    mm.navigationBarBackgroundColor = UIColor.random
    
    /// 修改当前ViewContoller标题颜色
    mm.navigationBarTitleColor = UIColor.white
    
    /// 隐藏当前ViewContoller的导航栏
    mm.navigationBarHidden = true
	 
	 
	 /** 全屏手势相关属性 **/
	 
	 /// pop 手势是否可用
    mm.popGestrueEnable = false
	 
	 /// pop 手势响应的范围
    mm.popGestrueEnableWidth = 150
}
```

简单易用！

## 实现

主要实现是参考了[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

运用AOP, 在`viewWillAppear`中进行属性的设置。

## Requirements

* iOS 8.0
* XCode 8.0
* Swift 3.0
* Swift 2.x请使用 0.0.1

## Cocoapods

	pod 'MMNavigationController', '~> 0.0.4’