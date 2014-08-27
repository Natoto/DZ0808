//
// ECMobile (Geek-Zoo Studio)
//
// generated at 2013-06-17 05:47:47 +0000
//
#import "DZ_SystemSetting.h"
#import "Bee.h"
#import <Foundation/Foundation.h>
#import "NSData+base64.h" 


typedef enum : NSUInteger {
    ERR_LOGIN,
    ERR_RIG,
    ERR_ADDFRIEND,
    ERR_FRESHERROR,
    ERR_MSGSENDERROR,
} ERROR_CODE;

@interface STATUS : NSObject
@property (nonatomic, retain) NSString *		ecode;
@property (nonatomic, retain) NSString *		emsg;
+(NSString *)errmessage:(ERROR_CODE)error_code;
@end

#pragma mark - config

@interface ServerConfig : NSObject

AS_SINGLETON( ServerConfig )

@property (nonatomic, retain) NSString          *	url;
@property (nonatomic, retain) NSString          *	idowebsiteurl;
@property (nonatomic, retain) NSString          *	idologurl;
@property (nonatomic, copy)   NSString          *   feedbackUrl;
@property (nonatomic, strong) NSMutableArray    *   aboutUsLeftArray;
@property (nonatomic, strong) NSMutableArray    *   aboutUsRightArray;
@property (nonatomic, strong) NSString          *   urlpostfix;

@end

