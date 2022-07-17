//
//  DetailsViewController.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Starup.h"
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Starup *starup;
@property (weak, nonatomic) IBOutlet UILabel *starupName;
@property (weak, nonatomic) IBOutlet UILabel *starupDescription;
@property (weak, nonatomic) IBOutlet UILabel *starupCategory;
@property (weak, nonatomic) IBOutlet UILabel *operatingSince;
@property (weak, nonatomic) IBOutlet UILabel *sales;
@property (weak, nonatomic) IBOutlet PFImageView *starupImage;
@property (weak, nonatomic) IBOutlet UICollectionView *ideatorsCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *hackersCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *sharksCollectionView;
@property (weak, nonatomic) IBOutlet UIProgressView *investmentProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *progressString;

@end

NS_ASSUME_NONNULL_END
