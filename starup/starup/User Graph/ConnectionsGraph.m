//
//  connectionsGraph.m
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import "ConnectionsGraph.h"


@implementation ConnectionsGraph

#pragma mark Initialize

+ (ConnectionsGraph *)sharedInstance
{
    static dispatch_once_t predicate;
    static ConnectionsGraph *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[ConnectionsGraph alloc] init];
        sharedInstance.nodes = [[NSMutableArray alloc] init];
        sharedInstance.edges = [[NSMutableArray alloc] init];
        sharedInstance.searchResults = [[NSMutableArray alloc] init];
    });
    return sharedInstance;
}

#pragma mark Fill the graph

- (void)fillGraphWithCloseConnections:(void (^__nullable)(NSError *_Nullable error))completion
{
    //    Fills the graph with the current users close connections
    self.serviceGroup = dispatch_group_create();
    __weak __typeof(self) weakSelf = self;
    dispatch_group_enter(self.serviceGroup);
    [weakSelf addNode:PFUser.currentUser isLoading:YES withCompletion:^(NSError *_Nonnull error) {
        dispatch_group_leave(weakSelf.serviceGroup);
    }];
    dispatch_group_notify(self.serviceGroup, dispatch_get_main_queue(), ^{
        // Now call the final completion block
        completion(nil);
    });
}

- (void)addUserToGraph:(PFUser *)user withCompletion:(void (^__nullable)(NSError *_Nullable error))completion
{
    //    Fills the graph with the users close connections
    [self addNode:user isLoading:NO withCompletion:^(NSError *_Nonnull error) {
        nil;
    }];
}

- (void)addSecondaryConnectionsLoading
{
    //    Adds secondary connections (connections of connections) to the local graph
    for (UserNode *node in self.nodes) {
        dispatch_group_enter(self.serviceGroup);
        __weak __typeof(self) weakSelf = self;
        [self addNode:node.user isLoading:YES withCompletion:^(NSError *_Nonnull error) {
            dispatch_group_leave(weakSelf.serviceGroup);
        }];
    }
}

- (void)addSecondaryConnectionsNotLoading
{
    //    Adds secondary connections (connections of connections) to the local graph
    for (UserNode *node in self.nodes) {
        [self addNode:node.user isLoading:NO withCompletion:^(NSError *_Nonnull error) {
            nil;
        }];
    }
}

