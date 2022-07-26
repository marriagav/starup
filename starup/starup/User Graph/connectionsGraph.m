//
//  connectionsGraph.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import "connectionsGraph.h"

@implementation connectionsGraph

#pragma mark Initialize

+ ( connectionsGraph * )sharedInstance {
    static dispatch_once_t predicate;
    static connectionsGraph *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[connectionsGraph alloc] init];
        sharedInstance.weightedGraph = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

- (void) fillGraphWithCloseConnections{
//    Fills the graph with the current users close connections
    [self addNode:PFUser.currentUser];
}

- (void) addNode: (PFUser *)user {
//    Adds a node to the graph
    PFQuery *query1 = [PFQuery queryWithClassName:@"UserConnection"];
    [query1 whereKey:@"userOne" equalTo:user];

    PFQuery *query2 = [PFQuery queryWithClassName:@"UserConnection"];
    [query1 whereKey:@"userTwo" equalTo:user];

    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [query3 includeKey:@"userOne"];
    [query3 includeKey:@"userTwo"];
    [query3 includeKey:@"vertices"];
    
    // fetch data asynchronously
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *vertices, NSError *error) {
        if (vertices != nil) {
            userNode *node = [[userNode alloc]initWithUser:user withVertices:[vertices mutableCopy]];
            [self.weightedGraph addObject:node];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

//- (void) Dijkstra{
//    for (UserConnection* vertex in self.weightedGraph){
//        
//    }
//}

@end
