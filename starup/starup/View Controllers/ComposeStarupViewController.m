//
//  ComposeStarupViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ComposeStarupViewController.h"


@interface ComposeStarupViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, AddCollaboratorViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ProfilesCollectionCellViewDelegate>

@end


@implementation ComposeStarupViewController

#pragma mark - Initialization

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setOutlets];
    [self pictureGestureRecognizer:self.starupImage];
    // Add gesture recognizer to dissmiss keyboard when clicking on screen
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;
    //    Initialize Arrays
    self.chatParticipants = [[NSMutableArray alloc] init];
    self.ideators = [[NSMutableArray alloc] init];
    self.sharks = [[NSMutableArray alloc] init];
    self.hackers = [[NSMutableArray alloc] init];
    //    Set dropdown menu
    [self setDropDownMenu];
    //    Set collection views
    self.sharksCollectionView.delegate = self;
    self.sharksCollectionView.dataSource = self;
    self.ideatorsCollectionView.delegate = self;
    self.ideatorsCollectionView.dataSource = self;
    self.hackersCollectionView.delegate = self;
    self.hackersCollectionView.dataSource = self;
    //    Set depending on editing status
    [self setDependingOnEditing];
    // For the textfield placeholder to work
    self.descriptionOutlet.delegate = self;
    self.typeHere.hidden = (self.descriptionOutlet.text.length > 0);
}

- (void)setDependingOnEditing
{
    if (self.isEditing) {
        self.shareButton.title = @"Update";
        self.starupName.text = self.starupEditing[@"starupName"];
        self.starupCategory.text = self.starupEditing[@"starupCategory"];
        self.sales.text = [self.starupEditing[@"sales"] stringValue];
        self.descriptionOutlet.text = self.starupEditing[@"starupDescription"];
        self.goalInvestment.text = [self.starupEditing[@"goalInvestment"] stringValue];
        self.percentageToGive.text = [self.starupEditing[@"percentageToGive"] stringValue];
        self.goalInvestment.textColor = [UIColor systemGrayColor];
        self.percentageToGive.textColor = [UIColor systemGrayColor];
        [self.goalInvestment setUserInteractionEnabled:NO];
        [self.percentageToGive setUserInteractionEnabled:NO];
        [self.operatingSince setDate:self.starupEditing[@"operatingSince"]];
        [self.operatingSince setUserInteractionEnabled:NO];
        self.starupImage.file = self.starupEditing[@"starupImage"];
        [self.starupImage loadInBackground];
    } else {
        //    Add the user as an ideator
        [self.ideators addObject:PFUser.currentUser];
        [self.ideatorsCollectionView reloadData];
    }
}

- (void)setOutlets
{
    //  Set the profile picture
    self.profilePicture.file = PFUser.currentUser[@"profileImage"];
    [self.profilePicture loadInBackground];
    //    Format the profile picture
    [Algos formatPictureWithRoundedEdges:self.profilePicture];
}

- (void)setDropDownMenu
{
    UIAction *addShark = [UIAction actionWithTitle:@"Add shark" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self addShark];
    }];
    UIAction *addIdeator = [UIAction actionWithTitle:@"Add ideator" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self addIdeator];
    }];
    UIAction *addHacker = [UIAction actionWithTitle:@"Add hacker" image:NULL identifier:NULL handler:^(UIAction *action) {
        [self addHacker];
    }];
    UIMenu *menu = [[UIMenu alloc] menuByReplacingChildren:[NSArray arrayWithObjects:addShark, addIdeator, addHacker, nil]];

    self.addCollaborator.menu = menu;
    self.addCollaborator.showsMenuAsPrimaryAction = YES;
}

#pragma mark - QualityOfLife

- (void)dismissKeyboard
{
    //    Dissmiss the keyboard
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView
{
    //    If the text changes the placeholder dissapears
    self.typeHere.hidden = (textView.text.length > 0);
}

- (void)refreshCollectionViews
{
    [self.ideatorsCollectionView reloadData];
    [self.sharksCollectionView reloadData];
    [self.hackersCollectionView reloadData];
}

#pragma mark - ImagePicker

- (void)didTapImage:(UITapGestureRecognizer *)sender
{
    //    Gets called when the user taps on the image placeholder, creating and opening an UIImagePickerController
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];

    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;

    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)pictureGestureRecognizer:(UIImageView *)image
{
    //Method to set up a tap gesture recognizer for an image
    UITapGestureRecognizer *imageTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapImage:)];
    [image addGestureRecognizer:imageTapGestureRecognizer];
    [image setUserInteractionEnabled:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];

    // Resize the image
    UIImage *resizedImage = [Algos imageWithImage:originalImage scaledToWidth:414];

    self.starupImage.image = resizedImage;

    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Network

- (IBAction)postStarup:(id)sender
{
    if (self.editing) {
        [self updateExistingStarup];
    } else {
        [self postNewStarup];
    }
}

