//
//  CommentModel.h
//  WutzWhat
//
//  Created by Rafay on 11/19/12.
//
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic,retain) NSString  *username;
@property (nonatomic,retain) NSString *comment;
@property (nonatomic,retain) NSString *uploadedTime;
@end
