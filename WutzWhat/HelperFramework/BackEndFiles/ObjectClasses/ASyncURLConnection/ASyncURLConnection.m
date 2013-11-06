#import "AsyncURLConnection.h"
#import "ProcessingView.h"
@implementation AsyncURLConnection



+ (id)request:(NSURL *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
	return [[self alloc] initWithRequest:requestUrl
                           completeBlock:completeBlock errorBlock:errorBlock] ;
}

- (id)initWithRequest:(NSURL *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
	//ProcessingView *tv = [ProcessingView instance];
	//[tv showTintView];
   // NSLog(@"requestUrl=%@",requestUrl);
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];

	if ((self = [super
			initWithRequest:request delegate:self startImmediately:YES])) {
		data_ = [[NSMutableData alloc] init];

		completeBlock_ = [completeBlock copy];
		errorBlock_ = [errorBlock copy];
		
		[self start];
	}

	return self;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

	[data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	ProcessingView *tv = [ProcessingView instance];
	[tv hideTintView];

	completeBlock_(data_);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	ProcessingView *tv = [ProcessingView instance];
	[tv hideTintView];

	errorBlock_(error);
}

@end