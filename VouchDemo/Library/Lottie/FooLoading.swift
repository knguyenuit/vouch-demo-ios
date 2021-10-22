//
//  Created by NguyenSeven on 13/10/2021.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

protocol FooLoadingType {
    func handleState(isHidden: Bool)
}

class FooLoading: FooLoadingType {

    private var containerView: UIView!
    private var blurView: UIView!
    private var animationView: AnimationView?

    public init() {
        containerView = UIView()
        blurView = UIView()
        containerView.backgroundColor = .clear
        containerView.frame = UIScreen.main.bounds
        blurView.backgroundColor = .white
        blurView.alpha = 0.3
        blurView.frame = containerView.frame
        animationView = AnimationView(name: "foo_loading")
        animationView?.loopMode = .autoReverse
        animationView?.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView?.center = containerView.center
        animationView?.contentMode = .scaleAspectFit
        if let animationView = self.animationView {
            containerView.addSubview(blurView)
            containerView.addSubview(animationView)
        }
    }

    func handleState(isHidden: Bool) {
        UIView.transition(with: containerView, duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: {
                            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                            if var topController = keyWindow?.rootViewController {
                                while let presentedViewController = topController.presentedViewController {
                                    topController = presentedViewController
                                }
                                if !isHidden {
                                    topController.view.addSubview(self.containerView)
                                    topController.view.bringSubviewToFront(self.containerView)
                                    self.animationView?.play()
                                } else {
                                    self.containerView.removeFromSuperview()
                                    self.animationView?.stop()
                                }
                            }
                          },
                          completion: nil)

    }
}
