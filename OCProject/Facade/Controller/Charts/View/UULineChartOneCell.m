//
//  UULineChartOneCell.m
//  OCProject
//
//  Created by Pan on 2020/8/4.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UULineChartOneCell.h"
#import "OCProject-Swift.h"
#import <Masonry/Masonry.h>

@interface UULineChartOneCell () <ChartViewDelegate>
{
    LineChartView *_chartView; // 柱状图视图
}
@end

@implementation UULineChartOneCell

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
    _chartView = [[LineChartView alloc] init];
    _chartView.delegate = self;
    _chartView.maxVisibleCount = 60;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.doubleTapToZoomEnabled = NO;
    _chartView.dragEnabled = NO;
    _chartView.scaleXEnabled = NO;
    _chartView.scaleYEnabled = NO;
    _chartView.pinchZoomEnabled = NO;
    _chartView.noDataText = @"暂无数据";
    [_chartView setExtraOffsetsWithLeft:12 top:12 right:12 bottom:12];
    [self.contentView addSubview:_chartView];
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // 图标
    ChartLegend *legend = _chartView.legend;
    legend.form = ChartLegendFormCircle;
    legend.font = [UIFont systemFontOfSize:12];
    legend.textColor = UIColor.lightGrayColor;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = NO;
    ChartLegendEntry *legendEntry = [[ChartLegendEntry alloc] init];
    legendEntry.label = @"图案";
    legend.entries = @[legendEntry];
    
    // 隐藏右Y轴等
    _chartView.rightAxis.enabled = NO;
    _chartView.chartDescription.enabled = NO;
    
    // x轴
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.drawAxisLineEnabled = NO;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:13.f];
    xAxis.labelTextColor = UIColor.blackColor;
    xAxis.axisLineColor = [[UIColor grayColor]colorWithAlphaComponent:0.4];
    xAxis.axisLineWidth = 0.5;
    xAxis.granularity = 1; // 间隔
    xAxis.labelCount = 20;  // 最多显示底部标签个数
    
    // Y轴数据格式
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.minimumIntegerDigits = 0;
    leftAxisFormatter.maximumIntegerDigits = NSIntegerMax;
    leftAxisFormatter.positiveSuffix = @"";
    leftAxisFormatter.positivePrefix = @"+";
    
    // 左边Y轴
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.granularityEnabled = YES;
    leftAxis.labelFont = FONT(10);
    leftAxis.labelTextColor = UIColor.blackColor;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.axisLineColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    leftAxis.gridColor = UIColor.lightGrayColor;
    leftAxis.axisMinimum = 0.0;
    leftAxis.spaceTop = 0.2;
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    
    UUBarChartTwoMarker *marker = [[UUBarChartTwoMarker alloc]
                                   initWithColor:UIColor.blueColor
                                   font: [UIFont systemFontOfSize:12.0]
                                   textColor: UIColor.whiteColor
                                   insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.chartView = _chartView;
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
}

#pragma mark - Setup

// 更新X轴Y轴数据
- (void)setupXValues:(NSArray<NSString *> *)xValues yValues:(NSArray<NSString *> *)yValues {
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    NSMutableArray *yVals3 = [[NSMutableArray alloc] init];
    NSArray *titleArray = @[@"健康食品  ",@"生物科技  ",@"健康评估  "];
    
    NSInteger count = 5;
    for (int i = 0; i < count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@%d", titleArray[0], i];
        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:i data:text]];
    }
    for (int i = 0; i < count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@%d", titleArray[1], i];
        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:i y:i * 2 data:text]];
    }
    for (int i = 0; i < count; i++) {
        NSString *text = [NSString stringWithFormat:@"%@%d", titleArray[2], i];
        [yVals3 addObject:[[ChartDataEntry alloc] initWithX:i y:i * 3 data:text]];
    }
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithEntries:yVals1 label:titleArray[0]];
    set1.axisDependency = AxisDependencyLeft;//以左边标尺
    [set1 setColor:[UIColor blackColor]];
    [set1 setCircleColor:UIColor.whiteColor];
    set1.lineWidth = 1.0;
    set1.circleRadius = 1.0;
    set1.fillAlpha = 65/255.0;
    set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
    set1.highlightColor = UIColor.clearColor;//十字选中线
    set1.drawCircleHoleEnabled = NO;
    set1.drawValuesEnabled = NO;
    set1.mode = LineChartModeHorizontalBezier;
    
    LineChartDataSet *set2 = [[LineChartDataSet alloc] initWithEntries:yVals2 label:titleArray[1]];
    set2.axisDependency = AxisDependencyRight;//以右边标尺
    [set2 setColor:COLOR_HEX(0x2E74E8)];
    [set2 setCircleColor:UIColor.whiteColor];
    set2.lineWidth = 1.0;
    set2.circleRadius = 1.0;
    set2.fillAlpha = 65/255.0;
    set2.fillColor = UIColor.redColor;
    set2.highlightColor = UIColor.clearColor;
    set2.drawCircleHoleEnabled = NO;
    set2.drawValuesEnabled = NO;
    set2.mode = LineChartModeHorizontalBezier;
    
    LineChartDataSet *set3 = [[LineChartDataSet alloc] initWithEntries:yVals3 label:titleArray[2]];
    set3.axisDependency = AxisDependencyRight;//以右边标尺
    [set3 setColor:COLOR_HEX(0x0DC75B)];
    [set3 setCircleColor:UIColor.lightGrayColor];
    set3.lineWidth = 1.0;
    set3.circleRadius = 0.0;
    set3.fillAlpha = 65/255.0;
    set3.fillColor = [UIColor.yellowColor colorWithAlphaComponent:200/255.f];
    set3.highlightColor = UIColor.clearColor;
    set3.drawCircleHoleEnabled = NO;
    set3.drawValuesEnabled = NO;
    set3.mode = LineChartModeHorizontalBezier;
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:@[set1, set2, set3]];
    [data setValueTextColor:UIColor.whiteColor];
    [data setValueFont:[UIFont systemFontOfSize:9.f]];
    
    _chartView.xAxis.valueFormatter = [[UUBarChartTwoFormatter alloc] initWithXValues:xValues];
    _chartView.data = data;
    
    //默认选中的柱张图
    [_chartView highlightValueWithX:yValues.count - 1 y:5 dataSetIndex:0 dataIndex:5];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    
}

@end
