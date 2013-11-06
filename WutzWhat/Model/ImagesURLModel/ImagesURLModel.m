//
//  ImagesURLModel.m
//  WutzWhat
//
//  Created by iPhone Development on 4/25/13.
//
//

#import "ImagesURLModel.h"
#import <AVFoundation/AVFoundation.h>

@implementation ImagesURLModel

@synthesize imageID = _imageID;
@synthesize imageURL = _imageURL;
@synthesize largeImageURL = _largeImageURL;
@synthesize smallImageURL = _smallImageURL;
@synthesize mediumImageURL = _mediumImageURL;
@synthesize thumbnailImageURL = _thumbnailImageURL;
@synthesize videoURL = _videoURL;
@synthesize thumbnailVideoURL = _thumbnailVideoURL;
@synthesize isVideoURL = _isVideoURL;

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.imageID = [[dict objectForKey:@"id"] intValue];
    
    self.imageURL = [CommonFunctions isValueExist:[dict objectForKey:@"url"]] ? [dict objectForKey:@"url"] : @"";
    self.largeImageURL = [CommonFunctions isValueExist:[dict objectForKey:@"url_large"]] ? [dict objectForKey:@"url_large"] : @"";
    self.mediumImageURL = [CommonFunctions isValueExist:[dict objectForKey:@"url_medium"]] ? [dict objectForKey:@"url_medium"] : @"";
    self.smallImageURL = [CommonFunctions isValueExist:[dict objectForKey:@"url_small"]] ? [dict objectForKey:@"url_small"] : @"";
    self.thumbnailImageURL = [CommonFunctions isValueExist:[dict objectForKey:@"url_thumbnail"]] ? [dict objectForKey:@"url_thumbnail"] : @"";

    self.thumbnailVideoURL = [CommonFunctions isValueExist:[dict objectForKey:@"url_video_thumb"]] ? [dict objectForKey:@"url_video_thumb"] : @"";
    self.videoURL = [CommonFunctions isValueExist:[dict objectForKey:@"url_video"]] ? [dict objectForKey:@"url_video"] : @"";
    self.isVideoURL = ![self.videoURL isEqualToString:@""];
    
    return self;
}

+(NSArray *)parseImagesURL:(NSArray *)imagesURLArray
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in imagesURLArray)
    {
        ImagesURLModel *model = [[ImagesURLModel alloc] initWithDictionary:dict];
        
        if ([ImagesURLModel checkAnyOfURLExists:model])
        {
           [modelArray addObject:model];            
        }
    }
    
    return modelArray;
}

+(BOOL)checkAnyOfURLExists:(ImagesURLModel *)model
{
    if ([model.smallImageURL isEqualToString:@""] && [model.largeImageURL isEqualToString:@""] && [model.mediumImageURL isEqualToString:@""]
        && [model.imageURL isEqualToString:@""] && [model.thumbnailImageURL isEqualToString:@""] && [model.thumbnailVideoURL isEqualToString:@""] && [model.videoURL isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(NSArray *)getSmallImagesArray:(NSArray *)imagesModelArray
{
    NSMutableArray *smallImagesArray = [[NSMutableArray alloc] init];
    
    for (ImagesURLModel *model in imagesModelArray)
    {
        if (![model.smallImageURL isEqualToString:@""])
        {
            [smallImagesArray addObject:[NSURL URLWithString:model.smallImageURL]];            
        }
        else if (![model.videoURL isEqualToString:@""])
        {
            if (![model.thumbnailVideoURL isEqualToString:@""])
            {
                [smallImagesArray insertObject:[ImagesURLModel createImageFromVideoURL:model.videoURL andSave:TRUE] atIndex:0];
            }
            else
            {
                [smallImagesArray insertObject:[ImagesURLModel createImageFromVideoURL:model.videoURL andSave:TRUE] atIndex:0];
            }
        }
    }
    
    return smallImagesArray;
}


+(NSArray *)getMediumImagesArray:(NSArray *)imagesModelArray
{
    NSMutableArray *mediumImagesArray = [[NSMutableArray alloc] init];
    
    for (ImagesURLModel *model in imagesModelArray)
    {
        if (![model.mediumImageURL isEqualToString:@""])
        {
            [mediumImagesArray addObject:model.mediumImageURL];
        }
    }
    
    return mediumImagesArray;
}


+(NSString *)getThumbnailImageURL:(NSArray *)imagesModelArray
{
    NSString *thumbnailImageURL = @"";
    
    for (ImagesURLModel *model in imagesModelArray)
    {
        if (![model.thumbnailImageURL isEqualToString:@""])
        {
            thumbnailImageURL = model.thumbnailImageURL;
            break;
        }
    }
    
    return thumbnailImageURL;
}

+(NSMutableArray *)getMediumImagesArrayForSlidShow:(NSArray *)imagesModelArray
{
    NSMutableArray *mediumImagesArray = [[NSMutableArray alloc] init];
    
    for (ImagesURLModel *model in imagesModelArray)
    {
        if (![model.mediumImageURL isEqualToString:@""])
        {
            [mediumImagesArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:model.mediumImageURL]]];
        }
        else if (![model.videoURL isEqualToString:@""])
        {
            if (![model.thumbnailVideoURL isEqualToString:@""])
            {
                
                MWPhoto *photo = [[MWPhoto alloc] initWithImage:[ImagesURLModel createImageFromVideoURL:model.videoURL andSave:true]];
                
                photo.isVideo = YES;
                photo.videoURL = [NSURL URLWithString:model.videoURL];
                
                [mediumImagesArray insertObject:photo atIndex:0];
            }
            else
            {
                MWPhoto *photo = [[MWPhoto alloc] initWithImage:[ImagesURLModel createImageFromVideoURL:model.videoURL andSave:true]];
                
                photo.isVideo = YES;
                photo.videoURL = [NSURL URLWithString:model.videoURL];
                
                [mediumImagesArray insertObject:photo atIndex:0];
            }
        }
    }
    
    return mediumImagesArray;
}


+ (id)createImageFromVideoURL:(NSString *)url andSave:(BOOL)save
{
    UIImage *thumb = nil;
    
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url ] options:nil];
    
    AVAssetImageGenerator *imageGen = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGen.appliesPreferredTrackTransform = YES;
