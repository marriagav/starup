//
//  profileCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/13/22.
//

#import "ProfileCellView.h"


@implementation ProfileCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
    [self cellGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setUser:(PFUser *)user
{
    //    Setter for the cell
    _user = user;
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    self.profileName.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstname"], self.user[@"lastname"]];
    self.username.text = [NSString stringWithFormat:@"%@%@", @"@", self.user[@"username"]];
}

- (void)didTapCell:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the user profile
    [self.delegate profileCell:self didTap:self.user];
}

- (void)cellGestureRecognizer
{
    //    Method to set up a tap gesture recognizer for the profile picture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCell:)];
    [self addGestureRecognizer:profileTapGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

@end
