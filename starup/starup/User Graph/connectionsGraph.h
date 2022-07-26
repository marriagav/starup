//
//  connectionsGraph.h
//  starup
//
//  Created by Miguel Arriaga Velasco on 7/25/22.
//

#import <Foundation/Foundation.h>
#import "userNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface connectionsGraph : NSObject

+ (connectionsGraph *)sharedInstance;
@property (nonatomic, strong) NSMutableArray *weightedGraph;

@end

NS_ASSUME_NONNULL_END
