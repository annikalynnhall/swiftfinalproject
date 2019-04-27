//
//  ViewController.swift
//  Snap Run
//
//  Created by Annika Lynn Nordstrom Hall on 4/22/19.
//  Copyright © 2019 Annika Hall. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {

    
    
    @IBOutlet var homeUIView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var newRunButton: UIButton!
    @IBOutlet weak var savedRunsButton: UIButton!
    
    var aUI: FUIAuth!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        aUI = FUIAuth.defaultAuthUI()
        aUI?.delegate = self


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    func signIn() {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if aUI.auth?.currentUser == nil {
            self.aUI?.providers = providers
            present(aUI.authViewController(), animated: true, completion: nil)
        } else {
            homeUIView.isHidden = false
        }
    }
 
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        do {
            try aUI!.signOut()
            print("^^^ Successfully signed out!")
            homeUIView.isHidden = true
            signIn()
        } catch {
            homeUIView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }

    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        // Create a frame for an ImageView to hold our logo
        let marginInsets: CGFloat = 16 // logo will be 16 points from L and R margins
        let imageHeight: CGFloat = 225 // the height of our logo
        let imageY = self.view.center.y - imageHeight // place bottom of UIImageView at center of screen
        // Use values above to build a CGRect for the ImageView’s frame
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width:
            self.view.frame.width - (marginInsets*2), height: imageHeight)
        
        // Create the UIImageView using the frame created above & add the "logo" image
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "trail")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        return loginViewController
    }
    
}
extension ViewController: FUIAuthDelegate {
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication =
            options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication:
            sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            homeUIView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    
}

