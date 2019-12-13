//
//  StoreViewController.h
//  PaymentSDKObjC
//
//  Created by Gustavo Sotelo on 27/11/17.
//  
//

#import <UIKit/UIKit.h>
#import <PaymentSDK/PaymentSDK-Swift.h>
#import "ListCardsViewController.h"


@interface StoreViewController : UIViewController <CardSelectedDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@end
