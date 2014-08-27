//
//  NSAttributedString+PFCategory.h
//  DZ
//
//  Created by PFei_He on 14-7-3.
//
//

#import <Foundation/Foundation.h>

@interface NSAttributedString ()

@property (nonatomic, copy) NSString *attributedString;

@end

@interface NSAttributedString (PFCategory)

+ (NSAttributedString *)getAttributedString:(NSString *)string;

@end

@interface NSAttributedStringView : UIView

@end
