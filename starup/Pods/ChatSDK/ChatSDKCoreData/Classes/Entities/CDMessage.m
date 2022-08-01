//
//  CDMessage.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import "CDMessage.h"

#import <ChatSDK/CoreData.h>
#import <ChatSDK/Core.h>

@implementation CDMessage

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width {
    return [self.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: font}
                                   context:Nil].size.height;
}

-(NSComparisonResult) compare: (id<PMessage>) message {
    return [self.date compare:message.date];
}

-(void) setUserModel:(id<PUser>)user {
    if ([user isKindOfClass:[CDUser class]]) {
        self.user = (CDUser *) user;
    }
}

-(id<PUser>) userModel {
    return self.user;
}

#pragma Image information

-(NSURL*) imageURL {
    NSString * url = self.meta[bMessageImageURL];
    return [NSURL URLWithString:url];
}

- (NSInteger)imageWidth {
    CGSize size = [self getImageSize];
    return size.width;
    
    // Check which one is bigger and then scale it to be 600 pixels
//    return size.width > size.height ? 600 : 600 * size.width/size.height;
}

- (NSInteger)imageHeight {
    
    CGSize size = [self getImageSize];
    return size.height;
    
    // Check which one is bigger and then scale it to be 600 pixels
//    return size.height > size.width ? 600 : 600 * size.height/size.width;
}

-(CGSize) getImageSize {
    NSNumber * widthNumber = self.meta[bMessageImageWidth];
    NSNumber * heightNumber = self.meta[bMessageImageHeight];
    
    float height = -1;
    float width = -1;
    
    // TODO: Depricated - remove this
    if (!widthNumber || !heightNumber) {
        
        NSArray * myArray = [self.text componentsSeparatedByString:@","];
        
        if (myArray.count > 2) {
            
            NSArray * dimensions = [myArray[2] componentsSeparatedByString:@"&"];
            
            if (dimensions.count > 0) {
                width = [[dimensions[0] substringFromIndex:1] floatValue];
            }
            
            if (dimensions.count > 1) {
                // Take off the first letter and then use the dimensions
                height = [[dimensions[1] substringFromIndex:1] floatValue];
            }
        }
        
        if (height == -1 || width == -1) {
            return [UIImage imageWithData:self.placeholder].size;
        }
    }
    else {
        width = [widthNumber floatValue];
        height = [heightNumber floatValue];
    }
    
    return CGSizeMake(width, height);
}

-(id<PMessage>) model {
    return self;
}

-(bMessagePos) messagePosition {
    if (!_position) {
        [self updatePosition];
    }
    return [_position intValue];
}

-(NSString *) text {
    NSObject * text = self.meta[bMessageText];
    if ([text isKindOfClass:NSString.class]) {
        return text;
    }
    if ([text isKindOfClass:NSNumber.class]) {
        return ((NSNumber *)text).stringValue;
    }
    else return @"";
}

-(void) setText: (NSString *) text {
    NSLog(@"Text %@", text);
    [self updateMeta:@{bMessageText: [NSString safe:text]}];
}

// This helps us know if we want to show it in the thread
- (BOOL)showUserNameLabelForPosition: (bMessagePos) position {
    if (self.senderIsMe) {
        return NO;
    }

    if ((self.thread.type.intValue & bThreadFilterPublic || self.thread.users.count > 2) && position & bMessagePosLast) {
        return YES;
    }

    if (!(position & bMessagePosLast)) {
        return NO;
    }

    return NO;
}

-(bMessageReadStatus) readStatusForUserID: (NSString *) uid {
    if (!self.readStatus) {
        return bMessageReadStatusNone;
    }

    NSDictionary * status = self.readStatus;
    if(status && uid) {
        NSDictionary * userStatus = status[uid];
        return [userStatus[bStatus] intValue];
    }
    return bMessageReadStatusNone;
    
    
}

-(BOOL) setReadStatus: (bMessageReadStatus) status_ forUserID: (NSString *) uid {
    return [self setReadStatus:status_ forUserID:uid date:BChatSDK.core.now];
}

-(BOOL) setReadStatus: (bMessageReadStatus) status_ forUserID: (NSString *) uid date: (NSDate *) date {
//    if (status_ != [self readStatusForUserID:uid]) {
    if (status_ > [self readStatusForUserID:uid]) {
        NSMutableDictionary * mutableStatus = [NSMutableDictionary dictionaryWithDictionary:self.readStatus];
        mutableStatus[uid] = @{bStatus: @(status_), bDate: date};
        [self setReadStatus:mutableStatus];
        if (status_ == bMessageReadStatusRead && [uid isEqualToString:BChatSDK.currentUserID]) {
            self.read = @YES;
        }
        return true;
    }
    return false;
}

