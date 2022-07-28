//
//  starupCollectionViewCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import "StarupCollectionCellView.h"


@implementation StarupCollectionCellView

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
    [self cellGestureRecognizer];
}

- (void)setCollaborator:(Collaborator *)collaborator
{
    //    Setter for the collaborator
    _collaborator = collaborator;
    self.starupName.text = self.collaborator[@"starup"][@"starupName"];
    self.userRoleText = self.collaborator[@"typeOfUser"];
    [self setImageFromText];
}

- (void)setImageFromText
{
    if ([self.userRoleText isEqual:@"Ideator"]) {
        //  Set the profile picture
        self.userRoleImage.image = [UIImage imageNamed:@"ideator-1"];
    } else if ([self.userRoleText isEqual:@"Shark"]) {
        //  Set the profile picture
        self.userRoleImage.image = [UIImage imageNamed:@"shark-1"];
    } else if ([self.userRoleText isEqual:@"Hacker"]) {
        //  Set the profile picture
        self.userRoleImage.image = [UIImage imageNamed:@"hacker-1"];
    }
    //    Format the profile picture
    self.userRoleImage.layer.cornerRadius = self.userRoleImage.frame.size.height / 2;
    self.userRoleImage.layer.borderWidth = 0;
    self.userRoleImage.clipsToBounds = YES;
}

- (void)didTapCell:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the starup
    [self.delegate starupCell:self didTap:self.collaborator[@"starup"]];
}

- (void)cellGestureRecognizer
{
    //    Method to set up a tap gesture recognizer for the cell
    UITapGestureRecognizer *cellTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCell:)];
    [self addGestureRecognizer:cellTapGestureRecognizer];
    [self setUserInteractionEnabled:YES];
}

@end
