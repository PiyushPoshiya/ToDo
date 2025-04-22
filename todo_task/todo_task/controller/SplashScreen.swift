//
//  SplashScreen.swift
//  todo_task
//
//  Created by Piyush on 21/04/25.
//

import UIKit

class SplashScreen: UIViewController {

    @IBOutlet weak var img_logo: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setUI()
    {
        UIView.animate(
            withDuration: 0.5,
            delay: 1.0,
            options: [.curveEaseIn],
            animations: {
                // Scale up the logo
                self.img_logo.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            },
            completion: { finished in
                if finished {
                    // Animate back to normal scale and move to next screen
                    UIView.animate(
                        withDuration: 3.0,
                        delay: 0.0,
                        options: [.curveEaseOut],
                        animations: {
                            self.img_logo.transform = .identity
                        },
                        completion: { done in
                            if done {
                                self.setScreen()
                            }
                        }
                    )
                }
            }
        )
    }
    
    func setScreen()
    {
        let objVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
        appNavigation.isNavigationBarHidden = true
        UIApplication.shared.windows[0].rootViewController = appNavigation
    }
    

}
