//
//  HADatePicker.m
//  HaidoraDatePicker
//
//  Created by DaiLingchi on 14-8-22.
//  Copyright (c) 2014年 Haidora. All rights reserved.
//

#import "HADatePicker.h"

@interface HADatePicker ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *datePickerView;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateComponents *dateComp;
@property (nonatomic, strong) NSCalendar *gregorian;

//data
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;
@property (nonatomic, assign) NSInteger second;

@end

@implementation HADatePicker

@synthesize date = _date;

#pragma mark
#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
	{
        [self commonInit];
    }
    return self;
}

-(void)commonInit
{
	_dateFormatter = [[NSDateFormatter alloc]init];
	_dateComp = [[NSDateComponents alloc]init];
	_gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	_datePickerView = [[UIPickerView alloc]initWithFrame:self.bounds];
	_datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_datePickerView.showsSelectionIndicator = YES;
	_datePickerView.dataSource = self;
	_datePickerView.delegate = self;
	[self addSubview:_datePickerView];
	self.date = [NSDate date];
}

-(void)setDate:(NSDate *)date
{
	_date = date;
	
	[_dateFormatter setDateFormat:@"yyyy"];
	_year = [[_dateFormatter stringFromDate:_date] integerValue];
	
	[_dateFormatter setDateFormat:@"MM"];
	_month = [[_dateFormatter stringFromDate:_date] integerValue];
	
	[_dateFormatter setDateFormat:@"dd"];
	_day = [[_dateFormatter stringFromDate:_date] integerValue];
	
	[_dateFormatter setDateFormat:@"HH"];
	_hour = [[_dateFormatter stringFromDate:_date] integerValue];
	
	[_dateFormatter setDateFormat:@"mm"];
	_minute = [[_dateFormatter stringFromDate:_date] integerValue];
	
	[_dateFormatter setDateFormat:@"ss"];
	_second = [[_dateFormatter stringFromDate:_date] integerValue];
	
	[_datePickerView selectRow:(_year-1970) inComponent:0 animated:NO];
	[_datePickerView selectRow:(_month-1) inComponent:1 animated:NO];
	[_datePickerView selectRow:(_day-1) inComponent:2 animated:NO];
	[_datePickerView selectRow:(_hour-1) inComponent:3 animated:NO];
	[_datePickerView selectRow:(_minute-1) inComponent:4 animated:NO];
	[_datePickerView selectRow:(_second-1) inComponent:5 animated:NO];
}

-(NSDate *)date
{
	[_dateComp setYear:_year];
	[_dateComp setMonth:_month];
	[_dateComp setDay:_day];
	[_dateComp setHour:_hour];
	[_dateComp setMinute:_minute];
	[_dateComp setSecond:_second];
	
	return [_gregorian dateFromComponents:_dateComp];
}

#pragma mark
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger count = 0;
	//year
	if (component == 0)
	{
		count = (2051-1970);
	}
	//month
	else if(component == 1)
	{
		count = 12;
	}
	//day
	else if (component == 2)
	{
		if (_month == 1 || _month == 3 || _month == 5 ||
			_month == 7 || _month == 8 || _month == 10 ||
			_month == 12)
		{
			count = 31;
		}
		else if( _month == 2)
		{
			if (((_year%4 == 0)&&(_year%100 != 0))||(_year%400 == 0))
			{
				count = 29;
			}
			else
			{
				count = 28;
			}
		}
		else
		{
			count = 30;
		}
	}
	else if (component == 3)
	{
		count = 24;
	}
	else if (component == 4)
	{
		count = 60;
	}
	else if (component == 5)
	{
		count = 60;
	}
	return count;
}

#pragma mark
#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGRect rect = CGRectMake(0, 0, 70, 40);
    if (component == 0) {
        rect.size.width = 70;
    }else{
        rect.size.width = 40;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:rect];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title = @"";
	if (component == 0)
	{
		title = [NSString stringWithFormat:@"%d年",(1970+row)];
	}
	//month
	else if(component == 1)
	{
		title = [NSString stringWithFormat:@"%d月",(1+row)];
	}
	//day
	else if (component == 2)
	{
		title = [NSString stringWithFormat:@"%d日",(1+row)];
	}
	else if (component == 3)
	{
		title = [NSString stringWithFormat:@"%d时",(1+row)];
	}
	else if (component == 4)
	{
		title = [NSString stringWithFormat:@"%d分",(1+row)];
	}
	else if (component == 5)
	{
		title = [NSString stringWithFormat:@"%d秒",(1+row)];
	}
	return title;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat width = 0;
	if (component == 0)
	{
		width = 70;
	}
	else
	{
		width = 40;
	}
	return width;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (component == 0)
	{
		_year = 1970 + row;
	}
	//month
	else if(component == 1)
	{
		_month = 1 + row;
	}
	//day
	else if (component == 2)
	{
		_day = 1 + row;
	}
	else if (component == 3)
	{
		_hour = 1 + row;
	}
	else if (component == 4)
	{
		_minute = 1 + row;
	}
	else if (component == 5)
	{
		_second = 1 + row;
	}
	[pickerView reloadAllComponents];
	
	_year = [pickerView selectedRowInComponent:0] + 1970;
	_month = [pickerView selectedRowInComponent:1] + 1;
	_day = [pickerView selectedRowInComponent:2] + 1;
	_hour = [pickerView selectedRowInComponent:3] + 1;
	_minute = [pickerView selectedRowInComponent:4] + 1;
	_second = [pickerView selectedRowInComponent:5] + 1;
	
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