- (void)addNode:(PFUser *)user isLoading:(BOOL)loading
    withCompletion:(void (^__nullable)(NSError *_Nullable error))completion
{
    //    Adds a node to the graph

    PFQuery *query1 = [PFQuery queryWithClassName:@"UserConnection"];
    [query1 whereKey:@"userOne" equalTo:user];

    PFQuery *query2 = [PFQuery queryWithClassName:@"UserConnection"];
    [query2 whereKey:@"userTwo" equalTo:user];

    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[ query1, query2 ]];
    [query3 includeKey:@"userOne"];
    [query3 includeKey:@"userTwo"];

    //  fetch data asynchronously
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *edges, NSError *error) {
        if (edges != nil) {
            self.addedUser = NO;
            for (UserConnection *edge in edges) {
                UserNode *nodeOne = [self checkIfNodeExistsForUser:edge[@"userOne"]];
                UserNode *nodeTwo = [self checkIfNodeExistsForUser:edge[@"userTwo"]];
                [self checkIfEdgeExistsForNodes:nodeOne withNodeTwo:nodeTwo withCloseness:-[edge[@"closeness"] intValue]];
            }
            if ([self.nodes count] < 400 && self.addedUser) {
                if (loading) {
                    [self addSecondaryConnectionsLoading];
                } else {
                    [self addSecondaryConnectionsNotLoading];
                }
            }
            [self Dijkstra:[self checkIfNodeExistsForUser:PFUser.currentUser]];
            completion(nil);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UserNode *)checkIfNodeExistsForUser:(PFUser *)user
{
    for (UserNode *node in self.nodes) {
        node.distanceFromStart = INT_MAX;
        if ([node.user[@"username"] isEqual:user.username]) {
            return node;
        }
    }
    UserNode *node = [[UserNode alloc] initWithUser:user];
    [self.nodes addObject:node];
    self.addedUser = YES;
    return node;
}

- (int)checkIfEdgeExistsForNodes:(UserNode *)nodeOne withNodeTwo:(UserNode *)nodeTwo withCloseness:(int)closeness
{
    for (UsersEdge *edge in self.edges) {
        if (edge.node1 == nodeOne && edge.node2 == nodeTwo) {
            edge.closeness = closeness;
            return 0;
        }
    }
    UsersEdge *edgeToAdd = [[UsersEdge alloc] initWithNodes:nodeOne node2:nodeTwo closeness:closeness];
    [self.edges addObject:edgeToAdd];
    return 1;
}

- (void)resetGraph
{
    [self.nodes removeAllObjects];
    [self.edges removeAllObjects];
}

#pragma mark Search

- (NSMutableArray *)GetCloseUsersWithSubstring:(NSString *)searchParameter withNumberOfUsers:(int)numOfUsers
{
    [self.searchResults removeAllObjects];
    int count = 0;
    if ([searchParameter isEqual:@""]) {
        for (UserNode *node in self.nodes) {
            if (count == numOfUsers) {
                return self.searchResults;
            }
            [self.searchResults addObject:node.user];
            count += 1;
        }
    } else {
        for (UserNode *node in self.nodes) {
            if ([[node.user[@"normalizedUsername"] lowercaseString] containsString:searchParameter] || [node.user[@"normalizedFullname"] containsString:searchParameter]) {
                if (count == numOfUsers) {
                    return self.searchResults;
                }
                [self.searchResults addObject:node.user];
                count += 1;
            }
        }
    }
    return self.searchResults;
}

- (NSMutableArray *)GetDeepUsersWithSubstring:(NSString *)searchParameter withNumberOfUsers:(int)numOfUsers
{
    int count = 0;
    NSMutableArray *subarray = [self.nodes mutableCopy];
    for (UserNode *node in self.nodes) {
        if ([Algos userInArray:node.user withArray:self.searchResults]) {
            [subarray removeObject:node];
        }
    }
    [self.searchResults removeAllObjects];
    if ([searchParameter isEqual:@""]) {
        for (UserNode *node in subarray) {
            if (count == numOfUsers) {
                return self.searchResults;
            }
            [self.searchResults addObject:node.user];
            count += 1;
        }
    } else {
        for (UserNode *node in subarray) {
            if ([[node.user[@"normalizedUsername"] lowercaseString] containsString:searchParameter] || [node.user[@"normalizedFullname"] containsString:searchParameter]) {
                if (count == numOfUsers) {
                    return self.searchResults;
                }
                [self.searchResults addObject:node.user];
                count += 1;
            }
        }
    }
    return self.searchResults;
}

#pragma mark Dijkstra

- (void)SortGraphWithDistances
{
    [self.nodes sortUsingComparator:^NSComparisonResult(UserNode *node1, UserNode *node2) {
        if (node1.distanceFromStart > node2.distanceFromStart) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (node1.distanceFromStart < node2.distanceFromStart) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)Dijkstra:(UserNode *)source
{
    self.nodesQueue = [[NSMutableArray alloc] initWithArray:self.nodes];
    source.distanceFromStart = 0;
    while ([self.nodesQueue count] > 0) {
        UserNode *smallest = [self ExtractSmallest];
        NSMutableArray *adjecentNodes = [self AdjecentRemainingNodes:smallest];
        for (UserNode *adjecentNode in adjecentNodes) {
            int distance = [self Distance:smallest withNodeTwo:adjecentNode] + smallest.distanceFromStart;
            if (distance < adjecentNode.distanceFromStart) {
                adjecentNode.distanceFromStart = distance;
                adjecentNode.previous = smallest;
            }
        }
        adjecentNodes = nil;
    }
    [self.nodesQueue removeAllObjects];
    [self SortGraphWithDistances];
}

- (UserNode *)ExtractSmallest
{
    UserNode *smallest = self.nodesQueue[0];
    for (UserNode *node in self.nodesQueue) {
        if (node.distanceFromStart < smallest.distanceFromStart) {
            smallest = node;
        }
    }
    NSRange r;
    r.location = 0;
    r.length = [self.nodesQueue indexOfObject:smallest] + 1;
    [self.nodesQueue removeObjectsInRange:r];
    return smallest;
}

- (NSMutableArray *)AdjecentRemainingNodes:(UserNode *)node
{
    NSMutableArray *adjecentNodes = [[NSMutableArray alloc] init];
    for (UsersEdge *edge in self.edges) {
        UserNode *adjecent = nil;
        if (edge.node1 == node) {
            adjecent = edge.node2;
        } else if (edge.node2 == node) {
            adjecent = edge.node1;
        }
        if (adjecent && [self contains:self.nodesQueue withNodes:adjecent]) {
            [adjecentNodes addObject:adjecent];
        }
    }
    return adjecentNodes;
}

- (int)Distance:(UserNode *)nodeOne withNodeTwo:(UserNode *)nodeTwo
{
    // Return distance between two connected nodes
    for (UsersEdge *edge in self.edges) {
        if ((edge.node1 == nodeOne && edge.node2 == nodeTwo) || (edge.node1 == nodeTwo && edge.node2 == nodeOne)) {
            return edge.closeness;
        }
    }
    return -1; // should never happen
}

- (BOOL)contains:(NSMutableArray *)nodes withNodes:(UserNode *)nodeArg
{
    //    Checks if a nodes array contain nodeArg
    for (UserNode *node in nodes) {
        if ([node isEqual:nodeArg]) {
            return YES;
        }
    }
    return NO;
}

@end
