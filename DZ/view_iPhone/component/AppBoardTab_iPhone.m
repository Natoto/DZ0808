//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//
#import "model.h"
#import "AppBoardTab_iPhone.h"
#import "UIImage+Tint.h"
#import "DZ_SystemSetting.h"
#pragma mark -

DEF_UI( AppBoardTab_iPhone, tabbar)
@interface TabItem : UIView
@property(nonatomic,strong)NSString     * imageurl;
@property(nonatomic,strong)UIButton     * button;
@property(nonatomic,strong)UILabel      * label;
@property(nonatomic,strong)UIImageView  * icon;
@property(nonatomic,strong)UIImageView  * selectimgview;
-(void)active:(id)sender;
-(void)unactive:(id)sender;
-(void)setIcon:(NSString *)iconName andTitle:(NSString *)title;
- (id)initWithFrame:(CGRect)frame anddelegate:(id)delegate  andSelectSel:(SEL)selectSel;
@end


@implementation TabItem
- (id)initWithFrame:(CGRect)frame anddelegate:(id)delegate  andSelectSel:(SEL)selectSel
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        _selectimgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        UIImage *imgnavigationbar=[UIImage bundleImageNamed:@"navigationbar.jpg"];
        
        DZ_SystemSetting *setting=[DZ_SystemSetting sharedInstance];
        imgnavigationbar =[imgnavigationbar imageWithTintColor:[setting tabBarHighLightColor]];
        _selectimgview.image=imgnavigationbar;
        _selectimgview.alpha = 0;
        [self addSubview:_selectimgview];
         _selectimgview.hidden=YES;
        
        _icon=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
        _icon.center=CGPointMake(self.width/2, 20);
        _icon.contentMode=UIViewContentModeScaleAspectFill;
        [self addSubview:_icon];
        
        _label=[[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-17, self.frame.size.width, 15)];
        _label.backgroundColor=[UIColor clearColor];
        _label.textColor=[UIColor whiteColor];
        _label.font= GB_FontHelvetica_BoldNeue(10);//[UIFont fontWithName:@"Helvetica" size:10];
        _label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_label];
        
        _button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _button.backgroundColor=[UIColor clearColor];
        [_button setBackgroundImage:imgnavigationbar forState:UIControlStateHighlighted];
        _button.alpha = 0.2;
        [_button addTarget:delegate action:selectSel forControlEvents:UIControlEventTouchUpInside];
        [self sendSubviewToBack:_button];
        [self addSubview:_button];
    }
    return self;
}
-(void)setIcon:(NSString *)iconName andTitle:(NSString *)title
{
    self.icon.image=[UIImage bundleImageNamed:iconName];
     DZ_SystemSetting *setting=[DZ_SystemSetting sharedInstance];
    UIColor *iconcolor=  [setting tabBarIconColor];
    self.icon.image =[self.icon.image imageWithTintColor:iconcolor];
    self.label.text=title;
    self.label.textColor=iconcolor;
}
-(void)unactive:(id)sender
{
    _selectimgview.hidden=YES;
}
-(void)active:(id)sender
{
    _selectimgview.hidden=NO;
}

@end

@implementation AppBoardTab_iPhone

