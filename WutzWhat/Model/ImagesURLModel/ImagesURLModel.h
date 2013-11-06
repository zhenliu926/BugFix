//
//  ImagesURLModel.h
//  WutzWhat
//
//  Created by iPhone Development on 4/25/13.
//
//

#import <Foundation/Foundation.h>
#import "MWPhoto.h"
#import "Util.h"

@interface ImagesURLModel : NSObject

@property (nonatomic, assign) int imageID;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *largeImageURL;
@property (nonatomic, strong) NSString *smallImageURL;
@property (nonatomic, strong) NSString *mediumImageURL;
@property (nonatomic, strong) NSString *thumbnailImageURL;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) NSString *thumbnailVideoURL;
@property (nonatomic, assign) BOOL isVideoURL;

-(id)initWithDictionary:(NSDictionary *)dict;

+(NSMutableArray *)parseImagesURL:(NSArray *)imagesURLArray;

+(NSMutableArray *)getSmallImagesArray:(NSArray *)imagesModelArray;
+(NSMutableArray *)getMediumImagesArray:(NSArray *)imagesModelArray;
+(NSString *)getThumbnailImageURL:(NSArray *)imagesModelArray;
+(NSMutableArray *)getMediumImagesArrayForSlidShow:(NSArray *)imagesModelArray;

+(NSString *)getThumbnailVideoURL:(NSArray *)modelArray;
+(NSURL *)getVideoURL:(NSArray *)modelArray;

@end