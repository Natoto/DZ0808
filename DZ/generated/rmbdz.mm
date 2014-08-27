 

#import "rmbdz.h"

//@implementation HOMEMY
//@synthesize count=_count;
//@synthesize subject=_subject;
//@synthesize message=_message;
//@end
//
//@implementation HOMENEWEST
//@synthesize count=_count;
//@synthesize subject=_subject;
//@synthesize title=_title;
//@end
//
//@implementation  HOMEPAGE
//@synthesize my=_my;
//@synthesize topics=_topics;
//@synthesize newest=_newest;
//@end
//

@implementation STATUS
@synthesize ecode=_ecode;
@synthesize emsg=_emsg;


+(NSString *)errmessage:(ERROR_CODE)error_code
{
    NSString *message = nil;
    switch (error_code) {
        case ERR_ADDFRIEND:
            message = @"添加失败";
            break;
        case ERR_LOGIN:
            message = @"登录失败";
            break;
        case ERR_RIG:
            message = @"注册失败";
            break;
        case ERR_FRESHERROR:
            message = @"刷新失败";
            break;
        case ERR_MSGSENDERROR:
            message = @"消息发送失败";
            break;
        default:
            message = @"失败";
            break;
    }
    return message;
}
@end

#pragma mark - config

@implementation ServerConfig

@synthesize url = _url;
@synthesize idowebsiteurl = _idowebsiteurl;
@synthesize feedbackUrl     = _feedbackUrl;
@synthesize aboutUsLeftArray    = _aboutUsLeftArray;
@synthesize aboutUsRightArray   = _aboutUsRightArray;
@synthesize idologurl = _idologurl;
DEF_SINGLETON( ServerConfig )
-(id)init
{
    self = [super init];
    if (self) {
        //获取系统当前的时间戳
        NSTimeZone *zone = [NSTimeZone defaultTimeZone];//获得当前应用程序默认的时区
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//以秒为单位返回当前应用程序与世界标准时间（格林威尼时间）的时差
        NSDate *localeDate = [[NSDate date] dateByAddingTimeInterval:interval];
        NSTimeInterval timeInterval2 = [localeDate timeIntervalSince1970];
        NSString * tokenid =@"654321";
        NSString * dztoapp = @"dztoapp";
        NSString * tokenkey =[NSString stringWithFormat:@"%@%d%@",tokenid,(NSInteger)timeInterval2,dztoapp];
        tokenkey=[tokenkey MD5].lowercaseString;
        
        NSString *tokenstr =[NSString stringWithFormat:@"tokenid=%@&time=%d&tokenkey=%@",tokenid,(NSInteger)timeInterval2,tokenkey];
        tokenstr = [tokenstr MD5].lowercaseString;
        
        NSString * urlkey =[NSString stringWithFormat:@"&ostype=2&time=%d&tokenid=%@&token=%@",(NSInteger)timeInterval2,tokenid,tokenstr.URLEncoding];
        
        _urlpostfix = urlkey;
        
        NSLog(@"%@",_urlpostfix);
        
    }
    return self;
}

@end
 
