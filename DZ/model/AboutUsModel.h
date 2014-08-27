//
//  AboutUsModel.h
//  DZ
//
//  Created by PFei_He on 14-6-23.
//
//

#import <Foundation/Foundation.h>
#import "AboutUs.h"

@interface AboutUsModel : BeeStreamViewModel

AS_SIGNAL(ABOUTUS)

- (void)aboutUs;

@end
