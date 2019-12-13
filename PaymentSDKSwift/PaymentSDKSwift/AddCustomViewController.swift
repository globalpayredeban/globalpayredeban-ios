//
//  AddCustomViewController.swift
//  PaymentSDKSwift
//
//  Created by Gustavo Sotelo on 12/05/16.
//  
//

import UIKit
import PaymentSDK


class AddCustomViewController: UIViewController {
    
    @IBOutlet weak var addView: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var paymentAddVC:PaymentAddNativeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Payment WIDGET CREATION
        
        paymentAddVC = self.addPaymentWidget(toView: self.addView, delegate: nil, uid:UserModel.uid, email:UserModel.email)
        
        /* Change Colors
        paymentAddVC.baseFontColor = .orange
        paymentAddVC.baseColor = .green
        paymentAddVC.backgroundColor = .white
        paymentAddVC.showLogo = false*/
      paymentAddVC.baseFont = UIFont(name: "Helvetica-Neue", size: 12) ?? UIFont.systemFont(ofSize: 12)
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func addCard(_ sender:UIButton?)
    {
        if let validCard = self.paymentAddVC.getValidCard() // CHECK IF THE CARD IS VALID, IF THERE IS A VALIDATION ERROR NIL VALUE WILL BE RETURNED
        {
            
            self.activityIndicator.startAnimating()
            sender?.isEnabled = false
            PaymentSDKClient.add(validCard, uid: UserModel.uid, email: UserModel.email, callback: { (error, cardAdded) in
                self.activityIndicator.stopAnimating()
                sender?.isEnabled = true
                if cardAdded != nil
                {
                    DispatchQueue.main.async(execute: {
                        let alertC = UIAlertController(title: "Response", message: "card "+cardAdded!.termination!+"  status:"+cardAdded!.status!, preferredStyle: UIAlertControllerStyle.alert)

                        let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                            
                            self.navigationController?.popViewController(animated: false)
                        })
                        alertC.addAction(defaultAction)
                        self.present(alertC, animated: true
                            , completion: {
                                
                        })
                    })
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        let alertC = UIAlertController(title: "Error", message: "error: "+error.debugDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertC.addAction(defaultAction)
                        self.present(alertC, animated: true
                            , completion: {
                                
                        })
                    })
                }
                
            })
        }
    }
}
