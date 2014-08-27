//
//  B3_ReplyPostViewController.m
//  DZ
//
//  Created by Nonato on 14-6-12.
//  Copyright (c) 2014年 Nonato. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>
#import "B3_PostReplyViewController.h"
#import "AppBoard_iPhone.h"
#import "LXActionSheet.h"
#import "SEPhotoView.h"
#import "replyModel.h"
#import "postImageModel.h"
#import "UserModel.h"
#import "newTopic.h"
#import "C0_HairPost_iphone.h"
#import "newTopicModel.h"
#import "HBImagePickerControllerEx.h"
#import "NSString+BeeExtension.h"
#import "DZ_Timer.h"
#define RECT_TOOLSOLD CGRectMake(0, CGRectGetMaxY(_scrollView.frame), 320, 33)
#define RECT_TOOLSNEW CGRectMake(0, self.view.bounds.size.height - TOP_VIEW_HEIGHT - keyBoardSize.height, self.view.bounds.size.width, TOP_VIEW_HEIGHT)

#define RECT_OLD_SCROLLVIEW CGRectMake(10,  10 , [[UIScreen mainScreen] bounds].size.width-20,300)
#define RECT_NEW_SCROLLVIEW CGRectMake(10,  10 , [[UIScreen mainScreen] bounds].size.width-20,CGRectGetMinY(_toolsview.frame) - 10)

@interface B3_PostReplyViewController ()<LXActionSheetDelegate,FaceBoardDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic,assign) NSInteger    totalUploadCount;
@property(nonatomic,assign) NSInteger    Uploadindex;
@property(nonatomic,strong) NSMutableArray * UploadedImageAry;
@property(nonatomic,strong) NSMutableArray * faceAttachments;
@property(nonatomic,strong) NSMutableArray * imageAttachments;
@property(nonatomic,strong) replyModel     * reply_model;
@property(nonatomic,strong) postImageModel * postImgModel;
@end

@implementation B3_PostReplyViewController
DEF_SIGNAL(didpostImage)
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    int MARIGINY=10;
    self.title = @"回复楼主";
//    UIEdgeInsets edg= bee.ui.config.baseInsets;
//    CGRect mainScreenRect=[[UIScreen mainScreen] bounds];
    if (self.friendpost) {
        self.title = [NSString stringWithFormat:@"回复%@",self.friendpost.authorname];
    }
    [self showBarButton:BeeUINavigationBar.LEFT image:[UIImage bundleImageNamed:@"fanhui(xin)"]];
    [self showBarButton:BeeUINavigationBar.RIGHT  title:@"回帖"];
    
//    self.tid = self.replyTitle;    
  
    
    _scrollView=[[UIScrollView alloc] initWithFrame:RECT_OLD_SCROLLVIEW];
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    KT_CORNER_RADIUS(_scrollView, 5);
    [self.view addSubview:_scrollView];
    
    self.toolsview=[[C0_HairPost_ToolsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), 320, 33) withTarget:self andFacialSel:@selector(showFace:) andpictureSel:@selector(pictureSelect:) andkeyboardSel:@selector(showKeyboard:)];
    [self.view addSubview:self.toolsview];
    self.toolsview.backgroundColor=[UIColor clearColor];
    
    SETextView *view = [[SETextView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(RECT_OLD_SCROLLVIEW) , 190)];
    view.autoresizingMask = UIViewAutoresizingNone;//UIViewAutoresizingFlexibleHeight;
    view.delegate = (id<SETextViewDelegate>)self;
    view.lineHeight=-1;
    view.lineSpacing=8;
    view.needboader = YES;
    view.font= GB_FontHelveticaNeue(15);//[UIFont systemFontOfSize:15];
    view.backgroundColor=[UIColor clearColor];
    [self.scrollView addSubview:view];
    
    self.fastTextView = view;
    self.fastTextView.editable = YES;
    self.fastTextView.lineSpacing = 8.0f;
    // Do any additional setup after loading the view.
    
    inputView=[[FaceBoard alloc] init];
    inputView.delegate = self;
    inputView.inputTextView=(UITextView *)_fastTextView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    _UploadedImageAry=[[NSMutableArray alloc] initWithCapacity:0];
    _imageAttachments=[[NSMutableArray alloc] initWithCapacity:0];
    _faceAttachments=[[NSMutableArray alloc] initWithCapacity:0];
    
    _postImgModel=[postImageModel modelWithObserver:self];
    _reply_model=[replyModel modelWithObserver:self];
    /* 暂时不做保存草稿
    [self loadDrafts];
    */
}

