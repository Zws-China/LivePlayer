//
//  HomeCell.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "HomeCell.h"
#import "UIImageView+WebCache.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface HomeCell()

//liveImage
@property (nonatomic, strong) UIImageView *liveImage;

//简介
@property (nonatomic, strong) UILabel *introduceLable;

//男女图标
@property (nonatomic, strong) UIImageView *sexIcon;

//名字
@property (nonatomic, strong) UILabel *nameLable;

//人数
@property (nonatomic, strong) UILabel *personNumLable;


@end
@implementation HomeCell

- (void)setModel:(CollectionCellModel *)model{
    _model = model;
    [self.liveImage sd_setImageWithURL:[NSURL URLWithString:model.spic] placeholderImage:[UIImage imageNamed:@"liveImage"]];
    self.nameLable.text = model.nickname;
    self.introduceLable.text = model.title;
    self.personNumLable.text = [model.online integerValue]>=10000?[NSString stringWithFormat:@"%.1f万",[model.online integerValue]/10000.0]:model.online;
    if ([model.gender isEqualToString:@"1"]) {
        self.sexIcon.image = [UIImage imageNamed:@"icon_room_female"];
    }else{
        self.sexIcon.image = [UIImage imageNamed:@"icon_room_male"];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
#pragma mark - 控件初始化
- (void)setupUI{
    self.liveImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (WIDTH - 40)/2.0, 100)];
    self.liveImage.image = [UIImage imageNamed:@"liveImage"];
    [self.contentView addSubview:self.liveImage];
    
//    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.liveImage.frame) - 14, CGRectGetWidth(self.liveImage.frame), 14)];
//    grayView.backgroundColor = [UIColor blackColor];
//    grayView.alpha = 0.5;
//    [self.liveImage addSubview:grayView];
    
    UIVisualEffectView *grayView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    grayView.frame = CGRectMake(0, CGRectGetMaxY(self.liveImage.frame) - 14, CGRectGetWidth(self.liveImage.frame), 14);
    [self.liveImage addSubview:grayView];

    
    self.introduceLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.liveImage.frame) - 14, CGRectGetWidth(self.liveImage.frame),14)];
    self.introduceLable.text = @"战旗TV主播介绍";
    self.introduceLable.textAlignment = NSTextAlignmentLeft;
    self.introduceLable.font = [UIFont systemFontOfSize:14];
    self.introduceLable.textColor = [UIColor whiteColor];
    [self.liveImage addSubview:self.introduceLable];
    
    self.sexIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.liveImage.frame) + 2, 13, 13)];
    self.sexIcon.image = [UIImage imageNamed:@"icon_room_male"];
    [self.contentView addSubview:self.sexIcon];
    
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.sexIcon.frame) + 3, CGRectGetMaxY(self.liveImage.frame) + 2, 150, 13)];
    self.nameLable.text = @"主播的昵称";
    self.nameLable.font = [UIFont systemFontOfSize:10];
    self.nameLable.textColor = [UIColor lightGrayColor];
    self.nameLable.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.nameLable];
    
    self.personNumLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.liveImage.frame) - 40, CGRectGetMaxY(self.liveImage.frame) + 2, 40, 13)];
    self.personNumLable.font = [UIFont systemFontOfSize:10];
    self.personNumLable.textColor = [UIColor lightGrayColor];
    self.personNumLable.textAlignment = NSTextAlignmentRight;
    self.personNumLable.text = @"1000";
    [self.contentView addSubview:self.personNumLable];
    
}



@end
