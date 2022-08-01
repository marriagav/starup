//
//  PModule.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#ifndef PModule_h
#define PModule_h

#define bServerFirebase @"bServerFirebase"
#define bServerXMPP @"bServerXMPP"

@protocol PModule <NSObject>

-(void) activate;
//-(NSString *) name;

@optional

-(void) activateWithServer: (NSString *) server;
-(int) weight;

@end

#endif /* PModule_h */
