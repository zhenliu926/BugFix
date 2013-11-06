//
//  FileCacher.h
//  iceapptest
//
//  Created by Yunas Qazi on 12/26/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileCacher : NSObject

-(BOOL) doesFileExists :(NSString *)imageName;
-(BOOL) createImage:(NSData*)imageData withImageName:(NSString*)imageName;
+(UIImage *) getImageFromLocal:(NSString *)imageName;
+(NSString *) getFileNameFromUrlString :(NSString *) urlString;
+ (FileCacher*)instance;

@end
