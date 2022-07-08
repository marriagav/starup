//
//  ProfileViewController.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/6/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)refreshDataWithNPosts:(int) numberOfPosts{
//    Refreshes the tableview data with numberOfPosts posts
    // construct query
    

    // fetch data asynchronously
    
}

- (void)_beginRefresh:(UIRefreshControl *)refreshControl {
//    Refreshes the data using the UIRefreshControl
    // construct query
    

    // fetch data asynchronously
    
}


- (void)_initializeRefreshControl{
//    Initialices and inserts the refresh control
    
    
}

- (void)_initializeRefreshControlB{
//    Initialices and inserts the refresh control
    // Set up Infinite Scroll loading indicator
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
    (NSInteger)section{
//    return amount of posts in the postArray
    
    
    return 0;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath{
//    initialize cell (PostCell) to a reusable cell using the PostCell identifier
    
//    get the post and delegate and assign it to the cell
    
    return NULL;
    
}

- (void)didPost{
//    Gets called when the user presses the "share" button on the "ComposePost" view, this controller functions as a delegate of the former
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    Calls load more data when scrolling reaches bottom of the tableView
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    Checks if is scrolling
}

- (void)loadMoreData{
//    Adds 20 more posts to the tableView, for infinte scrolling
    
}

//TODO: setup collection view

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
