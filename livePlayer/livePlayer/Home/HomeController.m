//
//  HomeController.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "HomeController.h"

#import "AFNetworking.h"
#import "HomeCell.h"
#import "HomeCycleView.h"
#import "MenuHeader.h"

#import "VideoPlayerController.h"

#import "BannerModel.h"
#import "RoomModel.h"
#import "HomeSectionModel.h"
#import "CollectionCellModel.h"

#import "MJExtension.h"



#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define kNavigationBarHeight 44
#define kStatusBarHeight 20
#define kMarginTopHeight 64
#define kTabBarHeight 49





#define IDENTIFIER_CELL @"homeMenuCell"
#define IDENTIFIER_HEADER @"homeMenuHeader"
#define IDENTIFIER_HEADERSECTION @"homeMenuHeaderSection"



@interface HomeController ()<UICollectionViewDelegate,UICollectionViewDataSource,HomeCycleViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collection;

//轮播器
@property (nonatomic, strong) HomeCycleView *cycleView;


/**
 *  存放滚动栏信息，包括房间信息
 */
@property (nonatomic, strong) NSMutableArray *banderModelArray;
/**
 *  存放房间信息
 */
@property (nonatomic, strong) NSMutableArray *roomModelArray;

/**
 *  存放组的名字数组
 */
@property (nonatomic, strong) NSMutableArray *sectionTitleDataArray;


/**
    self.avatarDataArray数组  装五个房间的信息
 */
@property (nonatomic, strong) NSMutableArray *avatarDataArray;

/**
    self.sectionDataArray 装多个分类的数组，self.sectionDataArray下装有多个（热门直播，竞技网游，随拍）分类，
    每个分类的数组下有五个房间信息
 */
@property (nonatomic, strong) NSMutableArray *sectionDataArray;


@end

@implementation HomeController

- (NSMutableArray *)banderModelArray{
    if (!_banderModelArray) {
        _banderModelArray = [NSMutableArray array];
    }
    return _banderModelArray;
}
//房间数组
- (NSMutableArray *)roomModelArray{
    if (!_roomModelArray) {
        _roomModelArray = [NSMutableArray array];
    }
    return _roomModelArray;
}
- (NSMutableArray *)sectionTitleDataArray{
    if (!_sectionTitleDataArray) {
        _sectionTitleDataArray = [NSMutableArray array];
    }
    return _sectionTitleDataArray;
}
- (NSMutableArray *)avatarDataArray{
    if (!_avatarDataArray) {
        _avatarDataArray = [NSMutableArray array];
    }
    return _avatarDataArray;
}
- (NSMutableArray *)sectionDataArray {
    if (!_sectionDataArray) {
        _sectionDataArray = [NSMutableArray array];
    }
    return _sectionDataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = self;
    self.navigationItem.title = @"ZWS";
    [self requestHederBanner];//请求头部滚动的网络数据
    
    [self requestCellContent];//获取主播列表数据
    
    
    [self creatCollectionView];//创建CollectionView


}

- (void)requestHederBanner {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];

    [manager GET:@"http://www.zhanqi.tv/api/touch/apps.banner?rand=1455848328344" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"返回格式不是JSON");
            return;
        }
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        int code;
        id value = [dic objectForKey:@"code"];
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            code = [value intValue];
        }
        else {
            code = 0;
        }
        
        NSArray *dataArr = dic[@"data"];
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BannerModel *bannerModel = [BannerModel mj_objectWithKeyValues:(NSDictionary *)obj];
            [self.banderModelArray addObject:bannerModel];


            RoomModel *roomModel = [RoomModel mj_objectWithKeyValues:(NSDictionary *)bannerModel.room];
            [self.roomModelArray addObject:roomModel];
        }];

        
        [self.collection reloadData];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求数据失败");

    }];
    
    
    
}
#pragma mark - 发送网络请求，获取主播列表数据
- (void)requestCellContent {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain",@"text/html", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    
    [manager GET:@"http://www.zhanqi.tv/api/static/live.index/recommend-apps.json?" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"返回格式错误");
            return;
        }
        NSDictionary *dic = (NSDictionary *)responseObject;
        int code;
        id value = [dic objectForKey:@"code"];
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            code = [value intValue];
        }
        else {
            code = 0;
        }
        
        NSArray *arr = dic[@"data"];
        for (NSDictionary *dictionary in arr) {
            HomeSectionModel *sectionModel = [HomeSectionModel mj_objectWithKeyValues:dictionary];
            [self.sectionTitleDataArray addObject:sectionModel]; //外围标题模型
            
            [self.avatarDataArray removeAllObjects];
            for (CollectionCellModel *cellModel in sectionModel.lists) {
                //self.avatarDataArray数组  装五个房间的信息
                [self.avatarDataArray addObject:cellModel];
            }
            //self.sectionDataArray 装多个分类的数组，self.sectionDataArray下装有多个（热门直播，竞技网游，随拍）分类，每个分类的数组下有五个房间信息
            [self.sectionDataArray addObject:self.avatarDataArray.copy];
        }
        [self.collection reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取失败");

    }];
    
    
}