//    __autoreleasing NSError *error = nil;
//    CMTime actualTime;
    
    [imageGen setRequestedTimeToleranceAfter:kCMTimeZero];
    [imageGen setRequestedTimeToleranceBefore:kCMTimeZero];
    
    CMTime time = CMTimeMakeWithSeconds(10, 600);
    
//    thumb = [UIImage imageWithCGImage:[imageGen copyCGImageAtTime:time actualTime:&actualTime error:&error]];
    
//    NSLog(@"Error: %@",error);
    __block int count = 0;
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        
        if(!error && count < 1)
        {
            count++;
            UIImage *thumb = [UIImage imageWithCGImage:im];
            
            Util *u = [Util new];
            thumb = [u cropCenterAndResizeImageWithImage:thumb cropWidth:thumb.size.width cropHeight:thumb.size.height resizeWidth:640 resizeHeight:500];
            
            UIImage *playButton = [UIImage imageNamed:@"video_thumbnail_playButton.png"];
            
            UIGraphicsBeginImageContext(CGSizeMake(thumb.size.width, thumb.size.height - 20));
            
            [thumb drawAtPoint:CGPointMake(0, 0)];
            [playButton drawAtPoint:CGPointMake((thumb.size.width - playButton.size.width) / 2, (thumb.size.height - playButton.size.height) / 2)];
            
            thumb = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"retreivedVideoImage" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:thumb, @"image",url,@"url",nil]];
            });
        }

        
    };
    
    [imageGen generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:time]] completionHandler:handler];
    
    thumb = [UIImage imageNamed:@"video_thumbnail_blank.png"];
    
    UIGraphicsBeginImageContext(CGSizeMake(thumb.size.width, thumb.size.height - 20));
    
    [thumb drawAtPoint:CGPointMake(0, 0)];
    
    thumb = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return (UIImage *)thumb;
}

+(NSString *)getThumbnailVideoURL:(NSArray *)modelArray
{
    NSString *urlString = @"";
    
    for (ImagesURLModel *model in modelArray)
    {
        if (![model.videoURL isEqualToString:@""])
        {
            if (![model.thumbnailVideoURL isEqualToString:@""])
            {
                urlString = model.thumbnailVideoURL;
            }
            else
            {
                for (ImagesURLModel *imagesModel in modelArray)
                {
                    if (![imagesModel.smallImageURL isEqualToString:@""])
                    {
                        urlString = imagesModel.smallImageURL;
                    }
                }
            }
        }
    }
    
    return urlString;
}

+(NSURL *)getVideoURL:(NSArray *)modelArray
{
    NSURL *videoURL = [[NSURL alloc] init];
    
    for (ImagesURLModel *model in modelArray)
    {
        if (![model.videoURL isEqualToString:@""])
        {
            videoURL = [NSURL URLWithString:model.videoURL];
        }
    }
    
    return videoURL;
}

@end
