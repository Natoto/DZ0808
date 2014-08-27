//
//  addfriend.h
//  DZ
//
//  Created by Nonato on 14-6-18.
//
//
#import "Bee.h"
#import <Foundation/Foundation.h>
#import "rmbdz.h"
@interface ADDFRIEND : BeeActiveObject
@property (nonatomic, retain) NSString *		ecode;
@property (nonatomic, retain) NSString *		emsg;
@end

@interface API_ADDFRIEND_SHOTS : BeeAPI
@property (nonatomic, retain) NSString              *   uid;
@property (nonatomic, retain) NSString              *   frdid;
@property (nonatomic, retain) ADDFRIEND             *   resp;
@end