- (void)postNewStarup
{
    //    Makes the call to post the starup to the db
    //    Shows progress hud
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables sharebutton so that the user cant spam it
    self.shareButton.enabled = false;
    //    Make call
    [Starup postStarup:self.starupName.text withCategory:self.starupCategory.text withDescription:self.descriptionOutlet.text withImage:self.starupImage.image withOperationSince:self.operatingSince.date withSales:(int)[self.sales.text integerValue] withGoalInvestment:(int)[self.goalInvestment.text integerValue] withPercentageToGive:(int)[self.percentageToGive.text integerValue] withCompletion:^(Starup *_Nonnull starup, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            [self addStarupsToIdeators:starup withIdeators:self.ideators];
            [self addStarupsToSharks:starup withSharks:self.sharks];
            [self addStarupsToHackers:starup withHackers:self.hackers];
            [BChatSDK.thread createThreadWithUsers:self.chatParticipants name:self.starupName.text threadCreated:^(NSError *error, id<PThread> thread) {
                [thread setName:self.starupName.text];
                [thread setImageURL:[Algos imageToString:self.starupImage.image]];
                starup[@"starupChatId"] = thread.entityID;
                [starup save];
            }];
            //Calls the didPost method from the delegate and dissmisses the view controller
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)updateExistingStarup
{
    //    Updates an existing starup
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    Dissables sharebutton so that the user cant spam it
    self.shareButton.enabled = false;
    //    Call to change the profile details
    self.starupEditing[@"starupName"] = self.starupName.text;
    self.starupEditing[@"starupCategory"] = self.starupCategory.text;
    self.starupEditing[@"sales"] = [NSNumber numberWithInt:(int)[self.sales.text integerValue]];
    self.starupEditing[@"starupDescription"] = self.descriptionOutlet.text;
    self.starupEditing[@"starupImage"] = [Algos getPFFileFromImage:self.starupImage.image];
    [self.starupEditing saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
        if (succeeded) {
            [self addStarupsToIdeators:self.starupEditing withIdeators:self.ideators];
            [self addStarupsToSharks:self.starupEditing withSharks:self.sharks];
            [self addStarupsToHackers:self.starupEditing withHackers:self.hackers];
            //            Add new participants to the groupchat
            id<PThread> chatThread = [BChatSDK.db fetchEntityWithID:self.starupEditing[@"starupChatId"] withType:bThreadEntity];
            [BChatSDK.thread addUsers:[self.chatParticipants copy] toThread:chatThread];
            //Calls the didPost method from the delegate and dissmisses the view controller
            [self.delegate didPost];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSLog(@"%@", error);
        }
        // hides progress hud
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)checkIfIsCollaborator:(Starup *)starup withUser:(PFUser *)user withCollaboratorType:(NSString *)collaboratorType
{
    PFQuery *find = [PFQuery queryWithClassName:@"Collaborator"];
    [find includeKey:@"user"];
    [find includeKey:@"starup"];
    [find whereKey:@"typeOfUser" equalTo:collaboratorType];
    [find whereKey:@"user" equalTo:user];
    [find whereKey:@"starup" equalTo:starup];
    PFObject *parseObject = [find getFirstObject];
    if (parseObject) {
        nil;
    } else {
        if ((user.objectId == PFUser.currentUser.objectId) && ([collaboratorType isEqual:@"Ideator"])) {
            //  Ownership is calculated by decreasing 100 by the amount of percentage to give
            [Collaborator postCollaborator:collaboratorType withUser:user withStarup:starup withOwnership:[NSNumber numberWithInt:100 - [self.percentageToGive.text intValue]] withCompletion:nil];
        } else {
            [Collaborator postCollaborator:collaboratorType withUser:user withStarup:starup withOwnership:0 withCompletion:nil];
            [self checkIfConnectionExists:user withCloseness:10];
        }
    }
}

- (void)addStarupsToIdeators:(Starup *)starup withIdeators:(NSMutableArray<PFUser *> *)ideators
{
    for (PFUser *ideator in ideators) {
        [self checkIfIsCollaborator:starup withUser:ideator withCollaboratorType:@"Ideator"];
    }
}

- (void)addStarupsToSharks:(Starup *)starup withSharks:(NSMutableArray<PFUser *> *)sharks
{
    for (PFUser *shark in sharks) {
        [self checkIfIsCollaborator:starup withUser:shark withCollaboratorType:@"Shark"];
    }
}

- (void)addStarupsToHackers:(Starup *)starup withHackers:(NSMutableArray<PFUser *> *)hackers
{
    for (PFUser *hacker in hackers) {
        [self checkIfIsCollaborator:starup withUser:hacker withCollaboratorType:@"Hacker"];
    }
}

- (void)checkIfConnectionExists:(PFUser *)user withCloseness:(int)closenesss
{
    //    checks if two users are already close, if they are, make their connection stronger, if theyre not, create a connection between them
    PFQuery *query1 = [PFQuery queryWithClassName:@"UserConnection"];
    [query1 whereKey:@"userOne" equalTo:PFUser.currentUser];
    [query1 whereKey:@"userTwo" equalTo:user];

    PFQuery *query2 = [PFQuery queryWithClassName:@"UserConnection"];
    [query2 whereKey:@"userTwo" equalTo:PFUser.currentUser];
    [query2 whereKey:@"userOne" equalTo:user];

    PFQuery *find = [PFQuery orQueryWithSubqueries:@[ query1, query2 ]];
    [find includeKey:@"userOne"];
    [find includeKey:@"userTwo"];

    [find getFirstObjectInBackgroundWithBlock:^(PFObject *parseObject, NSError *error) {
        if (parseObject) {
            float currCloseness = [parseObject[@"closeness"] floatValue];
            parseObject[@"closeness"] = [NSNumber numberWithFloat:currCloseness + closenesss];
            [parseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *_Nullable error) {
                // Add connection to local graph
                ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                [graph addUserToGraph:user withCompletion:nil];
            }];
        } else {
            //    Posts a user connection
            [UserConnection postUserConnection:PFUser.currentUser withUserTwo:user withCloseness:@(closenesss) withCompletion:^(BOOL succeeded, NSError *_Nullable error) {
                // Add connection to local graph
                ConnectionsGraph *graph = [ConnectionsGraph sharedInstance];
                [graph addUserToGraph:user withCompletion:nil];
            }];
        }
    }];
}


#pragma mark - Navigation

- (IBAction)goBackToStarups:(id)sender
{
    // display starups view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addShark
{
    //     display edit profile view
    [self displayCollaboratorVcWithUserType:@"shark"];
}

- (void)addIdeator
{
    //     display edit profile view
    [self displayCollaboratorVcWithUserType:@"ideator"];
}

- (void)addHacker
{
    //     display edit profile view
    [self displayCollaboratorVcWithUserType:@"hacker"];
}

- (void)displayCollaboratorVcWithUserType:(NSString *)userType
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCollaboratorViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"addCollaboratorNoNav"];
    vc.typeOfUserToAdd = userType;
    vc.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Delegates

- (void)didAddIdeator:(PFUser *)user
{
    if (![self checkIfArrayHasUser:user inArray:self.ideators]) {
        id<PUser> ChatUser = [Algos getChatUserWithId:user[@"chatsId"]];
        [self.chatParticipants addObject:ChatUser];
        [self.ideators addObject:user];
        [self.ideatorsCollectionView reloadData];
    }
}

- (void)didAddHacker:(PFUser *)user
{
    if (![self checkIfArrayHasUser:user inArray:self.hackers]) {
        id<PUser> ChatUser = [Algos getChatUserWithId:user[@"chatsId"]];
        [self.chatParticipants addObject:ChatUser];
        [self.hackers addObject:user];
        [self.hackersCollectionView reloadData];
    }
}

- (void)didAddShark:(PFUser *)user
{
    if (![self checkIfArrayHasUser:user inArray:self.sharks]) {
        id<PUser> ChatUser = [Algos getChatUserWithId:user[@"chatsId"]];
        [self.chatParticipants addObject:ChatUser];
        [self.sharks addObject:user];
        [self.sharksCollectionView reloadData];
    }
}

- (BOOL)checkIfArrayHasUser:(PFUser *)user inArray:(NSMutableArray *)array
{
    for (PFUser *collaborator in array) {
        if ([collaborator.username isEqual:user.username]) {
            return YES;
        }
    }
    return NO;
}

- (void)profileCell:(ProfilesCollectionCellView *)profileCell didTap:(PFUser *)user
{
    //    Goes to profile page when user taps on profile
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
    // Pass the user
    profileViewController.user = user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.sharksCollectionView) {
        //    get the amount of sharks
        return self.sharks.count;
    } else if (collectionView == self.ideatorsCollectionView) {
        //    get the amount of ideators
        return self.ideators.count;
    } else if (collectionView == self.hackersCollectionView) {
        //    get the amount of hackers
        return self.hackers.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProfilesCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"profilesCollectionViewCell" forIndexPath:indexPath];

    if (collectionView == self.sharksCollectionView) {
        //    get the shark and and assign it to the cell
        PFUser *user = self.sharks[indexPath.row];
        cell.user = user;
        cell.delegate = self;
    } else if (collectionView == self.ideatorsCollectionView) {
        //    get the ideator and and assign it to the cell
        PFUser *user = self.ideators[indexPath.row];
        cell.user = user;
        cell.delegate = self;
    } else if (collectionView == self.hackersCollectionView) {
        //    get the hacker and and assign it to the cell
        PFUser *user = self.hackers[indexPath.row];
        cell.user = user;
        cell.delegate = self;
    }
    return cell;
}


@end
