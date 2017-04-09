import UIKit



open class MMNavigationController: UINavigationController {
    
    // MARK: - properties
    
    /// navgation bar 默认背景颜色
    open var defaultNavigationBarBackgroundColor = UIColor.white
    
    /// navgation bar 默认标题颜色
    open var defaultTitleColor = UIColor.black
    
    /// full screen 手势
    lazy public var fullscreenInteractivePopGestureRecognizer = UIPanGestureRecognizer()
    
    /// navigation bar 主体视图，此属性用于兼容 iOS 10
    private lazy var barBackgoundView: UIView? = {
        if #available(iOS 10.0, *) {
            for view in self.navigationBar.subviews {
                if NSClassFromString("_UIBarBackground").flatMap(view.isKind(of:)) == true {
                    return view
                }
            }
        }
        return nil
    }()
    
    private lazy var popGestrueDelegate: PopGestrueDelegateObject = {
        let delegate = PopGestrueDelegateObject()
        delegate.navigationController = self
        return delegate
    }()
    
    // MARK: - override
    override open func viewDidLoad() {
        super.viewDidLoad()
        initFullscreenGesture()
        
        /// 导航栏设置为不透明， UIViewController的view会自动向下偏移 64
        /// viewController.extendedLayoutIncludesOpaqueBars = true
        /// 以上设置可以解决这个问题
        navigationBar.isTranslucent = false
    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBarBackgroundColor(defaultNavigationBarBackgroundColor, animated: false)
    }
    
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        let blockWrapper = ViewControllerInjectBlockWrapper { (viewController: UIViewController, animated: Bool) -> Void in
            
            viewController.navigationController?
                .setNavigationBarHidden(viewController.mm.navigationBarHidden, animated: animated)
            
            if let navigationController = viewController.navigationController as? MMNavigationController {
                
                let navigationBarBackgroundColor = viewController.mm.navigationBarBackgroundColor ?? navigationController.defaultNavigationBarBackgroundColor
                navigationController.setBarBackgroundColor(navigationBarBackgroundColor, animated: true)
                
                let titleColor = viewController.mm.navigationBarTitleColor ?? navigationController.defaultTitleColor
                navigationController.setTitleColor(titleColor)
            }
            let navigationBarBackgroundColor = viewController.mm.navigationBarBackgroundColor ?? self.defaultNavigationBarBackgroundColor
            (viewController.navigationController as? MMNavigationController)?.setBarBackgroundColor(navigationBarBackgroundColor, animated: true)
            
        }
        viewController.mm.viewWillAppearInjectBlock = blockWrapper
        viewControllers.last?.mm.viewWillAppearInjectBlock = blockWrapper
        super.pushViewController(viewController, animated: animated)
    }
    
    
    // MARK: - private methods
    
    private func initFullscreenGesture() {
        
        fullscreenInteractivePopGestureRecognizer.delegate = popGestrueDelegate
        guard let targets = interactivePopGestureRecognizer?.value(forKey: "targets") as? [AnyObject] else { return }
        guard let target = (targets.first as? NSObject)?.value(forKey: "target") else { return }
        let internalAction = NSSelectorFromString("handleNavigationTransition:")
        fullscreenInteractivePopGestureRecognizer.maximumNumberOfTouches = 1
        fullscreenInteractivePopGestureRecognizer.addTarget(target, action: internalAction)
        interactivePopGestureRecognizer?.isEnabled = false
        interactivePopGestureRecognizer?.view?.addGestureRecognizer(fullscreenInteractivePopGestureRecognizer)
    }
    
    // MARK: - public methods
    
    /// 设置 title 的字体颜色
    public func setTitleColor(_ textColor: UIColor){
        if navigationBar.titleTextAttributes == nil{
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : textColor]
        }else{
            navigationBar.titleTextAttributes![NSForegroundColorAttributeName] = textColor
        }
    }
    
    /// 隐藏 navigation bar 底部灰线
    public func hideBottomLine() {
        navigationBar.shadowImage = UIImage()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    /// 设置返回按钮图片
    public func setBackButtonImage(_ image: UIImage){
        let backButtonImage = image.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backButtonImage
        navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
    
    /// 设置 navigation bar 背景颜色
    public func setBarBackgroundColor(_ color: UIColor, animated: Bool) {
        let duration = animated ? 0.25 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.navigationBar.barTintColor = color
            self.barBackgoundView?.backgroundColor = color
        })
    }
}


