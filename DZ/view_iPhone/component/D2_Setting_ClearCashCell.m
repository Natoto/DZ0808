//
//  D2_Setting_ClearCash.m
//  DZ
//
//  Created by Nonato on 14-4-16.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//

#import "D2_Setting_ClearCashCell.h"
#import "bee.h"
@implementation D2_Setting_ClearCashCell
DEF_SIGNAL(WILLCLEARCASH)
DEF_SIGNAL(DIDCLEARCASH)
//获取缓存大小
//- (unsigned long long)fileSizeAtPath:(NSString*) filePath
//{
//     NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
//     return [[attr objectForKey:NSFileSize] unsignedLongLongValue];
//}
//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        BeeLog(@"NSUserName:%@",NSUserName());
        BeeLog(@"NSHomeDirectory %@",NSHomeDirectory());
        BeeLog(@"NSOpenStepRootDirectory %@",NSOpenStepRootDirectory());
        BeeLog(@"%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]);
        
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        NSLog(@"files :%d",[files count]);
        
        cashsize=[self folderSizeAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Library"]];
        rightlabel.text=[NSString stringWithFormat:@"%.2f MB",cashsize];
        self.leftlabel.text=@"清除缓存";
        self.leftlabel.font = [UIFont systemFontOfSize:15];
        self.leftlabel.textColor = [UIColor darkGrayColor];
        self.rightlabel.textColor = [UIColor darkGrayColor];
        lblcashSize=self.rightlabel;
        
 
    }
    return self;
}

-(void)clearCash
{
    [self sendUISignal:self.WILLCLEARCASH];
    [[BeeImageCache sharedInstance] deleteAllImages];
    [self clearCacheSuccess];
     /*dispatch_async(
                  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%d",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});*/
}

- (void)clearCacheSuccess
{
    NSLog(@"清理成功");
    [self sendUISignal:self.DIDCLEARCASH];
    rightlabel.text=[NSString stringWithFormat:@"%d MB",0];

}

ON_SIGNAL3(D2_Setting_ClearCashCell, cellSelected, signal)
{
    if (cashsize>0) {
        UIAlertView *alertvieiw=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否清除图片缓存" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"是的", nil];
        alertvieiw.tag=1056;
        [alertvieiw show];
    }    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1056) {
        if (buttonIndex==1) {
            [self clearCash];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
