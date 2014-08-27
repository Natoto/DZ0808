//
//  DZ_Device_Statistics.m
//  DZ
//
//  Created by Nonato on 14-7-28.
//
//

#import "OpenUDID.h"
#import "DZ_Device_Statistics.h"
#import "DZ_UIDevice_IOKit_Extensions.h"
@interface DZ_Device_Statistics()

@end
@implementation DZ_Device_Statistics

-(NSString *)udid
{
//udid
//    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
    return [OpenUDID value];; 
}
//imei
- (NSString *) imeis
{
    
//     * device =[[DZ_Device_Statistics alloc] init];
   
    NSString * serialnumber = [UIDevice currentDevice].serialnumber;
    NSString * backlightlevel  = [UIDevice currentDevice].backlightlevel;
    return  [[UIDevice currentDevice] imei];
//    NSArray *results = getValue(@"device-imei");
//    
//    if (results)
//        
//    {
//        //return [results objectAtIndex:0];
//        NSString *string_content = [results objectAtIndex:0];
//        
//        const char *char_content = [string_content UTF8String];
//        
//        return  [[NSString alloc] initWithCString:(const char*)char_content  encoding:NSUTF8StringEncoding];
//    }
//    return nil;
}

-(void)test
{
    NSString *ims =[self imeis];
    NSString * udid = [self udid];
    
}

@end
