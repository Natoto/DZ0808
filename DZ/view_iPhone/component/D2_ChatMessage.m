//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Nonato on 13-12-3.
//  Copyright (c) 2013年 Nonato. All rights reserved.
//

#import "D2_ChatMessage.h"
#import "allpm.h"
#import "UserModel.h"
#import "ToolsFunc.h"
#import "bee.h"
@implementation D2_ChatMessage

- (void)setDict:(friendms *)mydict{
    
    _dict =mydict;
    NSDictionary *dict= [mydict objectToDictionary];
    //dict;    
    self.icon = [NSString stringWithFormat:@"%@",[dict valueForKeyPath:@"avatar"]];
    self.time =[ToolsFunc datefromstring:[NSString stringWithFormat:@"%@",[dict valueForKeyPath:@"dateline"]]];
    self.content =[NSString stringWithFormat:@"%@",[dict valueForKeyPath:@"message"]];
    NSString *selfuid=[UserModel sharedInstance].session.uid;
    self.type = [[NSString stringWithFormat:@"%@",[dict valueForKeyPath:@"touid"]] isEqual:selfuid]?0:1;
}

@end
