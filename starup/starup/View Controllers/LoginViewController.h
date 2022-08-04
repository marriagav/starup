//
//  LoginViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ChatSDK/ChatSDK.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>
#import "LinkedinIOSHelper/LinkedInHelper.h"
#import "Algos.h"
#import "PasswordViewController.h"
#import "Linkedin.h"
#import "ConnectionsGraph.h"
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN


@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSString *linkedinFName;
@property (strong, nonatomic) NSString *linkedinLName;
@property (strong, nonatomic) NSString *linkedinID;
@property (strong, nonatomic) NSString *linkedinUsername;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *linkedinEmail;
@property (strong, nonatomic) UIImage *imageLinkedin;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *linkedinButton;

@end

NS_ASSUME_NONNULL_END
