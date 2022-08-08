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
    [self cellGestureRecognizer];
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
    NSMutableArray* likedBy = [[NSMutableArray alloc]initWithArray:[self.starup[@"likedBy"] mutableCopy]];
    if ([likedBy containsObject:PFUser.currentUser.username]){
        [self setVisualLike];
    }
    else{
        [self setVisualDisslike];
    }
}

- (void)didTapCell:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the starup
    [self.delegate starupCell:self didTap:self.starup];
}

- (void)cellGestureRecognizer
{
    //    Method to set up a tap gesture recognizer for the cell
    UITapGestureRecognizer *cellTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCell:)];
    [self addGestureRecognizer:cellTapGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

- (IBAction)likeOnClick:(id)sender {
    NSMutableArray* likedBy = [[NSMutableArray alloc]initWithArray:[self.starup[@"likedBy"] mutableCopy]];
    if ([likedBy containsObject:PFUser.currentUser.username]){
        [self unLikeStarup];
    }
    else{
        [self likeStarup];
    }
}

- (void)likeStarup{
    //    Dissables likebutton so that the user cant spam it
    self.likeButton.enabled = false;
    //    Call to change the profile details
    self.starup[@"likeCount"] = @([self.starup[@"likeCount"] intValue] + 1);
    [self.starup addObject:PFUser.currentUser.username forKey:@"likedBy"];
    [self.starup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            [self setVisualLike];
            self.likeButton.enabled = true;
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)unLikeStarup{
    //    Dissables likebutton so that the user cant spam it
    self.likeButton.enabled = false;
    //    Call to change the profile details
    self.starup[@"likeCount"] = @([self.starup[@"likeCount"] intValue] - 1);
    [self.starup removeObject:PFUser.currentUser.username forKey:@"likedBy"];
    [self.starup saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
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
    self.likeCount.text = [NSString stringWithFormat:@"%@ likes",self.starup[@"likeCount"]];
}

- (void)setVisualDisslike{
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    self.likeCount.text = [NSString stringWithFormat:@"%@ likes",self.starup[@"likeCount"]];
}

@end
