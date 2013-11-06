//
//  PostCheckinRequestResult.h
//  WutzWhat
//
//  Created by Rafay on 1/23/13.
//
//

#import <Foundation/Foundation.h>


@protocol PostCheckinRequestDelegate;
@interface PostCheckinRequestResult : NSObject {
    id _postCheckinRequestDelegate;
}
- (id) initWithDelegate: (id)delegate;
@end
@protocol PostCheckinRequestDelegate
- (void) postCheckinRequestCompleted;
- (void) postCheckinRequestFailed;
@end