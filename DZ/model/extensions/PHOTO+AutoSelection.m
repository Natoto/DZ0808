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

#import "PHOTO+AutoSelection.h"
#import "SettingModel.h"

#pragma mark -

@implementation BeeUIImageView(AutoSelection)


-(void)setData:(id)data baseNetwork:(BOOL)network
{
    self.command = COMMAND_NORMARL;
    if (!network) {
        [self GET:data useCache:YES];
        return;
    }
    NSString *url = (NSString *)data;
    if (!url.length) {
        return ;
    }
    if ( [BeeReachability isReachableViaWIFI] )
    {
//        self.command = COMMAND_WIFI;
        [self GET:data useCache:YES];
    }
    else
    {
        
        if ( YES == [data hasPrefix:@"http://"] )
        {
            if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_23G_NOTLOAD)
            {
                self.command = COMMAND_2G3GNOSEE;
                self.image = self.defaultImage;
                return;
            }
            else
            {
                self.command = COMMAND_2G3GCAN;
            }
        }
        [self GET:data useCache:YES];
//        [super setData:data];
    }
}

/*
- (NSString *)thumbURL
{
	if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_MODE_AUTO )
	{
		if ( [BeeReachability isReachableViaWIFI] )
		{
			return self.thumb ? self.thumb : self.small;
		}
		else
		{
			return self.small ? self.small : self.thumb;
		}
	}
	else if ( [SettingModel sharedInstance].photoMode == SettingModel.PHOTO_MODE_HIGH )
	{
		return self.thumb ? self.thumb : self.small;
	}
	else
	{
		return self.small ? self.small : self.thumb;
	}
}*/

@end
