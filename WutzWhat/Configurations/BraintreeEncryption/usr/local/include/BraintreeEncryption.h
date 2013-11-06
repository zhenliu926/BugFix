#import <Foundation/Foundation.h>


@interface BraintreeEncryption : NSObject {
  NSString * publicKey;
  NSString * applicationTag;

}

- (id) initWithPublicKey: (NSString *) key;
- (NSString *) encryptData: (NSData *) data;
- (NSString *) encryptString: (NSString *) input;

@property(nonatomic, retain) NSString * publicKey;
@property(nonatomic, retain) NSString * applicationTag;

@end

