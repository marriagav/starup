//
//  PostCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/8/22.
//

#import "PostCellView.h"


@implementation PostCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
    [self pictureGestureRecognizer];
    [self likeGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setPost:(Post *)post
{
    //    Setter for the post
    _post = post;
    self.user = post[@"author"];
    self.captionOutlet.text = post[@"contentOfPost"];
    self.profilePicture.file = self.user[@"profileImage"];
    [self.profilePicture loadInBackground];
    self.statusImage.file = post[@"statusImage"];
    self.statusText.text = post[@"updateStatus"];
    self.profileName.text = [NSString stringWithFormat:@"%@ %@", self.user[@"firstname"], self.user[@"lastname"]];
    self.userRole.text = self.user[@"role"];
    self.dateOutlet.text = self.post.createdAt.shortTimeAgoSinceNow;
    NSMutableArray* likedBy = [[NSMutableArray alloc]initWithArray:[self.post[@"likedBy"] mutableCopy]];
    if ([likedBy containsObject:PFUser.currentUser.username]){
        [self setVisualLike];
    }
    else{
        [self setVisualDisslike];
    }
    [self.statusImage loadInBackground];
}

- (void)likeGestureRecognizer {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeOnCLick:)];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];
    [self setUserInteractionEnabled:YES];
}

- (void)pictureGestureRecognizer
{
    //    Method to set up a tap gesture recognizer for the profile picture
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.profilePicture addGestureRecognizer:profileTapGestureRecognizer];
    [self.profilePicture setUserInteractionEnabled:YES];
}

- (void)didTapUserProfile:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the user profile
    [self.delegate postCell:self didTap:self.user];
}

- (IBAction)likeOnCLick:(id)sender {
    UIImpactFeedbackGenerator *likeFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
    [likeFeedback impactOccurred];
    likeFeedback = NULL;
    NSMutableArray* likedBy = [[NSMutableArray alloc]initWithArray:[self.post[@"likedBy"] mutableCopy]];
    if ([likedBy containsObject:PFUser.currentUser.username]){
        [self unLikePost];
    }
    else{
        [self likePost];
    }
}

- (void)likePost{
    //    Dissables likebutton so that the user cant spam it
    self.likeButton.enabled = false;
    //    Call to change the profile details
    self.post[@"likeCount"] = @([self.post[@"likeCount"] intValue] + 1);
    [self.post addObject:PFUser.currentUser.username forKey:@"likedBy"];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            [self setVisualLike];
            self.likeButton.enabled = true;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)unLikePost{
    //    Dissables likebutton so that the user cant spam it
    self.likeButton.enabled = false;
    //    Call to change the profile details
    self.post[@"likeCount"] = @([self.post[@"likeCount"] intValue] - 1);
    [self.post removeObject:PFUser.currentUser.username forKey:@"likedBy"];
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            [self setVisualDisslike];
            self.likeButton.enabled = true;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)setVisualLike{
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    self.likeCount.text = [NSString stringWithFormat:@"%@ likes",self.post[@"likeCount"]];
}

- (void)setVisualDisslike{
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    self.likeCount.text = [NSString stringWithFormat:@"%@ likes",self.post[@"likeCount"]];
}

@end
 
