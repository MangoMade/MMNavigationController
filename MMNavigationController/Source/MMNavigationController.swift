import UIKit


extension UIViewController {
    
    private struct OnceToken {
        static var viewWillAppearMethodsSwizzled = 0
    }
    
    private struct AssociatedKey {
        static var viewWillAppearInjectBlock = 0
        static var navigationBarHidden = 0
        static var popGestrueEnable = 0
        static var navigationBarBackgroundColor = 0
        static var popGestrueEnableWidth = 0
        static var navigationBarTitleColor = 0
    }
    
    private static let methodsSwizzling: () = {
        let originalViewWillAppearSelector = class_getInstanceMethod(UIViewController.self, #selector(viewWillAppear(_:)))
        let swizzledViewWillAppearSelector = class_getInstanceMethod(UIViewController.self, #selector(mm_viewWillAppear(_:)))
        method_exchangeImplementations(originalViewWillAppearSelector, swizzledViewWillAppearSelector)
    }()
    
    /// 在AppDelegate中调用此方法
    public class func mm_load() {
        methodsSwizzling
    }
    
    /// navigationBar 是否隐藏
    @objc public var mm_navigationBarHidden: Bool {
        get {
            var hidden = objc_getAssociatedObject(self, &AssociatedKey.navigationBarHidden) as? Bool
            if hidden == nil {
                hidden = false
                objc_setAssociatedObject(self, &AssociatedKey.navigationBarHidden, hidden, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return hidden!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// pop 手势是否可用
    @objc public var mm_popGestrueEnable: Bool {
        get {
            var enable = objc_getAssociatedObject(self, &AssociatedKey.popGestrueEnable) as? Bool
            if enable == nil {
                enable = true
                objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnable, enable, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return enable!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// pop手势可用宽度，从左开始计算
    @objc public var mm_popGestrueEnableWidth: CGFloat {
        get {
            var width = objc_getAssociatedObject(self, &AssociatedKey.popGestrueEnableWidth) as? CGFloat
            if width == nil {
                width = 0
                objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnableWidth, width, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return width!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.popGestrueEnableWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// navigationBar 背景颜色
    @objc public var mm_navigationBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.navigationBarBackgroundColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// navigationBar 标题字体颜色
    @objc public  var mm_navigationBarTitleColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.navigationBarTitleColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.navigationBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK - private methods
    @objc fileprivate func mm_viewWillAppear(_ animated: Bool) {
        mm_viewWillAppear(animated)
        mm_viewWillAppearInjectBlock?.block?(self, animated)
    }
    
    @objc fileprivate var mm_viewWillAppearInjectBlock: ViewControllerInjectBlockWrapper? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewWillAppearInjectBlock) as? ViewControllerInjectBlockWrapper
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewWillAppearInjectBlock, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

open class MMNavigationController: UINavigationController {
    
    // MARK: - properties
    
    /// navgation bar 默认背景颜色
    open var defaultNavigationBarBackgroundColor = UIColor.white
    
    /// navgation bar 默认标题颜色
    open var defaultTitleColor = UIColor.black
    
    /// full screen 手势
    lazy public var fullscreenInteractivePopGestureRecognizer = UIPanGestureRecognizer()
    
    /// navigation bar 主体视图，此属性用于兼容 iOS 10
    private var barBackgoundView: UIView? {
        if #available(iOS 10.0, *) {
            for view in navigationBar.subviews {
                if NSClassFromString("_UIBarBackground").flatMap(view.isKind(of:)) == true {
                    return view
                }
            }
        }
        return nil
    }
    
    private lazy var popGestrueDelegate: MMNavigationControllerPopGestrueDelegate = {
        let delegate = MMNavigationControllerPopGestrueDelegate()
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
                .setNavigationBarHidden(viewController.mm_navigationBarHidden, animated: animated)
            
            if let navigationController = viewController.navigationController as? MMNavigationController {
                
                let navigationBarBackgroundColor = viewController.mm_navigationBarBackgroundColor ?? navigationController.defaultNavigationBarBackgroundColor
                navigationController.setBarBackgroundColor(navigationBarBackgroundColor, animated: true)
                
                let titleColor = viewController.mm_navigationBarTitleColor ?? navigationController.defaultTitleColor
                navigationController.setTitleColor(titleColor)
            }
            let navigationBarBackgroundColor = viewController.mm_navigationBarBackgroundColor ?? self.defaultNavigationBarBackgroundColor
            (viewController.navigationController as? MMNavigationController)?.setBarBackgroundColor(navigationBarBackgroundColor, animated: true)
            
        }
        viewController.mm_viewWillAppearInjectBlock = blockWrapper
        viewControllers.last?.mm_viewWillAppearInjectBlock = blockWrapper
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


// MARK: - NavigationControllerPopGestrueDelegate
private class MMNavigationControllerPopGestrueDelegate: NSObject {
    
    weak var navigationController: UINavigationController?
    
}

// MARK: - UIGestureRecognizerDelegate
extension MMNavigationControllerPopGestrueDelegate: UIGestureRecognizerDelegate {
    
    
    /// 这里主要参考了 FDFullscreenPopGesture
    @objc func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let navigationController = navigationController,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
                return false
        }
        
        if navigationController.viewControllers.count <= 1 {
            return false
        }
        
        let topViewController = navigationController.viewControllers.last
        if topViewController?.mm_popGestrueEnable == false {
            return false
        }
        
        let startLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let enableWidth = topViewController?.mm_popGestrueEnableWidth ?? 0
        if enableWidth > 0 && startLocation.x > enableWidth {
            return false
        }
        
        if navigationController.value(forKey: "_isTransitioning") as? Bool == true {
            return false
        }
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        if translation.x <= 0 {
            return false
        }
        
        return true
    }
    
}

@objc private class ViewControllerInjectBlockWrapper: NSObject {
    
    var block: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?
    
    init(block: ((_ viewController: UIViewController, _ animated: Bool) -> Void)?) {
        self.block = block
        super.init()
    }
    
}
