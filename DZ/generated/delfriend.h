//
//  delfriend.h
//  DZ
//
//  Created by Nonato on 14-6-18.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"
@interface DELFRIEND : BeeActiveObject
@property (nonatomic, retain) NSString *		ecode;
@property (nonatomic, retain) NSString *		emsg;
@end

@interface API_DELFRIEND_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   uid;
@property (nonatomic, retain) NSString              *   frdid;
@property (nonatomic, retain) DELFRIEND             *   resp;
@end