//
//  DistrictsModel.h
//  DZ
//
//  Created by Nonato on 14-5-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "Bee_StreamViewModel.h"
#import "Bee.h"
#import "districts.h"
@interface DistrictsModel : BeeStreamViewModel
@property(nonatomic,strong)NSMutableArray *shots;

-(int)proviceIndexForname:(NSString *)provicename;
-(int)proviceIndexForid:(NSString *)proviceid;
-(int)CityIndexForProvicename:(NSString *)provicename andChildname:(NSString *)cityname;
-(int)CityIndexForProviceid:(NSString *)proviceid andChildId:(NSString *)cityid;
@end
