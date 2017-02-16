//
//  HomeCycleView.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "HomeCycleView.h"
#import "SDCycleScrollView.h"
#import "BannerModel.h"
#import "UIImageView+WebCache.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface HomeCycleView()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UILabel *title;//名称：竞技网游

@property (nonatomic, strong) NSMutableArray *roomIdArr;//房间ID号码
@property (nonatomic, strong) NSMutableArray *roomTitleArr;//房间ID号码

@end


@implementation HomeCycleView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setTitleDataString:(NSString *)titleDataString {
    _titleDataString = titleDataString;
    self.title.text = titleDataString;
}

- (void)setPhotoDataArray:(NSArray *)photoDataArray {
    _photoDataArray = photoDataArray;
    NSMutableArray *imageArr = [NSMutableArray array];//轮播图片数组
    self.roomIdArr = [NSMutableArray array];//房间ID
    self.roomTitleArr = [NSMutableArray array];//房间名称
    
    for (BannerModel *model in photoDataArray) {
        [imageArr addObject:model.spic];
        [self.roomIdArr addObject:model.roomId];
        [self.roomTitleArr addObject:model.title];
    }
    
    self.cycleView.imageURLStringsGroup = imageArr;
}

-(void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [_lineView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}




- (void)setupUI{
    
    self.cycleView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 170)];
    self.cycleView.backgroundColor = [UIColor whiteColor];
    self.cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.cycleView.dotColor = [UIColor whiteColor];
    self.cycleView.placeholderImage = [UIImage imageNamed:@"ic_logo_big"];
    SDCycleScrollView *cycleView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 170)];
    self.cycleView.delegate = self;
    [cycleView addSubview:self.cycleView];
    [self addSubview:cycleView];
    
    _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.cycleView.frame) + 10, 26, 26)];
    [self addSubview:_lineView];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lineView.frame) + 4, CGRectGetMaxY(self.cycleView.frame) + 10, WIDTH - 40, 26)];
    self.title.text = @"组的标题";
    self.title.font = [UIFont boldSystemFontOfSize:20];
    self.title.textColor = [UIColor blackColor];
    self.title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.title];

}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if ([_delegate respondsToSelector:@selector(homeCycleView:roomId:roomTitle:)]) {
        [_delegate homeCycleView:self roomId:self.roomIdArr[index] roomTitle:self.roomTitleArr[index]];
    }
    
}









@end