#pragma mark - 加载草稿
-(void)loadDrafts
{
    NSArray *array =[[newTopicModel sharedInstance] loaddratfs];
    for (int index=0; index<array.count; index++)
    {
        newtopicContent *acont=[array objectAtIndex:index];
        if (acont.type.integerValue==TEXTTYPE) {//文本
            if (![[C0_HairPost_iphone sharedInstance] isFacialMark:acont.msg seTextView:self.fastTextView]) {
                NSAttributedString *atrrstring=[[NSAttributedString alloc] initWithString:acont.msg];
                [self.fastTextView appendAttributedText:atrrstring];
            }
        }
        else if (acont.type.integerValue==IMGTYPE) {//图片
            
        }
        else if (acont.type.integerValue==FACETYPE) {//表情
            NSString *facename=[FaceBoard faceFileName:acont.msg];
            UIImage *stampImage = [UIImage bundleImageNamed:facename];
            if (stampImage) {
                self.fastTextView.addobj_name=acont.msg;
                self.fastTextView.addobj_type=@"2";
                [self.fastTextView insertObject:stampImage size:stampImage.size];
            }
        }
    }
}

#pragma mark - 回帖 与 保存草稿
ON_RIGHT_BUTTON_TOUCHED(signal)
{    
    NSString *text = self.fastTextView.text.trim;
    if ([NSString unicodeLengthOfString:text] < 10) {
      
        [self presentMessageTips:@"回复内容小于10个字符,不能全空格"];
        return;
    }
    
    int remaincount =[[DZ_Timer sharedInstance] replycount];
    if (!remaincount)
    {
        [self.fastTextView resignFirstResponder];
        [self startuploadimg];
    }
    else
    {
        [self presentMessageTips:[NSString stringWithFormat:@"还有%ds才可回复",remaincount]];
    }
}

