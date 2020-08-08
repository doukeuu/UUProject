//
//  UUPieChartOneCell.m
//  OCProject
//
//  Created by Pan on 2020/8/3.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUPieChartOneCell.h"
#import "OCProject-Swift.h"
#import <Masonry/Masonry.h>

@interface UUPieChartOneCell () <ChartViewDelegate>
{
    NSArray *_titleArray;     // 名称数组
    NSArray *_colorArray;     // 颜色数组
    PieChartView *_chartView; // 饼图视图
}
@end

@implementation UUPieChartOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self commonInitialize];
        [self generateSubviews];
    }
    return self;
}

// 初始化属性
- (void)commonInitialize {
    _titleArray = @[@"安装", @"维修", @"维护", @"移机", @"退机"];
    _colorArray = @[COLOR_HEX(0x8249FF), COLOR_HEX(0xFFA80D), COLOR_HEX(0xFF3C64),
                    COLOR_HEX(0x0DDA0D), COLOR_HEX(0x0D7BFF)];
}

#pragma mark - Subviews

// 生成子视图
- (void)generateSubviews {
    // 饼图视图
    _chartView = [[PieChartView alloc] init];
    _chartView.delegate = self;
    _chartView.rotationAngle = 180.0; //  竖线左旋180度
    _chartView.usePercentValuesEnabled = NO; // 不使用百分比
    _chartView.drawHoleEnabled = YES; // 中间有圆圈
    _chartView.holeRadiusPercent = 0.43; // 圆圈百分比
    _chartView.transparentCircleRadiusPercent = 0.43; // 半透明圆圈百分比
    _chartView.drawCenterTextEnabled = YES;
    _chartView.centerText = @"10\n测试文字";
    _chartView.drawEntryLabelsEnabled = NO; // 不展示X值，entry的label值
    _chartView.legend.enabled = NO; // 不展示图例
    _chartView.rotationEnabled = NO; // 不可手动旋转
    _chartView.highlightPerTapEnabled = YES; // 点击高亮
    _chartView.chartDescription.enabled = NO; // 不展示图例描述
    _chartView.noDataText = @"暂无销售额"; // 空白占位字符
    _chartView.renderer = [[UUPieChartOneRenderer alloc] initWithChart:_chartView // 自定义渲染类
                                                           animator:_chartView.chartAnimator
                                                    viewPortHandler:_chartView.viewPortHandler];
    [_chartView setExtraOffsetsWithLeft:12 top:18 right:12 bottom:12]; // 饼图大小内边距
    [self addSubview:_chartView];
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
}

#pragma mark - Setup

// 设置数据数组
- (void)setupCountArray:(NSArray<NSString *> *)array {
    if (!array || array.count == 0) return;
    
    NSInteger count = array.count;
    NSInteger emptyCount = 0; // 数值为0的个数
    NSInteger titleCount = _titleArray.count;
    NSInteger colorCount = _colorArray.count;
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < count; i++) {
        CGFloat value = [array[i] floatValue];
        if (value == 0.0) emptyCount ++;
        NSString *title = @"";
        if (titleCount > 0 && titleCount > i % titleCount) {
            title = [NSString stringWithFormat:@"%@%.0f", _titleArray[i % titleCount], value];
        }
        PieChartDataEntry *entry = [[PieChartDataEntry alloc] initWithValue:value label:title];
        entry.x = i;
        [entries addObject:entry];
        if (colorCount > 0 && colorCount > i % colorCount) {
            UIColor *color = _colorArray[i % colorCount];
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
    dataSet.drawValuesEnabled = YES;
    dataSet.colors = [colors copy];
    dataSet.valueColors = [colors copy];
    dataSet.valueLinePart1OffsetPercentage = 1.1;
    dataSet.valueLinePart1Length = 0.8;
    dataSet.valueLinePart2Length = 1.0;
    dataSet.xValuePosition = PieChartValuePositionInsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.entryLabelFont = FONT(10);
    dataSet.entryLabelColor = UIColor.whiteColor;
    dataSet.useValueColorForLine = YES;
    dataSet.valueLineVariableLength = NO;
    
    ChartDefaultValueFormatter *dFormatter = [ChartDefaultValueFormatter withBlock:^NSString * _Nonnull(double value, ChartDataEntry * _Nonnull entry, NSInteger dataSetIndex, ChartViewPortHandler * _Nullable viewPortHandler) {
        
        PieChartDataEntry *pieEntry = (PieChartDataEntry *)entry;
        return pieEntry.label;
    }];
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setValueFormatter:dFormatter];
    [data setValueFont:FONT(14)];
    _chartView.data = data;
//    [_chartView animateWithYAxisDuration:1.0];
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
