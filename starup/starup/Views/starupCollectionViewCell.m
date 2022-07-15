//
//  starupCollectionViewCell.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/15/22.
//

#import "starupCollectionViewCell.h"

@implementation starupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCollaborator:(Collaborator *)collaborator{
//    Setter for the collaborator
    _collaborator = collaborator;
    self.starupName.text = self.collaborator[@"starup"][@"starupName"];
    self.userRoleText = self.collaborator[@"typeOfUser"];
}

@end
