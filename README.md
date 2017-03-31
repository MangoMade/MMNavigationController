## 解决的问题

由于`NavigationBar`的生命周期是与`UINavigationController`绑定的，所以`UINavigationController`的所有子`ViewController`都共用同一个`NavigationBar`,但是在实际开发的需求中，常常会有某个视图的导航栏颜色与其它视图的导航栏颜色不同。

修改某一个`viewController`的颜色也不难：

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.blueColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
    }
    
只是每次需要这么多代码来解决一个看似很简单的问题，非常麻烦

**使用MMNavigationController后只需要一句代码，即可修改导航栏颜色：**

	mm_navigationBarBackgroundColor = UIColor.blueColor()
		

**并且支持全屏Pop手势**

效果图：

![2016-11-12 16_52_24.gif](http://upload-images.jianshu.io/upload_images/1748971-2d8a75c1236529e1.gif?imageMogr2/auto-orient/strip)


## 使用

**由于`Swift`不能重写`load`方法，所以需要在AppDelegate中调用`UIViewController.mm_load()`  
然后用`MMNavigationController`代替`UINavigationController`**

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    	/** 高亮 **/
        UIViewController.mm_load()
        let rootViewController = MMNavigationController(rootViewController: NormalViewController())
        /** 高亮 **/
        
        rootViewController.hideBottomLine()
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        return true
    }




之后就可以在`ViewController`的`viewDidLoad`中设置如下属性了：

    override func viewDidLoad() {
        super.viewDidLoad()

		 /// 修改当前ViewContoller的导航栏的背景颜色
        mm_navigationBarBackgroundColor = UIColor.randomColor()
        
        /// 修改当前ViewContoller标题颜色
        mm_navigationBarTitleColor = UIColor.whiteColor()
        
        /// 隐藏当前ViewContoller的导航栏
		 mm_navigationBarHidden = true
		 
		 
		 /** 全屏手势相关属性 **/
		 
		 /// pop 手势是否可用
		 mm_popGestrueEnable = false
		 
		 /// pop 手势响应的范围
		 mm_popGestrueEnableWidth = 150
		
    }
    
简单易用！

## 实现

主要实现是参考了[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture)

运用AOP, 在`viewWillAppear`中进行属性的设置。

## Cocoapods

	pod 'MMNavigationController'