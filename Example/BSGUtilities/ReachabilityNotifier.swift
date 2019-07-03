import Reachability;

@objc class ReachabilityNotifier: NSObject {
    let reachability: Reachability
    let window: UIWindow
    var referenceFrame: CGRect = .zero
    
    var statusViewController: UIViewController?
    var contentViewController: UIViewController?
    
    var statusBarHeightConstraint: NSLayoutConstraint?
    
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height;
    }
    
    @objc init(window: UIWindow, hostName: String) {
        self.window = window
        self.reachability = Reachability(hostName: hostName)
    }
    
    @objc func start() {
        reachability.reachableBlock = { [weak self] (reach: Reachability?) in
            DispatchQueue.main.async {
                self?.hideAlertViewController()
            }
        }
        
        reachability.unreachableBlock = { [weak self] (reach: Reachability?) in
            DispatchQueue.main.async {
                self?.showAlertViewController()
            }
        }
        
        self.changeRootViewController()
        
        self.reachability.startNotifier()
    }
    
    func changeRootViewController() {
        guard let oldRootController = window.rootViewController else {
            debugPrint("no root view controller")
            return
        }
        
        referenceFrame = oldRootController.view.frame
        
        let alertViewController = UIViewController()
        alertViewController.view.backgroundColor = .orange
        
        let newRootViewController = UIViewController()
        newRootViewController.addChild(alertViewController)
        newRootViewController.view.addSubview(alertViewController.view)
        alertViewController.view.translatesAutoresizingMaskIntoConstraints = false
        alertViewController.didMove(toParent: newRootViewController)
        
        newRootViewController.addChild(oldRootController)
        newRootViewController.view.addSubview(oldRootController.view)
        oldRootController.view.translatesAutoresizingMaskIntoConstraints = false
        oldRootController.didMove(toParent: newRootViewController)
        
        window.rootViewController = newRootViewController
        
        contentViewController = oldRootController
        statusViewController = alertViewController
        
        oldRootController.view.layer.borderColor = UIColor.orange.cgColor
        oldRootController.view.layer.borderWidth = 2.0
        alertViewController.view.layer.borderColor = UIColor.blue.cgColor
        alertViewController.view.layer.borderWidth = 2.0
        
        statusBarHeightConstraint = alertViewController.view.heightAnchor.constraint(equalToConstant: statusBarHeight)
        guard let heightConstraint = statusBarHeightConstraint else {
            fatalError("unexpected")
        }
        
        NSLayoutConstraint.activate([
            alertViewController.view.leadingAnchor.constraint(equalTo: newRootViewController.view.leadingAnchor),
            alertViewController.view.trailingAnchor.constraint(equalTo: newRootViewController.view.trailingAnchor),
            alertViewController.view.topAnchor.constraint(equalTo: newRootViewController.view.topAnchor),
            heightConstraint
            ])
        
        NSLayoutConstraint.activate([
            oldRootController.view.leadingAnchor.constraint(equalTo: newRootViewController.view.leadingAnchor),
            oldRootController.view.trailingAnchor.constraint(equalTo: newRootViewController.view.trailingAnchor),
            oldRootController.view.topAnchor.constraint(equalTo: alertViewController.view.bottomAnchor),
            oldRootController.view.bottomAnchor.constraint(equalTo: newRootViewController.bottomLayoutGuide.topAnchor)
            ])

        contentViewController = oldRootController
        statusViewController = alertViewController
    }
    
    func hideAlertViewController() {
        debugPrint("hide")
        statusBarHeightConstraint?.constant = statusBarHeight
        UIView.animate(withDuration: 0.300) {
            self.window.rootViewController?.view.layoutIfNeeded()
        }
    }
    
    func showAlertViewController() {
        debugPrint("show")
        statusBarHeightConstraint?.constant = 2.0 * statusBarHeight
        UIView.animate(withDuration: 0.300) {
            self.window.rootViewController?.view.layoutIfNeeded()
        }
    }
}
