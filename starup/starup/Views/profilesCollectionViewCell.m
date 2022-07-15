//
//  profilesCollectionViewCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import "profilesCollectionViewCell.h"

@implementation profilesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
}

- (void)setUser:(PFUser *)user {
//    Setter for the cell
    _user = user;
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    self.usernameOutlet.text = [NSString stringWithFormat:@"%@%@", @"@", self.user[@"username"]];
}

@end
