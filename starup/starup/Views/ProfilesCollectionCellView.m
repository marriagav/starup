//
//  profilesCollectionViewCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import "ProfilesCollectionCellView.h"


@implementation ProfilesCollectionCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
    [self _cellGestureRecognizer];
}

- (void)setUser:(PFUser *)user
{
    //    Setter for the cell
    _user = user;
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    self.usernameOutlet.text = [NSString stringWithFormat:@"%@%@", @"@", self.user[@"username"]];
}

- (void)_cellGestureRecognizer
{
    //    Method to set up a tap gesture recognizer for the profile cell
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserProfile:)];
    [self addGestureRecognizer:profileTapGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

- (void)didTapUserProfile:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the user profile
    [self.delegate profileCell:self didTap:self.user];
}

@end
