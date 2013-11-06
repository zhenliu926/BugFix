//
//  NotificationsModel.h
//  WutzWhat
//
//  Created by Rafay on 11/26/12.
//
//

#import <Foundation/Foundation.h>

@interface NotificationsModel : NSObject

@property (nonatomic,retain) NSString *thumbnailUrl;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *dateTime;
@property (nonatomic,assign) NSInteger notificationID;
@property (nonatomic,retain) NSString *notificationType;
@property (nonatomic,retain) NSString *notificationTypeID;

@end
