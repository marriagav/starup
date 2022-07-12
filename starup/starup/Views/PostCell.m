//
//  PostCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/8/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
    [self _pictureGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
//    Setter for the post
    _post = post;
    self.captionOutlet.text = post[@"contentOfPost"];
    self.profilePicture.file = self.user[@"profileImage"];
    self.statusImage.file = post[@"statusImage"];
    self.statusText.text = post[@"updateStatus"];
    self.user = post[@"author"];
    self.userName.text = self.user.username;
    self.dateOutlet.text = self.post.createdAt.shortTimeAgoSinceNow;
    [self.statusImage loadInBackground];
    [self.profilePicture loadInBackground];
}

- (void)_pictureGestureRecognizer{
//    Method to set up a tap gesture recognizer for the profile picture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
}

- (void) didTapUserProfile:(UITapGestureRecognizer *)sender{
//    Gets called when the user taps on the user profile
    [self.delegate postCell:self didTap:self.user];
}

@end
