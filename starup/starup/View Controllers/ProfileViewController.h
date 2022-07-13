//
//  ProfileViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Algos.h"
#import "Parse/Parse.h"
#import "EditProfileViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *profileRole;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UITextView *profileBio;
@property (strong, nonatomic) PFUser *user;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

@end

NS_ASSUME_NONNULL_END
