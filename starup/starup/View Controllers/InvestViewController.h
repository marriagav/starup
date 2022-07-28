//
//  InvestViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Starup.h"
#import "Collaborator.h"
#import "MBProgressHUD.h"
@import PayPalCheckout;

NS_ASSUME_NONNULL_BEGIN

@protocol InvestViewControllerDelegate

- (void)didInvest;

@end


@interface InvestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *investOutlet;
@property (weak, nonatomic) IBOutlet UILabel *percentageOutlet;
@property (strong, nonatomic) Starup *starup;
@property (strong, nonatomic) Collaborator *collaborator;
@property float percentageToGet;
@property float maxInvestment;
@property (strong, nonatomic) NSNumber *goalInv;
@property (strong, nonatomic) NSNumber *totalPercent;
@property (weak, nonatomic) IBOutlet UILabel *starupName;
@property (weak, nonatomic) IBOutlet UILabel *maxInvestOutlet;
@property BOOL hasError;
@property (nonatomic, weak) id<InvestViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *investButton;
@property (nonatomic) NSMutableArray<PPCPurchaseUnitItem *> *items;

@end

NS_ASSUME_NONNULL_END
