//
//  StarupCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/8/22.
//

#import "StarupCell.h"

@implementation StarupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setStarup:(Starup *)starup {
//    Setter for the post
    _starup = starup;
    self.starupName.text = starup[@"starupName"];
    self.starupCategory.text = [starup[@"starupCategory"] capitalizedString];
    self.sales.text = [NSString stringWithFormat:@"%@%@", @"Sales ~ $", starup[@"sales"]];
    self.starupDescription.text = starup[@"starupDescription"];
    NSDate *date = starup[@"operatingSince"];
    self.operatingSince.text = [NSString stringWithFormat:@"%@%ld", @"Operating since: ", (long)date.year];
    self.starupImage.file = starup[@"starupImage"];
    [self.starupImage loadInBackground];
}

@end
