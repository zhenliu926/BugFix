#import <Foundation/Foundation.h>


typedef void (^completeBlock_t)(NSData *data);
typedef void (^errorBlock_t)(NSError *error);

@interface AsyncURLConnection : NSURLConnection 
{
	NSMutableData *data_;
	completeBlock_t completeBlock_;
	errorBlock_t errorBlock_;
}


+ (id)request:(NSURL *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithRequest:(NSURL *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

@end