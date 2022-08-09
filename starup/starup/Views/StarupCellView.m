//
//  StarupCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/8/22.
//

#import "StarupCellView.h"


@implementation StarupCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self addGestureRecognizers];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setStarup:(Starup *)starup
{
    //    Setter for the starup
    _starup = starup;
    self.starupImage.file = starup[@"starupImage"];
    [self.starupImage loadInBackground];
    self.starupName.text = starup[@"starupName"];
    self.starupCategory.text = [starup[@"starupCategory"] capitalizedString];
    self.sales.text = [NSString stringWithFormat:@"%@%@", @"Sales ~ $", starup[@"sales"]];
    NSDate *date = starup[@"operatingSince"];
    self.operatingSince.text = [NSString stringWithFormat:@"%@%ld", @"Operating since: ", (long)date.year];
    NSMutableArray *likedBy = [[NSMutableArray alloc] initWithArray:[self.starup[@"likedBy"] mutableCopy]];
    if ([likedBy containsObject:PFUser.currentUser.username]) {
        [self setVisualLike:NO];
    } else {
        [self setVisualDisslike:NO];
    }
}

- (void)didTapCell:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the starup
    [self.delegate starupCell:self didTap:self.starup];
}

- (void)addGestureRecognizers
{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeOnClick:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [self setUserInteractionEnabled:YES];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCell:)];
    [self addGestureRecognizer:singleTap];
    [self setUserInteractionEnabled:YES];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (IBAction)likeOnClick:(id)sender
{
    UIImpactFeedbackGenerator *likeFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
    [likeFeedback impactOccurred];
    likeFeedback = NULL;
    NSMutableArray *likedBy = [[NSMutableArray alloc] initWithArray:[self.starup[@"likedBy"] mutableCopy]];
    if ([likedBy containsObject:PFUser.currentUser.username]) {
        [self setVisualDisslike:YES];
        [self unLikeStarup];
    } else {
        [self setVisualLike:YES];
        [self likeStarup];
    }
}

- (void)likeStarup
{
    //    Call to like the starup
    self.starup[@"likeCount"] = @([self.starup[@"likeCount"] intValue] + 1);
    [self.starup addObject:PFUser.currentUser.username forKey:@"likedBy"];
    [self.starup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            nil;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)unLikeStarup
{
    //    Call to unlike the starup
    self.starup[@"likeCount"] = @([self.starup[@"likeCount"] intValue] - 1);
    [self.starup removeObject:PFUser.currentUser.username forKey:@"likedBy"];
    [self.starup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            nil;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)setVisualLike:(BOOL)liked
{
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    if (liked) {
        self.likeCount.text = [NSString stringWithFormat:@"%@ likes", @([self.starup[@"likeCount"] intValue] + 1)];
    } else {
        self.likeCount.text = [NSString stringWithFormat:@"%@ likes", self.starup[@"likeCount"]];
    }
}

- (void)setVisualDisslike:(BOOL)liked
{
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    if (liked) {
        self.likeCount.text = [NSString stringWithFormat:@"%@ likes", @([self.starup[@"likeCount"] intValue] - 1)];
    } else {
        self.likeCount.text = [NSString stringWithFormat:@"%@ likes", self.starup[@"likeCount"]];
    }
}

@end