#pragma mark - 退出编辑状态
ON_LEFT_BUTTON_TOUCHED(signal)
{
    if (self.fastTextView.text.length) {
        UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃编辑" delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"继续", nil];
        alertview.tag=235;
        [alertview show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==235) {
        if (buttonIndex==1) {//保存草稿
//            [[C0_HairPost_iphone sharedInstance] saveDrafts];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
//            [[newTopicModel sharedInstance] clearDrafts];
//            [DratfStruct removeObjectForKey:DRAFTSTRUCT];
        }
    }
}
ON_SIGNAL3(B3_PostReplyViewController, didpostImage, signal)
{
    
    [self presentLoadingTips:@"帖子回复中"];
    BeeLog(@"======发布========%@",_fastTextView.text);
    
    self.reply_model.tid = self.tid;
    self.reply_model.fid = self.fid;
    self.reply_model.pid = self.pid;
    
    self.reply_model.authorid = [UserModel sharedInstance].session.uid; //self.titleTxt.text;
    
//    newtopicContent *acont=[[newtopicContent alloc] init];
//    acont.msg=_fastTextView.text;
//    acont.type=[NSNumber numberWithInt:0];
    
    C0_HairPost_iphone *ctr=[C0_HairPost_iphone sharedInstance];
    self.reply_model.contents=[ctr spliteContentWithattAry:_fastTextView.attachments.allObjects atrributestr:_fastTextView.attributedText UploadedImageAry:self.UploadedImageAry];
    [self.reply_model load];
    [self.reply_model firstPage];
}

#pragma mark - 发布成功
ON_SIGNAL3(replyModel, RELOADED, signal)
{
    BeeLog(@"-------success------");
    [self dismissTips];
    BeeUITipsView *tipsview = [self presentMessageTips:@"回复成功"];
    tipsview.tag=134447;
    [[newTopicModel sharedInstance] clearDrafts];
    [DratfStruct removeObjectForKey:DRAFTSTRUCT];
    [[DZ_Timer sharedInstance] endReply];
}

ON_SIGNAL3(BeeUITipsView, WILL_DISAPPEAR , signal)
{
    BeeUITipsView *tipsview=(BeeUITipsView *)signal.sourceView;
    if (tipsview.tag == 134447) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

ON_SIGNAL3(replyModel, FAILED, signal)
{
    BeeLog(@"-------FAILED------");
    [self dismissTips];
    [self presentMessageTips:@"回复失败"];
   
}

-(void)startuploadimg
{
    [_imageAttachments removeAllObjects];
    [_faceAttachments removeAllObjects];
    for ( id object in _fastTextView.attachments.allObjects ) {
        if ([[object class] isSubclassOfClass:[SETextAttachment class]]) {
            SETextAttachment *setxt=(SETextAttachment *)object;
            if ([setxt.type isEqual:@"1"]) {//图片
                [_imageAttachments addObject:setxt];
            }
            else if([setxt.type isEqual:@"2"])
            {
                [_faceAttachments addObject:setxt];
            }
        }
    }
    
    self.Uploadindex=0;
    self.totalUploadCount=_imageAttachments.count;
    if (!self.totalUploadCount) {
        [self sendUISignal:self.didpostImage];
        return;
    }
    id object = [_imageAttachments objectAtIndex:_Uploadindex];
    if ([[object class] isSubclassOfClass:[SETextAttachment class]]) {
        SETextAttachment *setxt=(SETextAttachment *)object;
        [self uploadImage:setxt];
    }
    
}

#pragma mark - 上传图片
-(void)uploadImage:(SETextAttachment *)setxt
{
    _postImgModel.fid=self.fid;
    _postImgModel.uid=[UserModel sharedInstance].session.uid;
    SEPhotoView *photoview=setxt.object;
    _postImgModel.filename=setxt.name;
    _postImgModel.filedata=UIImageJPEGRepresentation(photoview.image, 0.5);
    [_postImgModel load];
    [_postImgModel firstPage];
    [self presentLoadingTips:[NSString stringWithFormat:@"正在上传(%d/%d)",self.Uploadindex+1,self.totalUploadCount]];
}

ON_SIGNAL3(postImageModel, FAILED, signal)
{
    [self dismissTips];
    [self presentMessageTips:@"图片上传不成功，请重试"];
}

ON_SIGNAL3(postImageModel, RELOADED, signal)
{
    postImageModel *postmodel=(postImageModel *)signal.sourceViewModel;
    newtopicContent *imgcontent=[[newtopicContent alloc] init];
    imgcontent.msg=postmodel.filename;
    imgcontent.type=[NSNumber numberWithInt:IMGTYPE];
    imgcontent.aid=postmodel.postimge.aid;
    [self.UploadedImageAry addObject:imgcontent];
    self.Uploadindex=self.Uploadindex + 1;
    if (self.Uploadindex < self.totalUploadCount)
    {
        SETextAttachment *setxt = [_imageAttachments objectAtIndex:_Uploadindex];
        [self uploadImage:setxt];
    }
    else
    {
        [self dismissTips];
        [self presentMessageTips:@"图片上传成功"];
        [self sendUISignal:self.didpostImage];
    }
    
}
#pragma mark - 从相册中选择
-(void)selectFromAblum{
    
    HBImagePickerControllerEx *m_imagePicker = [[HBImagePickerControllerEx alloc] init];
    [m_imagePicker setDelegate:self];
    [m_imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [m_imagePicker setAllowsEditing:NO];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self presentViewController:m_imagePicker animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark 图片拍照选择
-(IBAction)pictureSelect:(UIButton*)sender
{
    [self.fastTextView resignFirstResponder];
    
    LXActionSheet *sheet;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"]];
    }
    else {
        
        sheet = [[LXActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册选择"]];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
    [self.view bringSubviewToFront:sheet];
}
#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger *)buttonIndex
{
    NSLog(@"%d",(int)buttonIndex);
    [self selectpicture:nil andclickedButtonAtIndex:(int)buttonIndex];
}

- (void)didClickOnDestructiveButton
{
    NSLog(@"destructuctive");
}

- (void)didClickOnCancelButton
{
    NSLog(@"cancelButton");
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    
}


#pragma mark - image picker delegte
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:@"public.image"]){
            [self handleCanmearInfo:info];
        }
    }
    else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        [self handleAblumInfo:info];
    }
}
-(void)handleCanmearInfo:(NSDictionary *)info
{
    NSData *data;
    //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片压缩，因为原图都是很大的，不必要传原图
    UIImage *scaleImage = [[C0_HairPost_iphone sharedInstance] scaleImage:originImage toScale:0.5];
    
    //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
    if (UIImagePNGRepresentation(scaleImage) == nil) {
        //将图片转换为JPG格式的二进制数据
        data = UIImageJPEGRepresentation(scaleImage, 0.5);
    } else {
        //将图片转换为PNG格式的二进制数据
        data = UIImagePNGRepresentation(scaleImage);
    } //        //将二进制数据生成UIImage
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, self,
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
    photoView.image = image;
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[[NSDate date] stringWithDateFormat:@"yyyy_MM_dd_HH_MM_SS"]];
    self.fastTextView.addobj_name=fileName;
    self.fastTextView.addobj_type=@"1";
    [self.fastTextView insertObject:photoView size:photoView.bounds.size];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)handleAblumInfo:(NSDictionary *)info
{
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        UIImage *image=[UIImage imageWithCGImage:myasset.defaultRepresentation.fullScreenImage];
        //            UIImageJPEGRepresentation(image, 0.5);
        SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
        CGImageRef iref = [representation fullResolutionImage];
        NSString *fileName = representation.filename;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (iref) {
                photoView.image = image;
                self.fastTextView.addobj_name=fileName;
                self.fastTextView.addobj_type=@"1";
                [self.fastTextView insertObject:photoView size:photoView.bounds.size];
            }
        });
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)selectpicture:(UIActionSheet *)actionSheet andclickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([HBImagePickerControllerEx isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 2:
                // 取消
                return;
            case 0:
                // 相机
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
                [self performSelector:@selector(showcamera) withObject:nil afterDelay:0.3];
                break;
            }
            case 1:
                // 相册
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self selectFromAblum];
            }
        }
    }
    else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self selectFromAblum];
        }
    }
}
#pragma mark - 打开相机
- (void)showcamera {
    UIImagePickerController *m_imagePicker = [[UIImagePickerController alloc] init];
    [m_imagePicker setDelegate:self];
    [m_imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [m_imagePicker setAllowsEditing:NO];
    [self presentViewController:m_imagePicker animated:YES completion:nil];
}

//
//#pragma mark - 相册选择完成 ZYQAssetPickerController Delegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//    //    [src.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //        src.contentSize=CGSizeMake(assets.count*src.frame.size.width, src.frame.size.height);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //            pageControl.numberOfPages=assets.count;
//        });
//        
//        for (int i=0; i<assets.count; i++) {
//            ALAsset *asset=assets[i];
//            ALAssetRepresentation *representation = [asset defaultRepresentation];
//            UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//            //            UIImageJPEGRepresentation(image, 0.5);
//            SEPhotoView *photoView = [[SEPhotoView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 200.0f)];
//            CGImageRef iref = [representation fullResolutionImage];
//            NSString *fileName = representation.filename;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (iref) {
//                    photoView.image = image;
//                    self.fastTextView.addobj_name=fileName;
//                    self.fastTextView.addobj_type=@"1";
//                    [self.fastTextView insertObject:photoView size:photoView.bounds.size];
//                }
//            });
//        }
//    });
//}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


#pragma mark - 添加表情
-(IBAction)showFace:(UIButton*)sender
{
    if (![_fastTextView isFirstResponder]) {
        [_fastTextView becomeFirstResponder];
    }
    _fastTextView.inputView=inputView;
    [_fastTextView reloadInputViews];
    [self.toolsview showKeyboardBtn:YES];
}

-(IBAction)showKeyboard:(id)sender
{
    if (![_fastTextView isFirstResponder]) {
        [_fastTextView becomeFirstResponder];
    }
    [self.toolsview showKeyboardBtn:NO];
    _fastTextView.inputView=nil;
    [_fastTextView reloadInputViews];
}

-(void)faceboardBackface
{
    [self.fastTextView deleteBackward];
}

-(void)facebuttonTap:(id)sender andName:(NSString *)name
{
    UIButton *button = sender;
    UIImage *stampImage = [button imageForState:UIControlStateNormal];
    if (stampImage) {
        self.fastTextView.addobj_name=name;
        self.fastTextView.addobj_type=@"2";
        [self.fastTextView insertObject:stampImage size:stampImage.size];
    }
}

- (void)_addEmotion:(NSString *)emotionImgName;
{
    
}


-(IBAction)dismissKeyBoard:(id)sender {
    [_fastTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark fastTextViewDelegate

- (void)viewWillLayoutSubviews
{
    [self updateLayout];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    [self resizeTextView:notification];
//    UIEdgeInsets edg= bee.ui.config.baseInsets;
    NSDictionary* info  =  [notification userInfo];
    CGSize keyBoardSize =  [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.toolsview.frame = RECT_TOOLSNEW;
    self.scrollView.frame = RECT_NEW_SCROLLVIEW;
   
    // CGRectMake(10,  10 , [[UIScreen mainScreen] bounds].size.width-20,self.view.bounds.size.height - edg.top - keyBoardSize.height);
    [self.view bringSubviewToFront:self.toolsview];
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [self resizeTextView:notification];
//    UIEdgeInsets edg= bee.ui.config.baseInsets;
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    self.scrollView.frame = RECT_OLD_SCROLLVIEW;//CGRectMake(10, edg.top + 80 + 10*3, 320-20,200);
    self.toolsview.frame = RECT_TOOLSOLD;
    [self.toolsview showKeyboardBtn:NO];
    //CGRectMake(0, self.bounds.size.height-2*TOP_VIEW_HEIGHT, self.bounds.size.width, TOP_VIEW_HEIGHT);
    //    self.toolsview.frame=CGRectMake(0, edg.top + 280 + 10*4, 320, 33);
    [UIView commitAnimations];
}
-(void)resizeTextView:(NSNotification *)notify
{
    self.scrollView.scrollEnabled = NO;
	CGRect keyboardBounds;
    [notify.userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
	CGRect containerFrame = self.scrollView.frame;
    containerFrame.size.height = 300;//CGRectGetHeight(self.view.bounds) - CGRectGetHeight(keyboardBounds);
	self.scrollView.frame = containerFrame;
    self.scrollView.scrollEnabled = YES;
}


- (void)updateLayout
{
    CGSize containerSize = self.scrollView.frame.size;
    CGSize contentSize = [self.fastTextView sizeThatFits:containerSize];
    CGRect frame = self.fastTextView.frame;
    frame.size.height = MAX(contentSize.height, containerSize.height);
    
    self.fastTextView.frame = frame;
    self.scrollView.contentSize = frame.size;//CGSizeMake(self.fastTextView.size.width, self.fastTextView.size.height+20);
    [self.scrollView scrollRectToVisible:self.fastTextView.caretRect animated:YES];
}

#pragma mark -

- (void)textViewDidChangeSelection:(SETextView *)textView
{
    NSRange selectedRange = textView.selectedRange;
    if (selectedRange.location != NSNotFound && selectedRange.length > 0) {
        //        self.inputAccessoryView.boldButton.enabled = YES;
        //        self.inputAccessoryView.nomalButton.enabled = YES;
    } else {
        //        self.inputAccessoryView.boldButton.enabled = NO;
        //        self.inputAccessoryView.nomalButton.enabled = NO;
    }
}

- (void)textViewDidChange:(SETextView *)textView
{
    [self updateLayout];
    
}


@end