DEF_SINGLETON( AppBoardTab_iPhone )
//SUPPORT_RESOURCE_LOADING( YES )
DEF_SIGNAL(homepage)
DEF_SIGNAL(forum)
DEF_SIGNAL(sendhtm)
DEF_SIGNAL(mine)
DEF_SIGNAL(album)
/*
 <button id="homepage" class="item active">首页</button>
 <button id="forum" class="item">论坛</button>
 <button id="sendhtm" class="item">发帖</button>
 <button id="mine" class="item">我的</button>
 */

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha=1;
        UIImage *imgnavigationbar=[UIImage bundleImageNamed:@"navigationbar.jpg"];
        DZ_SystemSetting *setting=[DZ_SystemSetting sharedInstance];
        imgnavigationbar =[imgnavigationbar imageWithTintColor:[setting tabbarbackgroundColor]];
        self.backgroundImage=imgnavigationbar;
        CGRect rect=[[UIScreen mainScreen] bounds];
        NSString *HOME = __TEXT(@"HOME");
        NSString *FORUM = __TEXT(@"FORUM");
        NSString *POST = __TEXT(@"POST");
        NSString *ABLUM = __TEXT(@"ALBUM");
        NSString *MINE = __TEXT(@"MINE");
        titleAry=[NSArray arrayWithObjects:HOME,FORUM,POST,ABLUM,MINE, nil];
        iconNameAry=[NSArray arrayWithObjects:@"homepage.PNG",@"plates.PNG",@"sendhtm.PNG",@"tuku-01.png",@"wodetubiao@2x.png", nil];
        tabbarSelectorAry=[NSArray arrayWithObjects:@"selectHomepage",@"selectForum",@"selectSendhtm",@"selectblum",@"selectMine", nil];
        
        
        float buttonWith=rect.size.width/titleAry.count;
        float buttonheight=TAB_HEIGHT;// frame.size.height;
        
        for (int i=0; i<titleAry.count; i++) {
            NSString *selectorstr=[tabbarSelectorAry objectAtIndex:i];
            TabItem *tabitem=[[TabItem alloc] initWithFrame:CGRectMake(i*buttonWith, 0, buttonWith, buttonheight) anddelegate:self andSelectSel:NSSelectorFromString(selectorstr)];
            [tabitem setIcon:[iconNameAry objectAtIndex:i] andTitle:[titleAry objectAtIndex:i]];
            tabitem.imageurl = [iconNameAry objectAtIndex:i];
            [self addSubview:tabitem];
            if (i == 0) {
                self.homepagebtn = tabitem;
            }
            else if (i == 1) {
                self.forumbtn = tabitem;
            }
            else if (i == 2) {
                self.sendhtmbtn = tabitem;
            }
            else if (i == 3) {
                self.blumbtn = tabitem;
            }
            else if (i == 4) {
                self.minebtn = tabitem;
            }
        }
         [self selectHomepage];
     }
    return self;
}

-(UIButton *)buttonWithframe:(CGRect)frame andTitle:(NSString *)title
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal]; 
    button.frame=frame;
    return button;
}



- (void)unload
{
	[self unobserveAllNotifications];
}

-(void)active:(TabItem *)button
{
    [button active:nil];
    UIColor *color = [[DZ_SystemSetting sharedInstance] tabbarselectediconcolor];
    button.icon.image = [UIImage bundleImageNamed:button.imageurl];
    UIImage *image =[button.icon.image imageWithTintColor: color];
    button.icon.image = image;
    button.label.textColor = color;
}
-(void)unactive:(TabItem *)button
{
    [button unactive:nil];
    UIColor *color = [[DZ_SystemSetting sharedInstance] tabBarIconColor];
    button.icon.image = [UIImage bundleImageNamed:button.imageurl];
    UIImage *image =[button.icon.image imageWithTintColor: color];
    button.icon.image = image;
    button.label.textColor = color;
}

//forum homepage sendhtm mine
- (void)selectHomepage
{
    [self active:self.homepagebtn];
    [self unactive:self.forumbtn];
    [self unactive:self.sendhtmbtn];
    [self unactive:self.blumbtn];
    [self unactive:self.minebtn];
    [self sendUISignal:self.homepage];
    self.RELAYOUT();
    BeeLog(@"homepage %@",self.homepagebtn);
}

- (void)selectForum
{
    [self unactive:self.blumbtn];
    [self unactive:self.homepagebtn];
    [self active:self.forumbtn];
    [self unactive:self.sendhtmbtn];
    [self unactive:self.minebtn];
    self.RELAYOUT();
    [self sendUISignal:self.forum];
}


-(void)selectblum
{
    [self unactive:self.homepagebtn];
    [self unactive:self.forumbtn];
    [self unactive:self.sendhtmbtn];
    [self unactive:self.minebtn];
    [self active:self.blumbtn];
    self.RELAYOUT();
    [self sendUISignal:self.album];
}

- (void)selectSendhtm
{
    [self sendUISignal:self.sendhtm];
}

-(void)selectMine
{
    [self unactive:self.homepagebtn];
    [self unactive:self.forumbtn];
    [self unactive:self.blumbtn];
    [self unactive:self.sendhtmbtn];
    [self active:self.minebtn];
    self.RELAYOUT();
    
    [self sendUISignal:self.mine];
}
@end
