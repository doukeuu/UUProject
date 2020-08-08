//
//  UUPieChartTwoCell.m
//  OCProject
//
//  Created by Pan on 2020/8/4.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUPieChartTwoCell.h"
#import "OCProject-Swift.h"
#import <Masonry/Masonry.h>

@interface UUPieChartTwoCell () <ChartViewDelegate>
{
    PieChartView *_chartView; // 饼图视图
}
@end

@implementation UUPieChartTwoCell

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
    // 饼图视图
    _chartView = [[PieChartView alloc] init];
    _chartView.delegate = self;
    _chartView.rotationAngle = 180.0;
    _chartView.usePercentValuesEnabled = NO;
    _chartView.drawHoleEnabled = NO;
    _chartView.drawEntryLabelsEnabled = NO;
    _chartView.legend.enabled = NO;
    _chartView.rotationEnabled = NO;
    _chartView.highlightPerTapEnabled = YES;
    _chartView.chartDescription.enabled = NO;
    _chartView.noDataText = @"暂无销售额";
    
    // 悬浮视图
    UUPieChartTwoMarker *markerView = [[UUPieChartTwoMarker alloc] initWithFrame:CGRectMake(0, 0, 180, 48)];
    markerView.chartView = _chartView;
    _chartView.marker = markerView;
    
    [self addSubview:_chartView];
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Setup

// 设置数据数组
- (void)setupCountArray:(NSArray<NSString *> *)array {
    if (!array || array.count == 0) return;
    
    NSInteger count = array.count;
    NSInteger emptyCount = 0; // 数值为0的个数
    NSInteger titleCount = self.titles.count;
    NSInteger colorCount = self.colors.count;
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < count; i++) {
        CGFloat value = [array[i] floatValue];
        if (value == 0.0) emptyCount ++;
        NSString *title = @"";
        if (titleCount > 0 && titleCount > i % titleCount) {
            title = [NSString stringWithFormat:@"%@：¥%.2f", self.titles[i % titleCount], value];
        }
        PieChartDataEntry *entry = [[PieChartDataEntry alloc] initWithValue:value label:title];
        entry.x = i;
        [entries addObject:entry];
        if (colorCount > 0 && colorCount > i % colorCount) {
            UIColor *color = self.colors[i % colorCount];
            if (value == 0.0) color = [color colorWithAlphaComponent:0.5];
            [colors addObject:color];
        }
    }
    if (emptyCount == count) { // 数值全部为0时，设置为均等分
        for (PieChartDataEntry *entry in entries) {
            entry.y = 1.0;
        }
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithEntries:entries label:@""];
    dataSet.highlightEnabled = NO; // 设置为NO，防止选中时突出展示
    dataSet.colors = [colors copy];
    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.drawValuesEnabled = NO;
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @"";
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:FONT(14)];
    [data setValueTextColor:UIColor.blackColor];
    _chartView.data = data;
    [_chartView animateWithYAxisDuration:1.0];
    
    [self tapPieChartAt:0];
}

#pragma mark - Respond

// 点击饼图
- (void)tapPieChartAt:(NSInteger)index {
    [_chartView highlightValueWithX:index dataSetIndex:0 dataIndex:0];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight {
    
}

- (void)chartValueNothingSelected:(ChartViewBase *)chartView {
    
}

@end
