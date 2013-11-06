//
//  FileIOManager.h
//  Prototype
//
//  Created by Apple Development on 11/26/12.
//  Copyright (c) 2012 DevBatch (PVT) LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileIOManager : NSObject

+(BOOL)writeTextToFileAtPath:(NSString *)fileName stringToWrite:(NSString *)stringToWrite;

+(NSString *)readTextFileAtPath:(NSString *)fileName;

+(NSData *)getFileOnPath:(NSString *)fileName;

+(BOOL)saveFileOnPath:(NSString *)fileName filePath:(NSString *)filePath fileData:(NSData *)dataToSave;

+(BOOL)isFileExist:(NSString *)fileName;

+(NSString *)getDocumentDirectoryPath;

+(BOOL)deleteFileByFileName:(NSString *)fileName;

@end
