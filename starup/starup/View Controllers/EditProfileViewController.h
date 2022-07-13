//
//  EditProfileViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *firstnameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *lastnameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *roleOutlet;
@property (weak, nonatomic) IBOutlet UITextView *userBio;

@end

NS_ASSUME_NONNULL_END
