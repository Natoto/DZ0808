//
//  E0_AlbumBoard_iphone.m
//  DZ
//
//  Created by Nonato on 14-7-23.
//
//
#import "bee.h"
#import "PictureWallModel.h"
#import "E0_AlbumBoard_iphone.h"
#import "E0_AblumWaterFLayout.h"
#import "AppBoardTab_iPhone.h"
#import "E0_AblumWaterFCell.h"
#import "B3_PostViewController.h"
#import "AppBoard_iPhone.h"
#import "MJRefresh.h"
@interface E0_AlbumBoard_iphone ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,retain)PictureWallModel    * picwallModel;
@property (nonatomic,strong) UICollectionView  * collectionView; 

#pragma mark  collectionView -
@property (nonatomic,strong) NSArray* imagesArr;
@property (nonatomic,strong) NSArray* textsArr;
@property (nonatomic,assign) NSInteger sectionNum;
@property (nonatomic) float imagewidth;
//@property (nonatomic) CGFloat textViewHeight;
//@property (nonatomic,strong) NSMutableArray* buttons;
//@property (nonatomic,strong) NSMutableArray* buttonStates;
@end

@implementation E0_AlbumBoard_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [bee.ui.appBoard showTabbar];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.picwallModel = [PictureWallModel modelWithObserver:self];
    [self.picwallModel firstPage];
    
    E0_AblumWaterFLayout* flowLayout = [[E0_AblumWaterFLayout alloc]init];
    CGRect bounds = [UIScreen mainScreen].bounds;
    CGRect rect =CGRectMake(0, 0, CGRectGetWidth(bounds), CGRectGetHeight(bounds) - bee.ui.tabbar.height);
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout]; //initWithCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[E0_AblumWaterFCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor =[UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.picwallModel loadCache];
    
    self.imagewidth = 160;
    [self loadData];

    self.navigationBarShown = YES;
    self.title = @"图库";
    [self addHeader];
    [self addFooter];
}

-(void)loadData
{
    
}


- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc.picwallModel firstPage];
    }];
    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc.picwallModel nextPage];
        // 模拟延迟加载数据，因此2秒后才调用）
    }];
}
ON_SIGNAL3(PictureWallModel, FAILED, signal)
{
    [self.collectionView footerEndRefreshing];
    [self.collectionView headerEndRefreshing];
}
ON_SIGNAL3(PictureWallModel, RELOADED, signal)
{
//     self.picwallModel.shots
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        // 结束刷新
        [self.collectionView footerEndRefreshing];
        [self.collectionView headerEndRefreshing];
//    });
//     NSArray* urls =
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.picwallModel.shots.count) {
        return  self.picwallModel.shots.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
     E0_AblumWaterFCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {//
        cell = [[E0_AblumWaterFCell alloc] init];
    }
    pcms * apcms = [self.picwallModel.shots objectAtIndex:indexPath.row];
    CGFloat aFloat = 0;
    aFloat = self.imagewidth/apcms.width.floatValue;
    cell.imageView.frame = CGRectMake(0, 0, self.imagewidth,  apcms.height.floatValue*aFloat) ;
    cell.imageView.data =apcms.attachment;
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    pcms * apcms = [self.picwallModel.shots objectAtIndex:indexPath.row];
    B3_PostViewController *board=[[B3_PostViewController alloc] init];
    board.tid = apcms.tid;
    [self.navigationController pushViewController:board animated:YES]; 
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    pcms * apcms = [self.picwallModel.shots objectAtIndex:indexPath.row];
    CGFloat aFloat = 0.0;
    float pcimgwidth = apcms.width.floatValue;
    aFloat = self.imagewidth/pcimgwidth;//image.size.width;
    CGSize size = CGSizeMake(0,0);
    size = CGSizeMake(self.imagewidth, apcms.height.floatValue * aFloat);
    return size;
}

@end