-(bMessageReadStatus) messageReadStatus {
    if (!self.readStatus) {
        return bMessageReadStatusNone;
    }
    
    int userCount = 0;
    int deliveredCount = 0;
    int readCount = 0;
    
    NSDictionary * messageStatus = self.readStatus;
    
    if (!messageStatus.count) {
        return bMessageReadStatusRead;
    }

    NSString * currentUserID = BChatSDK.currentUserID;
    for (NSString * key in messageStatus.allKeys) {
        if ([key isEqual:currentUserID]) {
            continue;
        }
        
        NSDictionary * userStatus = messageStatus[key];
        bMessageReadStatus status = [userStatus[bStatus] intValue];
        if (status != bMessageReadStatusHide) {
            if (status == bMessageReadStatusDelivered) {
                deliveredCount++;
            }
            if (status == bMessageReadStatusRead) {
                deliveredCount++;
                readCount++;
            }
            userCount++;
        }
    }
    if(readCount == userCount) {
        return bMessageReadStatusRead;
    }
    else if (deliveredCount == userCount) {
        return bMessageReadStatusDelivered;
    }
    else {
        return bMessageReadStatusNone;
    }
}

-(BOOL) senderIsMe {
    return self.userModel.isMe;
}

-(void) updatePosition {
    BOOL isFirst = !self.previousMessage || ![self.previousMessage.user isEqualToEntity: self.user];
    BOOL isLast = !self.nextMessage || ![self.nextMessage.user isEqualToEntity: self.user];;
    
    // Also check if we are the first or last message of a day
    isFirst = isFirst || [self.date isNextDay: self.previousMessage.date];
    isLast = isLast || [self.date isPreviousDay:self.nextMessage.date] ;
    
    // Also check to see the message type is different
    isFirst = isFirst || self.type.intValue != self.previousMessage.type.intValue;
    isLast = isLast || self.type.intValue != self.nextMessage.type.intValue;
    
    int position = 0;
    if (isFirst) {
        position = position | bMessagePosFirst;
    }
    if (isLast) {
        position = position | bMessagePosLast;
    }
   
    _position = @(position);
}

-(void) updateMeta: (NSDictionary *) dict {
    if (!self.meta) {
        self.meta = @{};
    }
    self.meta = [self.meta updateMetaDict:dict];
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    [self updateMeta:@{key: [NSString safe:value]}];
}

-(BOOL) isRead {
    return self.read || [self readStatusForUserID:BChatSDK.currentUserID] == bMessageReadStatusRead;
}

-(BOOL) isDelivered {
    return  self.read || self.delivered || [self readStatusForUserID:BChatSDK.currentUserID] >= bMessageReadStatusDelivered;
}

-(BOOL) isReply {
    return self.reply;
}

-(NSString *) reply {
    return self.meta[bReplyKey];
}

-(bMessageType) replyType {
    return [self.meta[bType] intValue];
}

-(BOOL) sendFailed {
    NSNumber * status = self.meta[bMessageSendStatusKey];
    if (status != nil && status.intValue == bMessageSendStatusFailed) {
        return YES;
    }
    return NO;
}

-(void) setMessageSendStatus: (bMessageSendStatus) status {
    [self setMetaValue:@(status) forKey:bMessageSendStatusKey];
}

-(bMessageSendStatus) messageSendStatus {
    NSNumber * status = self.meta[bMessageSendStatusKey];
    if (status != nil) {
        return status.intValue;
    }
    return bMessageSendStatusNone;
}

-(void) setupInitialReadReceipts {
    // Setup the initial read receipts
    if (self.thread) {
        NSMutableDictionary * mutableStatus = [NSMutableDictionary dictionaryWithDictionary:self.readStatus];
        for (id<PUser> user in self.thread.members) {
            if (user.isMe) {
                mutableStatus[user.entityID] = @{bStatus: @(bMessageReadStatusRead), bDate: BChatSDK.core.now};
            } else {
                mutableStatus[user.entityID] = @{bStatus: @(bMessageReadStatusNone), bDate: BChatSDK.core.now};
            }
        }
        [self setReadStatus:mutableStatus];
    }
}

-(void) setReadReceiptsTo: (bMessageReadStatus) status {
    // Setup the initial read receipts
    NSMutableDictionary * messageStatus = [NSMutableDictionary dictionaryWithDictionary:self.readStatus];
    for (NSString * key in messageStatus.allKeys) {
        messageStatus[key] = @{bStatus: @(status), bDate: BChatSDK.core.now};
    }
    [self setReadStatus:messageStatus];
}
@end