- (void)creatCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) collectionViewLayout:flowLayout];
    self.collection.delegate = self;
    self.collection.dataSource = self;
    self.collection.backgroundColor = [UIColor whiteColor];
    self.collection.showsVerticalScrollIndicator = NO;
    
    
    [self.collection registerClass:[HomeCell class] forCellWithReuseIdentifier:IDENTIFIER_CELL];
    [self.collection registerClass:[MenuHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDENTIFIER_HEADERSECTION];
    [self.collection registerClass:[HomeCycleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDENTIFIER_HEADER];
    
    [self.view addSubview:self.collection];

}


#pragma mark - collectionDelegate and dataSourse

#pragma  mark - 返回header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(WIDTH, 180 + 33);
    }else{
        return CGSizeMake(WIDTH, 40);
    }
}

#pragma mark - 组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            self.cycleView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDENTIFIER_HEADER forIndexPath:indexPath];
            self.cycleView.delegate = self;
            self.cycleView.photoDataArray = self.banderModelArray.copy;
            self.cycleView.titleDataString= ((HomeSectionModel *)self.sectionTitleDataArray[indexPath.section]).title;
            self.cycleView.imageUrl = ((HomeSectionModel *)self.sectionTitleDataArray[indexPath.section]).icon;
            reusableview = self.cycleView;
        }else{
            MenuHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:IDENTIFIER_HEADERSECTION forIndexPath:indexPath];
            sectionHeader.titleDataString = ((HomeSectionModel *)self.sectionTitleDataArray[indexPath.section]).title;
            sectionHeader.imageUrl = ((HomeSectionModel *)self.sectionTitleDataArray[indexPath.section]).icon;
            reusableview = sectionHeader;
        }
    }
    return reusableview;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ((NSArray *)[self.sectionDataArray objectAtIndex:section]).count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH - 40)/2.0, 130);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *cell = (HomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_CELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.sectionDataArray) {
        cell.model = (CollectionCellModel *)[[self.sectionDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"collectionView didSelectItemAtIndexPath");
    
    VideoPlayerController *videoVC = [[VideoPlayerController alloc]init];
    NSString *videoID = ((CollectionCellModel *)[[self.sectionDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).videoId;
    NSString *urlID = ((CollectionCellModel *)[[self.sectionDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).spic;
    NSString *shutId = [urlID substringWithRange:NSMakeRange(37, 12)];
    if (videoID) {
        videoVC.videoID = videoID;
    }else{
        videoVC.videoID = shutId;
    }
    videoVC.videoTitle = ((CollectionCellModel *)[[self.sectionDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).title;
    
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
    

    
}

- (void)homeCycleView:(HomeCycleView *)homeCycleView roomId:(NSString *)roomId roomTitle:(NSString *)title {
    NSLog(@"homeCycleView roomId");
    
    VideoPlayerController *videoVC = [[VideoPlayerController alloc]init];
    videoVC.videoID = roomId;
    videoVC.videoTitle = title;
    videoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:videoVC animated:YES];
}


#pragma mark - UINaivgationController Delegate
#pragma mark -
#pragma mark Will Show ViewController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden: [self needHiddenBarInViewController: viewController] animated: animated];
}

- (BOOL) needHiddenBarInViewController:(UIViewController *)viewController {
    
    BOOL needHideNaivgaionBar = NO;
    
    if ([viewController isKindOfClass: [VideoPlayerController class]]) {
        needHideNaivgaionBar = YES;
    }
    
    return needHideNaivgaionBar;
}



@end
