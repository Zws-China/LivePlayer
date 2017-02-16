//
//  MenuHeader.m
//  视屏直播
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "MenuHeader.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#import "UIImageView+WebCache.h"

@interface MenuHeader()

@property (nonatomic, strong) UILabel *title;

@property (nonatomic, strong) UIImageView *lineView;

@end
@implementation MenuHeader

- (void)setTitleDataString:(NSString *)titleDataString{
    _titleDataString = titleDataString;
    self.title.text = titleDataString;
}

-(void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    
    [_lineView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 26, 26)];
    [self addSubview:_lineView];
    
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lineView.frame) + 4, 7, WIDTH - 40, 26)];
    self.title.text = @"组的标题";
    self.title.font = [UIFont boldSystemFontOfSize:20];
    self.title.textColor = [UIColor blackColor];
    self.title.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.title];
    
}


@end
