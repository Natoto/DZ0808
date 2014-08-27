//
//  delcollectionModel.h
//  DZ
//
//  Created by PFei_He on 14-7-3.
//
//

#import <Foundation/Foundation.h>
#import "Bee_StreamViewModel.h"

@interface delcollectionModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) NSNumber *favid;

- (void)delcollection;

@end
