//
//  WNXStageListView.m
//  Hardest
//
//  Created by sfbest on 16/2/26.
//  Copyright © 2016年 维尼的小熊. All rights reserved.
//

#import "WNXStageListView.h"
#import "WNXStage.h"
#import "WNXStageView.h"
#import "WNXStageInfoManager.h"

@implementation WNXStageListView

- (instancetype)init{
    if (self = [super initWithFrame:ScreenBounds]) {
        self.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
        
        NSArray *bgNames = @[@"select_easy_bg", @"select_normal_bg", @"select_hard_bg", @"select_insane_bg"];
        for (int i = 0; i < 4; i++) {
            WNXFullBackgroundView *listView = [[WNXFullBackgroundView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight)];
            [listView setBackgroundImageWihtImageName:bgNames[i]];
            [self addSubview:listView];
        }
        
        [self loadStageInfo];
    }

    return self;
}

- (void)loadStageInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"stages.plist" ofType:nil];
    NSArray *stageArr = [NSArray arrayWithContentsOfFile:path];
    
    CGFloat stageViewW = 120;
    CGFloat stageViewH = 100;
    CGFloat viewMaxgin = ScreenWidth - stageViewW * 2 - 25 * 2;
    CGFloat topMagin = iPhone5 ? 130 : 80;
    WNXStageInfoManager *manager = [WNXStageInfoManager sharedStageInfoManager];
    
    for (int i = 0; i < stageArr.count; i++) {
        WNXStage *stage = [WNXStage stageWithDict:stageArr[i]];
        stage.num = i + 1;
        stage.userInfo = [manager stageInfoWithNumber:i + 1];
        
        WNXStageView *stageView = [WNXStageView stageViewWithStage:stage];
        
        CGFloat scrollX = ((int)(i / 6)) * ScreenWidth;
        
        CGFloat startX = 25 + ((i % 6) / 3) * (stageViewW + viewMaxgin) + scrollX;
        CGFloat startY = topMagin + (i % 3) * (stageViewH + 30);
        
        stageView.frame = CGRectMake(startX, startY, stageViewW, stageViewH);
        [self addSubview:stageView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.didChangeScrollPage) {
        int page = (scrollView.contentOffset.x / ScreenWidth + 0.5);
        if (page < 0) page = 0;
        if (page > 3) page = 3;
        self.didChangeScrollPage(page);
    }
}

@end