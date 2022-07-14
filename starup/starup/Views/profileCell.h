//
//  profileCell.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@import Parse;

@interface profileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *profileName;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) PFUser *user;

- (void)setUser:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
