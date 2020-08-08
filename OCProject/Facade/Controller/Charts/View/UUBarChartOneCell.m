//
//  UUBarChartOneCell.m
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUBarChartOneCell.h"
#import "OCProject-Swift.h"
#import <Masonry/Masonry.h>

@interface UUBarChartOneCell ()
{
    BarChartView *_chartView; // 柱状图视图
}
@end

@implementation UUBarChartOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self generateSubviews];
    }
    return self;
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 柱状图视图
    _chartView = [[BarChartView alloc] init];
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    _chartView.dragEnabled = NO;
    _chartView.scaleXEnabled = NO;
    _chartView.scaleYEnabled = NO;
    _chartView.noDataText = @"暂无数据";
    _chartView.highlightPerTapEnabled = NO;
    [_chartView setExtraOffsetsWithLeft:12 top:12 right:12 bottom:12];
    [self.contentView addSubview:_chartView];
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 隐藏右Y轴等
    _chartView.legend.enabled = NO;
    _chartView.rightAxis.enabled = NO;
    _chartView.chartDescription.enabled = NO;
    
    // x轴
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:13.f];
    xAxis.drawGridLinesEnabled = NO;
    xAxis.axisLineColor = [UIColor grayColor];
    xAxis.axisLineWidth = 0.5;
    xAxis.granularity = 1; // 间隔
    xAxis.labelCount = 20;  // 最多显示底部标签个数
    xAxis.labelTextColor = UIColor.blackColor;
    
    // 左Y轴
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumIntegerDigits = 0;
    leftAxisFormatter.maximumIntegerDigits = NSIntegerMax;
    leftAxisFormatter.positiveSuffix = @"";
    leftAxisFormatter.positivePrefix = @"";
    
    // 左边标尺
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.axisLineColor = UIColor.blackColor;//Y轴颜色
    leftAxis.labelFont = FONT(14);
    leftAxis.labelCount = 4;
    leftAxis.axisLineColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    leftAxis.gridColor = UIColor.lightGrayColor;
    leftAxis.axisMinimum = 0.0;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
}

#pragma mark - Setup

// 更新X轴Y轴数据
- (void)setupXValues:(NSArray<NSString *> *)xValues yValues:(NSArray<NSString *> *)yValues {
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    for (int i = 0; i < xValues.count; i++){
        double mult = [yValues[i] doubleValue];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:mult];
        [entries addObject:entry];
    }
    
    NSNumberFormatter *dataSetFormatter = [[NSNumberFormatter alloc] init];
    dataSetFormatter.minimumFractionDigits = 0;
    dataSetFormatter.maximumFractionDigits = 100;
    dataSetFormatter.positiveSuffix = @"";
    dataSetFormatter.positivePrefix = @"";
    
    BarChartDataSet *dataSet = [[BarChartDataSet alloc] initWithEntries:entries label:@""];
    dataSet.colors = @[COLOR_HEX(0x6C83FF)];
    dataSet.drawIconsEnabled = YES;
    dataSet.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    dataSet.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:dataSetFormatter];
    
    BarChartData *data = [[BarChartData alloc] initWithDataSet:dataSet];
    [data setValueFont:FONT(16)];
    [data setValueTextColor:UIColor.blackColor];
    data.barWidth = 0.4f;//柱状图宽度
    
    _chartView.xAxis.valueFormatter = [[UUBarChartOneFormatter alloc] initWithXValues:xValues];
    _chartView.data = data;
    
    //默认选中的柱张图
//    [_chartView highlightValueWithX:_dayArray.count - 1 dataSetIndex:0 stackIndex:5];
}

@end
