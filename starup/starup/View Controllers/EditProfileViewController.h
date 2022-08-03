//
//  EditProfileViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/ChatSDK.h>
#import "Parse/Parse.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditProfileViewControllerDelegate

- (void)didEdit;

@end


@interface EditProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *firstnameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *lastnameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *roleOutlet;
@property (weak, nonatomic) IBOutlet UITextView *userBio;
@property (nonatomic, weak) id<EditProfileViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *typeHere;

@end

NS_ASSUME_NONNULL_END
