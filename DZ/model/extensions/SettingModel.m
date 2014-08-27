//
//                       __
//                      /\ \   _
//    ____    ____   ___\ \ \_/ \           _____    ___     ___
//   / _  \  / __ \ / __ \ \    <     __   /\__  \  / __ \  / __ \
//  /\ \_\ \/\  __//\  __/\ \ \\ \   /\_\  \/_/  / /\ \_\ \/\ \_\ \
//  \ \____ \ \____\ \____\\ \_\\_\  \/_/   /\____\\ \____/\ \____/
//   \/____\ \/____/\/____/ \/_//_/         \/____/ \/___/  \/___/
//     /\____/
//     \/___/
//
//	Powered by BeeFramework
//

#import "SettingModel.h"

#pragma mark -

@implementation SettingModel

DEF_SINGLETON( SettingModel )
DEF_INT( PHOTO_23G_NOTLOAD,	0 )
DEF_INT( PHOTO_23G_LOAD,	1 )
@synthesize photoMode = _photoMode;

- (void)load
{
	[self loadCache];
}

- (void)unload
{
	[self saveCache];
}

#pragma mark -

- (void)loadCache
{
    self.fontsize =  [[self userDefaultsRead:@"SettingModel.fontsize"] integerValue];
    self.fontsize = self.fontsize ? self.fontsize :FONTSIZE_MIDDLE;
	self.photoMode = [[self userDefaultsRead:@"SettingModel.photoMode"] integerValue];
    if (![self userDefaultsRead:@"SettingModel.photoMode"]) {//默认加载图片
        self.photoMode = self.PHOTO_23G_LOAD;
    }
}

- (void)saveCache
{
    [self userDefaultsWrite:@(self.fontsize) forKey:@"SettingModel.fontsize"];
	[self userDefaultsWrite:@(self.photoMode) forKey:@"SettingModel.photoMode"];
}

- (void)clearCache
{
    self.fontsize = FONTSIZE_MIDDLE;
	self.photoMode = self.PHOTO_23G_LOAD;
	self.loaded = NO;
}

@end
