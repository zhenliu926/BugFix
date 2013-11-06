//
//  Util.m
//  WutzWhat
//
//  Created by Henrique Valadares on 2013-06-21.
//
//

#import "Util.h"

@implementation Util : NSObject;

-(UIImage*)cropCenterAndResizeImage:(NSString*)imageUrl cropWidth:(float)widthCrop cropHeight:(float)heightCrop resizeWidth:(float)widthResize resizeHeight:(float)heightHeight
{
    //create the image from a URL
    NSURL *imageURL = [NSURL URLWithString:imageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    //crop the image
    CGRect cgrectCroppedPerk = CGRectMake(image.size.width/2 - widthCrop/2, image.size.height/2 - heightCrop/2, widthCrop, heightCrop);
    CGSize cgsizeResizePerk = CGSizeMake(widthResize, heightHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cgrectCroppedPerk);
    UIImage *imageCropped = [UIImage imageWithCGImage:imageRef];
    
    //Resize the image
    UIGraphicsBeginImageContextWithOptions(cgsizeResizePerk , NO, 0.0);
    [imageCropped drawInRect:CGRectMake(0, 0, widthResize, heightHeight)];
    UIImage *imageCroppedAndResized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCroppedAndResized;
}

-(UIImage*)cropCenterAndResizeImageWithImage:(UIImage *)image cropWidth:(float)widthCrop cropHeight:(float)heightCrop resizeWidth:(float)widthResize resizeHeight:(float)heightHeight
{
    //crop the image
    CGRect cgrectCroppedPerk = CGRectMake(image.size.width/2 - widthCrop/2, image.size.height/2 - heightCrop/2, widthCrop, heightCrop);
    CGSize cgsizeResizePerk = CGSizeMake(widthResize, heightHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cgrectCroppedPerk);
    UIImage *imageCropped = [UIImage imageWithCGImage:imageRef];
    
    //Resize the image
    UIGraphicsBeginImageContextWithOptions(cgsizeResizePerk , NO, 0.0);
    [imageCropped drawInRect:CGRectMake(0, 0, widthResize, heightHeight)];
    UIImage *imageCroppedAndResized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCroppedAndResized;
}

-(NSString*)findFirstUrlImage:(NSArray*) images
{
    NSString *urlImageFirstImage = @"";
    for(int i = 0; i < [images count]; i++){
        if(![[images objectAtIndex:i] isKindOfClass:[NSNull class]] && [images objectAtIndex:i] != nil){
            if(![[[images objectAtIndex:i] objectForKey:@"banner_img"] isKindOfClass:[NSNull class]]){
                return urlImageFirstImage = [[images objectAtIndex:i] objectForKey:@"banner_img"];
            }
        }
    }
    return urlImageFirstImage;
}

@end
