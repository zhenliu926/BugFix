//
//  FileCacher.m
//  iceapptest
//
//  Created by Yunas Qazi on 12/26/11.
//  Copyright (c) 2011 Style360. All rights reserved.
//

#import "FileCacher.h"

static FileCacher *singletonInstance; 
@implementation FileCacher

- (id) init {
    if (self = [super init]) {
	}
    return self;
}





+ (FileCacher*)instance{
    if(!singletonInstance)
        singletonInstance=[[FileCacher alloc]init];
    return singletonInstance;
}


+(NSString *) getFileNameFromUrlString :(NSString *) urlString
{
	
	//	NSString *url = @"http://www.google.com/a.pdf";
	NSArray *parts = [urlString componentsSeparatedByString:@"/"];
	return [parts objectAtIndex:[parts count]-1];
	//	NSString *filename = [parts objectAtIndex:[parts count]-1];
}



//================================= Start =======================================\\
//============================== Create Image =====================================\\
//===================================================================================\\

#pragma mark - Create Image

- (NSString *) getFileLocalPath :(NSString *) photoPath {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:photoPath];
}

-(BOOL) doesFileExists :(NSString *)imageName{
	NSString *filePath = [self getFileLocalPath:imageName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ( ![ fileManager fileExistsAtPath: filePath ] )
	{
		//		NSLog( @"File doesn't exist." );
		return FALSE;
	}
	
	return TRUE;
	
}


-(BOOL) createImage:(NSData*)imageData withImageName:(NSString*)imageName
{
	NSString *defaultDBPath = [self getFileLocalPath:imageName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//	NSLog(@"defaultDBPath %@",defaultDBPath);
	if ([self doesFileExists:imageName]) 
	{
		return YES;
	}
	
	BOOL success;
	success = [fileManager createFileAtPath:defaultDBPath contents:imageData attributes:nil];
	return success;
	
}





//=============================== Start =========================================\\
//========================== Image Management =====================================\\
//===================================================================================\\

#pragma mark - Image Requistion

+(UIImage *) getImageFromLocal:(NSString *)imageName
{

	UIImage * image = nil; 
	if ([imageName isEqualToString:@""]) {
		image = [UIImage imageNamed:@"noImage.png"];
	}else if ([singletonInstance doesFileExists:imageName]) // locally found no need to download
	{
		image = [[UIImage alloc]initWithContentsOfFile:[singletonInstance getFileLocalPath:imageName]];
	}
	return image;
}


//=============================== End ===========================================\\
//=========================== Image Management ====================================\\
//===================================================================================\\

@end
