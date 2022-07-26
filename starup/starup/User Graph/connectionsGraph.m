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
        sharedInstance.nodes = [[NSMutableArray alloc] init];
        sharedInstance.edges = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

- (void) fillGraphWithCloseConnections{
    //    Fills the graph with the current users close connections
    [self addNode:PFUser.currentUser];
}

- (void) addSecondaryConnections{
    //    Adds secondary connections (connections of connections) to the local graph
    for (userNode *node in self.nodes){
        [self addNode:node.user];
    }
}

- (void) addNode: (PFUser *)user{
    //    Adds a node to the graph
    PFQuery *query1 = [PFQuery queryWithClassName:@"UserConnection"];
    [query1 whereKey:@"userOne" equalTo:user];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"UserConnection"];
    [query2 whereKey:@"userTwo" equalTo:user];
    
    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [query3 includeKey:@"userOne"];
    [query3 includeKey:@"userTwo"];
    
    // fetch data asynchronously
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *edges, NSError *error) {
        if (edges != nil) {
            self.addedUser = NO;
            for (UserConnection *edge in edges){
                userNode *nodeOne = [self checkIfNodeExistsForUser:edge[@"userOne"]];
                userNode *nodeTwo = [self checkIfNodeExistsForUser:edge[@"userTwo"]];
                [self checkIfEdgeExistsForNodes:nodeOne :nodeTwo :[edge[@"closeness"] intValue]];
            }
            if ([self.nodes count]<400 && self.addedUser){
                [self addSecondaryConnections];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (userNode*) checkIfNodeExistsForUser: (PFUser *)user{
    for (userNode *node in self.nodes){
        if ([node.user[@"username"] isEqual:user.username]){
            return node;
        }
    }
    userNode *node = [[userNode alloc]initWithUser:user];
    [self.nodes addObject:node];
    self.addedUser = YES;
    return node;
}

- (int) checkIfEdgeExistsForNodes: (userNode *)nodeOne :(userNode *)nodeTwo :(int)closeness{
    for (usersEdge *edge in self.edges){
        if (edge.node1 == nodeOne && edge.node2 == nodeTwo){
            edge.closeness = closeness;
            return 0;
        }
    }
    usersEdge *edgeToAdd = [[usersEdge alloc]initWithNodes:nodeOne :nodeTwo :closeness];
    [self.edges addObject:edgeToAdd];
    return 1;
}

//- (void) Dijkstra{
//    for (UserConnection* vertex in self.weightedGraph){
//
//    }
//}

@end
