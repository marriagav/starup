//
//  profileCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import "profileCell.h"

@implementation profileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setUser:(PFUser *)user {
//    Setter for the cell
    _user = user;
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    self.profileName.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstname"], self.user[@"lastname"]];
    self.username.text = [NSString stringWithFormat:@"%@%@", @"@", self.user[@"username"]];
}

@end
