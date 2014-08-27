//
//  ChineseString.h
//  DZ
//
//  Created by PFei_He on 14-7-15.
//
//

#import <Foundation/Foundation.h>

@interface ChineseString : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic, copy) NSString *pinyin;
@property (nonatomic, strong) NSMutableArray *array;

@end
