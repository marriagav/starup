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
        sharedInstance.searchResults = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

#pragma mark Fill the graph

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
    
    //  fetch data asynchronously
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *edges, NSError *error) {
        if (edges != nil) {
            self.addedUser = NO;
            for (UserConnection *edge in edges){
                userNode *nodeOne = [self checkIfNodeExistsForUser:edge[@"userOne"]];
                userNode *nodeTwo = [self checkIfNodeExistsForUser:edge[@"userTwo"]];
                [self checkIfEdgeExistsForNodes:nodeOne :nodeTwo :-[edge[@"closeness"] intValue]];
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

#pragma mark Dijkstra

- (NSMutableArray *) GetUsersWithSubstring: (NSString *)searchParameter{
    [self.searchResults removeAllObjects];
    userNode *current = [self checkIfNodeExistsForUser:PFUser.currentUser];
    [self Dijkstra:current];
    //    while (current!= nil){
    //        if ([current.user.username containsString:searchParameter]){
    //            NSLog(@"%@", current.user.username);
    //            [self.searchResults addObject:current.user];
    //        }
    //        current = current.previous;
    //    }
    return self.searchResults;
}

- (void) Dijkstra: (userNode *)source{
    self.nodesQueue = [[NSMutableArray alloc] initWithArray:self.nodes];
    source.distanceFromStart = 0;
    while ([self.nodesQueue count]>0){
        userNode *smallest = [self ExtractSmallest];
        NSMutableArray *adjecentNodes = [self AdjecentRemainingNodes:smallest];
        for (userNode *adjecentNode in adjecentNodes){
            int distance = [self Distance:smallest :adjecentNode] + smallest.distanceFromStart;
            if (distance < adjecentNode.distanceFromStart){
                adjecentNode.distanceFromStart = distance;
                adjecentNode.previous = smallest;
            }
        }
        adjecentNodes = nil;
    }
}

- (userNode *) ExtractSmallest{
    userNode *smallest = self.nodesQueue[0];
    for (userNode *node in self.nodesQueue){
        if (node.distanceFromStart < smallest.distanceFromStart){
            smallest = node;
        }
    }
    NSRange r;
    r.location = 0;
    r.length = [self.nodesQueue indexOfObject:smallest]+1;
    [self.nodesQueue removeObjectsInRange:r];
    return smallest;
}

- (NSMutableArray *) AdjecentRemainingNodes: (userNode*) node {
    NSMutableArray *adjecentNodes = [[NSMutableArray alloc] init];
    for (usersEdge *edge in self.edges){
        userNode *adjecent = nil;
        if (edge.node1 == node){
            adjecent = edge.node2;
        }
        else if (edge.node2 == node){
            adjecent = edge.node1;
        }
        if (adjecent && [self contains:self.nodesQueue :adjecent]){
            [adjecentNodes addObject:adjecent];
        }
    }
    return adjecentNodes;
}

- (int) Distance: (userNode *)nodeOne :(userNode *)nodeTwo{
    // Return distance between two connected nodes
    for (usersEdge *edge in self.edges){
        if ((edge.node1 == nodeOne && edge.node2 == nodeTwo) || (edge.node1 == nodeTwo && edge.node2 == nodeOne)){
            return edge.closeness;
        }
    }
    return -1;  // should never happen
}

- (BOOL) contains: (NSMutableArray *)nodes :(userNode *)nodeArg{
    //    Checks if a nodes array contain nodeArg
    for (userNode *node in nodes){
        if ([node isEqual: nodeArg]){
            return YES;
        }
    }
    return NO;
}

//- (NSMutableArray *) quickSort: (NSMutableArray *)toSort{
//
//    int intLength = toSort.count;
//    if (intLength == 0){
//        return toSort;
//    }
//    else if (intLength == 1){
//        return toSort;
//    }else if (intLength==2){
//        if ([toSort[0] doubleValue] <= [toSort[1] doubleValue]) {
//            return toSort;
//        }else{
//            NSNumber *temp = [toSort objectAtIndex:0];
//            [toSort replaceObjectAtIndex:0 withObject:[toSort objectAtIndex:1]];
//            [toSort replaceObjectAtIndex:1 withObject:temp];
//            return toSort;
//        }
//    }
//
//    int r = arc4random_uniform(intLength);
//    double pivot = [[toSort objectAtIndex:r] doubleValue];
//
//    NSMutableArray *lowArray = [NSMutableArray array];
//    NSMutableArray *highArray = [NSMutableArray array];
//    NSMutableArray *equalArray = [NSMutableArray array];
//    for(int i = 0; i < intLength; i++){
//        double arrayMember = [[toSort objectAtIndex:i] doubleValue];
//        if (arrayMember < pivot) {
//            [lowArray addObject:[NSNumber numberWithDouble:arrayMember]];
//        }else if (arrayMember > pivot){
//            [highArray addObject:[NSNumber numberWithDouble:arrayMember]];
//        }else{
//            [equalArray addObject:[NSNumber numberWithDouble:arrayMember]];
//        }
//    }
//
//    NSMutableArray *returnLeft = [self quickSort:lowArray];
//    NSMutableArray *returnRight = [self quickSort:highArray];
//
//    NSMutableArray *returnArray = returnLeft;
//    [returnArray addObjectsFromArray:equalArray];
//    [returnArray addObjectsFromArray:returnRight];
//
//    return returnArray;
//
//}

@end
