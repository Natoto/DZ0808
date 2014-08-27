//
//  DistrictsModel.m
//  DZ
//
//  Created by Nonato on 14-5-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "DistrictsModel.h"
#define DISTRICTSDATABASEKEY @"DistrictDatabaseKey"
@implementation DistrictsModel
@synthesize shots=_shots;

- (void)load
{
	self.autoSave = YES;
	self.autoLoad = YES;
	self.shots = [NSMutableArray array];
}

- (void)unload
{
	self.shots = nil;
}

#pragma mark -

- (void)loadCache
{
	[self.shots removeAllObjects];
    self.shots=[NSMutableArray arrayWithArray:[districts readObjectForKey:DISTRICTSDATABASEKEY]];
//    [self.shots addUniqueObjectsFromArray:[districts readObjectForKey:DISTRICTSDATABASEKEY]
//                                  compare:^NSComparisonResult(id left, id right) {
//                                      return [((districts *)left).id compare:((districts *)right).id];
//                                  }];
}

- (void)saveCache
{
    [districts saveObject:self.shots forKey:DISTRICTSDATABASEKEY];
}

- (void)clearCache
{
    [districts removeObjectForKey:DISTRICTSDATABASEKEY];
	[self.shots removeAllObjects];
    self.loaded=NO;
}

-(int)proviceIndexForname:(NSString *)provicename
{
    districts *mydistrcts=[[districts alloc] init];
    int myproviceIndex=NSNotFound;
    for (int index=0;index<self.shots.count;index++) {
        districts *dis = [self.shots objectAtIndex:index];
        if ([dis.name isEqualToString:provicename]) {
            myproviceIndex=index;
            mydistrcts=dis;
            break;
        }
    }
    return myproviceIndex;
}


-(int)proviceIndexForid:(NSString *)proviceid
{
    districts *mydistrcts=[[districts alloc] init];
    int myproviceIndex=NSNotFound;
    for (int index=0;index<self.shots.count;index++) {
        districts *dis = [self.shots objectAtIndex:index];
        if ([dis.id isEqualToString:proviceid]) {
            mydistrcts=dis;
            myproviceIndex=index;
            break;
        }
    }
    return myproviceIndex;
}

-(int)CityIndexForProvicename:(NSString *)provicename andChildname:(NSString *)cityname
{
    dis_child *obj=[[dis_child alloc] init];
    int myCityIndex=NSNotFound;
    for (int index=0;index<self.shots.count;index++) {
        districts *dis = [self.shots objectAtIndex:index];
        if ([dis.name isEqualToString:provicename]) {
            for (int childIndex=0;childIndex<dis.child.count;childIndex++) {
                dis_child *tempchild = [dis.child objectAtIndex:childIndex];
                if ([tempchild.name isEqualToString:cityname]) {
                    obj=tempchild;
                    myCityIndex=childIndex;
                    break;
                }
            }
        }
    }
    return myCityIndex;
}

-(int)CityIndexForProviceid:(NSString *)proviceid andChildId:(NSString *)cityid
{
    dis_child *obj=[[dis_child alloc] init];
    int myCityIndex=NSNotFound;
    for (int index=0;index<self.shots.count;index++) {
        districts *dis = [self.shots objectAtIndex:index];
        if ([dis.id isEqualToString:proviceid]) {
            for (int childIndex=0;childIndex<dis.child.count;childIndex++) {
                dis_child *tempchild = [dis.child objectAtIndex:childIndex];
                if ([tempchild.id isEqualToString:cityid]) {
                    obj=tempchild;
                    myCityIndex=childIndex;
                    break;
                }
            }            
        }
    }
    return myCityIndex;
}



#pragma mark -

- (void)firstPage
{
	[self gotoPage:1];
}

- (void)nextPage
{
	if ( self.shots.count )
	{
		[self gotoPage:(1)];
	}
}

- (void)gotoPage:(NSUInteger)page
{
    [API_DISTRICTS_SHOTS cancel];
    
	API_DISTRICTS_SHOTS * api = [API_DISTRICTS_SHOTS api];
	
	@weakify(api);
	@weakify(self);
    
	
	api.whenUpdate = ^
	{
		@normalize(api);
		@normalize(self);
        
		if ( api.sending )
		{
			[self sendUISignal:self.RELOADING];
		}
		else
		{
			if ( api.succeed )
			{
				if ( nil == api.resp)
				{
					api.failed = YES;
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
				}
				else
				{
                    [self.shots removeAllObjects];
                    [self.shots addObjectsFromArray:api.resp.districts];
					self.more = NO;
					self.loaded = YES;
					[self saveCache];
                    [self sendUISignal:self.RELOADED];
				}
			}
            else
            {
                    [self sendUISignal:self.FAILED withObject:api.resp.emsg];
            }
		}
	};
	
	[api send];
}

@end
