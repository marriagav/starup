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
    //    Setter for the post
    _starup = starup;
    self.starupImage.file = starup[@"starupImage"];
    [self.starupImage loadInBackground];
    self.starupName.text = starup[@"starupName"];
    self.starupCategory.text = [starup[@"starupCategory"] capitalizedString];
    self.sales.text = [NSString stringWithFormat:@"%@%@", @"Sales ~ $", starup[@"sales"]];
    self.starupDescription.text = starup[@"starupDescription"];
    NSDate *date = starup[@"operatingSince"];
    self.operatingSince.text = [NSString stringWithFormat:@"%@%ld", @"Operating since: ", (long)date.year];
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

@end
