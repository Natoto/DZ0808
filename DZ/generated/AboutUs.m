//
//  AboutUs.m
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import "AboutUs.h"
#import "rmbdz.h"

@implementation AboutUs

- (BOOL)validate
{
    return YES;
}

@end

@implementation API_ABOUTUS_SHOTS

- (BOOL)validate
{
    return YES;
}

-(void)routine
{
    if (self.sending) {
//        NSString *requestURI = [NSString stringWithFormat:@"%@", [ServerConfig sharedInstance].aboutUsUrl];
//        self.HTTP_GET(requestURI);
    }
    else if (self.succeed)
    {
        NSObject *result = self.responseJSON;
        NSLog(@"%@", result);

        if (nil == self.resp || NO == [self.resp validate]) {
            self.failed = YES;
            return;
        }
    }
    else if (self.failed) {
        NSLog(@"self.descripting===%@", self.description);
    }
    else if (self.cancelled) {
        NSLog(@"self.description===%@", self.description);
    }
}

@end
