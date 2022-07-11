//
//  ComposePostViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Algos.h"
#import "MBProgressHUD.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposePostViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *captionOutlet;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *dropdownOutlet;
@property (strong, nonatomic) NSString *updateStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

NS_ASSUME_NONNULL_END
