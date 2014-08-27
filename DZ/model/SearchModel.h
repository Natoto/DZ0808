//
//  SearchModel.h
//  DZ
//
//  Created by PFei_He on 14-6-19.
//
//

#import <Foundation/Foundation.h>
#import "search.h"

@interface SearchModel : BeeStreamViewModel

//AS_SIGNAL(SEARCH_RELOADED)
//AS_SIGNAL(SEARCH_FAILED)
//AS_SIGNAL(SEARCH_LOADING)

@property (nonatomic, copy)     NSString            *uid;
@property (nonatomic, copy)     NSString            *kw;
@property (nonatomic, copy)     NSString            *tid;
@property (nonatomic, copy)     NSString            *fid;
@property (nonatomic, strong)   NSMutableArray      *shots;

- (void)firstPage;

- (void)nextPage;

- (void)gotoPage:(NSUInteger)page;

/**
 * @brief 判断是否已登录
 */
//+ (BOOL)online;

/**
 * @brief 传入uid进行搜索
 * @param kw: 搜索关键字
 */
//- (void)searchWithUid:(NSString *)uid kw:(NSString *)kw;

@end
