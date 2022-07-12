//
//  RegisterViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "LoginViewController.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *roleField;
@property (strong, nonatomic) NSString *error;
@property (strong, nonatomic) NSString *correctLogin;

@end

NS_ASSUME_NONNULL_END
