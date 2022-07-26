//
//  connectionsGraph.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import <Foundation/Foundation.h>
#import "userNode.h"
#import "usersEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface connectionsGraph : NSObject

+ (connectionsGraph *)sharedInstance;

@property (nonatomic, strong) NSMutableArray *nodes;
@property (nonatomic, strong) NSMutableArray *edges;

- (void) fillGraphWithCloseConnections;
- (void) addNode: (PFUser *)user withSecondaryConnections: (BOOL)withSecondary;

@end

NS_ASSUME_NONNULL_END