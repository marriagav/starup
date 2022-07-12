//
//  ComposeStarupViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "StarupsViewController.h"
#import "Algos.h"
#import "MBProgressHUD.h"
#import "Starup.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeStarupViewControllerDelegate

- (void)didPost;

@end

@interface ComposeStarupViewController : UIViewController

@property (nonatomic, weak) id<ComposeStarupViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UITextField *starupName;
@property (weak, nonatomic) IBOutlet UIDatePicker *operatingSince;
@property (weak, nonatomic) IBOutlet UITextField *starupCategory;
@property (weak, nonatomic) IBOutlet UITextField *sales;
@property (weak, nonatomic) IBOutlet UITextField *goalInvestment;
@property (weak, nonatomic) IBOutlet UITextField *percentageToGive;
@property (weak, nonatomic) IBOutlet UITextView *descriptionOutlet;
@property (weak, nonatomic) IBOutlet PFImageView *starupImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

NS_ASSUME_NONNULL_END
