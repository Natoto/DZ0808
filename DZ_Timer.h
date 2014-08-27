//
//  DZ_Timer.h
//  DZ
//
//  Created by Nonato on 14-7-8.
//
//

#import <Foundation/Foundation.h>
#import "Bee.h"
#define REFRESHINTERVAL 15.0
@class DZ_Timer;
@protocol DZ_TimerDelegate <NSObject>
-(void)refreshMessage:(DZ_Timer *)dztimer;
@end

@interface DZ_Timer : NSObject
{
    NSInteger refreshmsgcount;
    NSTimer * DZ_RefreshmsgTime;
    NSTimer * DZ_PublicTime;
    NSTimer * DZ_ReplyTime;
}
AS_SINGLETON(DZ_Timer)
@property(nonatomic,assign)NSObject<DZ_TimerDelegate> * delegate;
@property(nonatomic,assign)NSInteger publishcount;
@property(nonatomic,assign)NSInteger replycount;

-(void)endReply;
-(void)endPush;

-(void)endRefresh;//开始再次刷新
-(void)invalidateDZ_RefreshmsgTime;

@end
