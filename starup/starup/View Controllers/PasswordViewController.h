//
//  PasswordViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/20/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PasswordViewControllerDelegate

- (void)didPressNext:(NSString *)password;

@end

@interface PasswordViewController : UIViewController

@property BOOL newUSer;
@property (weak, nonatomic) IBOutlet UILabel *instructionOutlet;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *continueButton;
@property (nonatomic, weak) id<PasswordViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
