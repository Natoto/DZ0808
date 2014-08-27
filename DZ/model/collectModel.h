//
//  collectModel.h
//  DZ
//
//  Created by PFei_He on 14-6-24.
//
//

#import "Bee_StreamViewModel.h"

@interface collectModel : BeeStreamViewModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, strong) NSNumber *favid;

- (void)collect;

@end
