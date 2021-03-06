//
//  ViewController.m
//  ParallaxCustomLayout
//
//  Created by bjovov on 2017/11/1.
//  Copyright © 2017年 caoxueliang.cn. All rights reserved.
//

#import "ViewController.h"
#import "InspirationCell.h"
#import "InspirationLayout.h"
#import "InspirationModel.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView *myCollection;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern"]];
    [self.view addSubview:self.myCollection];
    self.myCollection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0){
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        self.myCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#endif
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionView M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InspirationModel *model = self.dataArray[indexPath.item];
    InspirationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InspirationCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    InspirationLayout *layout = (InspirationLayout *)self.myCollection.collectionViewLayout;
    CGFloat offSet = layout.dragOffset *indexPath.item;
    if (self.myCollection.contentOffset.y != offSet) {
        [self.myCollection setContentOffset:CGPointMake(0, offSet) animated:YES];
    }
}

#pragma mark - Setter && Getter
- (UICollectionView *)myCollection{
    if (!_myCollection) {
        InspirationLayout *layout = [[InspirationLayout alloc]init];
        _myCollection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _myCollection.backgroundColor = [UIColor clearColor];
        [_myCollection registerClass:[InspirationCell class] forCellWithReuseIdentifier:@"InspirationCell"];
        _myCollection.dataSource = self;
        _myCollection.delegate = self;
    }
    return _myCollection;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Inspirations" ofType:@"plist"];
        NSArray *tmpArray = [NSArray arrayWithContentsOfFile:path];
        [tmpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            InspirationModel *model = [InspirationModel initWithDictionary:dict];
            [_dataArray addObject:model];
        }];
    }
    return _dataArray;
}

@end
