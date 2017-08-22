//
//  ZKRootViewController.m
//  ZKKLineDemo
//
//  Created by ZK on 2017/8/7.
//  Copyright © 2017年 ZhouKang. All rights reserved.
//

#import "ZKRootViewController.h"
#import "KLineChartView.h"
#import "KLineListTransformer.h"
#import "StatusView.h"
#import <YYModel.h>
#import "ZKKLineItem.h"
#import "ACMacros.h"
#import "NetWorking.h"
#import "MCKLineGroupModel.h"

@interface ZKRootViewController ()

@property (nonatomic, strong) KLineListTransformer *lineListTransformer;
@property (nonatomic, strong) KLineChartView *kLineChartView;

@property (nonatomic, strong) StatusView *kStatusView;

/**
 *  (模拟)实时测试
 */
@property (nonatomic, strong) NSArray <ZKKLineItem *> *dataSource;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZKRootViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"币柒网";
    self.view.backgroundColor = GlobalColor_Dark;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"旋转" style:UIBarButtonItemStyleDone target:self action:@selector(rotateScreen:)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self setupKLineView];
    [self requestData];
}

- (void)rotateScreen:(UIBarButtonItem *)item {
    if (item.tag == 0) {
        _kLineChartView.landscapeMode = true;
        item.tag = 1;
    }
    else {
        _kLineChartView.landscapeMode = false;
        item.tag = 0;
    }
}

- (void)setupKLineView {
    _kLineChartView = [[KLineChartView alloc] initWithFrame:CGRectMake(0, 64, self.view.us_width, self.view.us_height - 64)];
    [self.view addSubview:self.kLineChartView];
    _kLineChartView.autoFit = true;
}

- (void)requestData {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"type"] = @"5min";
    param[@"symbol"] = @"huobibtccny";
    param[@"size"] = @"300";
    
    [NetWorking requestWithApi:@"https://www.btc123.com/kline/klineapi" param:param thenSuccess:^(NSDictionary *responseObject) {
        NSLog(@"接口返回数据：%@", responseObject);
        if ([responseObject[@"isSuc"] boolValue]) {
            MCKLineGroupModel *groupModel = [MCKLineGroupModel groupModelWithDataSource:responseObject[@"datas"]];
            [self.kLineChartView drawChartWithDataSource:groupModel.models];
        }
    } fail:^{
        
    }];
    
    
    
    
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"source.json" ofType:nil];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
//    NSArray *sourceArray = dict[@"data"];
//
//    self.dataSource = [NSArray yy_modelArrayWithClass:[ZKKLineItem class] json:sourceArray];
//    [self.kLineChartView drawChartWithDataSource:self.dataSource];
}

#pragma mark - private methods

- (void)startTimer {
    [self stopTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(realTimeData:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (_timer && [_timer isValid]) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
    _timer = nil;
}

- (void)realTimeData:(id)timer {
}

#pragma mark - getters

- (StatusView *)kStatusView {
    if (!_kStatusView) {
        _kStatusView = [[StatusView alloc] initWithFrame:_kLineChartView.bounds];
    }
    return _kStatusView;
}

- (KLineListTransformer *)lineListTransformer {
    if (!_lineListTransformer) {
        _lineListTransformer = [KLineListTransformer new];
    }
    return _lineListTransformer;
}

- (void)dealloc {
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
