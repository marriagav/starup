//
//  connectionsGraph.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/ChatSDK.h>
#import <ChatSDKFirebase/ChatSDKFirebase-Swift.h>
#import <ChatSDKFirebase/CCUserWrapper.h>
#import "UserNode.h"
#import "UsersEdge.h"
#import "Algos.h"

NS_ASSUME_NONNULL_BEGIN


@interface ConnectionsGraph : NSObject

+ (ConnectionsGraph *)sharedInstance;

@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableArray *nodesQueue;
@property (nonatomic, strong) NSMutableArray *edges;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property BOOL addedUser;
@property dispatch_group_t serviceGroup;

- (void)fillGraphWithCloseConnections:(void (^__nullable)(NSError *_Nullable error))completion;
- (void)addUserToGraph:(PFUser *)user withCompletion:(void (^__nullable)(NSError *_Nullable error))completion;
- (NSMutableArray *)GetCloseUsersWithSubstring:(NSString *)searchParameter withNumberOfUsers:(int)numOfUsers;
- (NSMutableArray *)GetDeepUsersWithSubstring:(NSString *)searchParameter withNumberOfUsers:(int)numOfUsers;
- (void)resetGraph;

@end

NS_ASSUME_NONNULL_END
