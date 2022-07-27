//
//  connectionsGraph.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import <Foundation/Foundation.h>
#import "userNode.h"
#import "usersEdge.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN

@interface connectionsGraph : NSObject

+ (connectionsGraph *)sharedInstance;

@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableArray *nodesQueue;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property BOOL addedUser;
@property dispatch_group_t serviceGroup;

- (void) fillGraphWithCloseConnections :(void (^ __nullable)(NSError * _Nullable error))completion;
- (void) addNode: (PFUser *)user :(void (^ __nullable)(NSError * _Nullable error))completion;
- (NSMutableArray *) GetCloseUsersWithSubstring: (NSString *)searchParameter withNumberOfUsers:(int)numOfUsers;
- (NSMutableArray *) GetDeepUsersWithSubstring: (NSString *)searchParameter withNumberOfUsers:(int)numOfUsers;
- (void) resetGraph;

@end

NS_ASSUME_NONNULL_END
