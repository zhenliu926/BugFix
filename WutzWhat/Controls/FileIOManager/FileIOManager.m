//
//  FileIOManager.m
//  Prototype
//
//  Created by Apple Development on 11/26/12.
//  Copyright (c) 2012 DevBatch (PVT) LTD. All rights reserved.
//

#import "FileIOManager.h"

@implementation FileIOManager

+(BOOL)writeTextToFileAtPath:(NSString *)fileName stringToWrite:(NSString *)stringToWrite
{
    NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
    
    NSString *textPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;

    [stringToWrite writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error != nil) 
    {
        NSLog(@"There was an error in creating a file : %@", [error description]);
        return NO;
    }
    else
    {
        return YES;
    }
}

+(NSString *)readTextFileAtPath:(NSString *)fileName
{
    if ([FileIOManager isFileExist:fileName])
    {
        NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
        
        NSString *textPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        NSError *error = nil;
        
        NSString *str = [NSString stringWithContentsOfFile:textPath encoding:NSUTF8StringEncoding error:&error];
        
        if (error != nil)
        {
            NSLog(@"There was an error: %@", [error description]);
            return nil;
        }
        else
        {
            return str;
        }        
    }
    else
    {
        return nil;
    }
}

+(NSData *)getFileOnPath:(NSString *)fileName
{
    if ([FileIOManager isFileExist:fileName])
    {
        NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
        
        NSString *textPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        NSError *error = nil;
        
        NSData *fileData = [NSData dataWithContentsOfFile:textPath options:NSDataReadingMappedIfSafe error:&error];
        
        if (error != nil)
        {
            NSLog(@"There was an error: %@", [error description]);
            return nil;
        }
        else
        {
            return fileData;
        }
    }
    else
    {
        return nil;
    }
}


+(BOOL)saveFileOnPath:(NSString *)fileName filePath:(NSString *)filePath fileData:(NSData *)dataToSave
{
    if (![self isFileExist:filePath])
    {
        [self createDirectoryInsideDocumentFolder:filePath];
    }
    
    NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
    
    NSString *textPath = [[documentsDirectory stringByAppendingPathComponent:filePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
    
    NSError *error = nil;
    
    [dataToSave writeToFile:textPath options:NSDataWritingFileProtectionNone error:&error];
    
    if (error != nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }    
}


+(BOOL)deleteFileByFileName:(NSString *)fileName
{
    NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
    
    return [FileIOManager deleteFileAtPath:documentsDirectory filePath:fileName];
}


+(BOOL)deleteFileAtPath:(NSString *)fileName filePath:(NSString *)filePath
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@",filePath,fileName];
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:fullPath] )
    {
        return YES;
    }
    else 
    {
        return [fileManager removeItemAtPath:fullPath error:NULL];    
    }
}

+(BOOL)isFileExist:(NSString *)fileName
{
    NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
    
    NSString *textPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:textPath]) 
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}


+(BOOL)createDirectoryAtPath:(NSString *)path
{
    NSError *error = nil;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:NO
                                               attributes:nil
                                                    error:&error];
    if (error != nil)
    {
        NSLog(@"There was an error in creating a folder : %@", [error description]);
        return NO;
    }
    else
    {
        return YES;
    }    
}


+(BOOL)createDirectoryInsideDocumentFolder:(NSString *)newDirectoryName
{
    NSString *documentsDirectory = [FileIOManager getDocumentDirectoryPath];
    
    return [self createDirectoryAtPath:[documentsDirectory stringByAppendingPathComponent:newDirectoryName]];
}


+(NSString *)getDocumentDirectoryPath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [pathArray objectAtIndex:0];
}

@end
