//
//  GoogleAddressAPI.h
//  WutzWhat
//
//  Created by iPhone Development on 3/21/13.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "GoogleLocationAPIModel.h"

@protocol GoogleAddressAPIDelegate <NSObject>

-(void)didFindAddress:(NSArray *)addressArray;
-(void)failToFindAddress;

@end

@interface GoogleAddressAPI : NSObject
{
    __strong ASIHTTPRequest *request;
}
@property (assign, nonatomic) id <GoogleAddressAPIDelegate> delegate;

-(void)getGoogleAddressSuggestion:(NSString *)userEnterdAddress;

@end
