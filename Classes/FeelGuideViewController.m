//
//  FeelGuideViewController.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-08-14.
//  Copyright 2011 NA. All rights reserved.
//

#import "FeelGuideViewController.h"
#import "Figure.h"

@interface FeelGuideViewController (Private)
- (NSDictionary*)guidesForSeries:(NSInteger)series;
- (NSString*)guideForFigure:(Figure*)figure;
@end

@implementation FeelGuideViewController

-(id)initWithKey:(NSString*)key {
  if ((self = [super initWithNibName:nil	bundle:nil])) {
    Figure* figure = [Figure figureFromKey:key];
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
		self.title = figure.name;
		
		NSString *s = [NSString stringWithFormat:@"<img class=\"figureImageRight\" src=\"bundle://%d-%d-320.png\" width=\"57\" height=\"57\" />",
                   figure.series, figure.number];
    s = [NSString stringWithFormat:@"%@To identify the figure inside a \"blind\" package try the following: \
Check the bump codes for a close match. That can often (but not always) help narrowing it down. Combine with feeling the bag closely.<br/><br/>", s];
    s = [NSString stringWithFormat:@"%@<b>Bump codes</b><br/>", s];
    s = [NSString stringWithFormat:@"%@<div><img src=\"bundle://bump-%d-%d.png\" width=\"232\" /></div><br/>", s, figure.series, figure.number];
    s = [NSString stringWithFormat:@"%@<b>%@ feel tips</b><br/>", s, figure.name];
    s = [NSString stringWithFormat:@"%@%@<br/><br/>", s, [self guideForFigure:figure]];
    s = [NSString stringWithFormat:@"%@<b>General feel tips</b><br/>", s];
    s = [NSString stringWithFormat:@"%@Try to sort out the parts common to most figures: The <b>head</b>, the <b>body</b>, the <b>legs</b> and the <b>stand</b>. ", s];
    s = [NSString stringWithFormat:@"%@It takes just a little bit of training to get good at this. The legs on most figures bend. ", s];
    s = [NSString stringWithFormat:@"%@The arms move. Remember that for some figures some of these \"common\" items are actually interesting or even missing.", s];
    TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
    [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:s]]];
    self.dataSource = dataSource;
  }
  return self;
}

- (NSString*)guideForFigure:(Figure*)figure {
  return [[self guidesForSeries:figure.series] objectForKey:figure.key];
}

- (NSDictionary*)guidesForSeries:(NSInteger)series {
  NSString *bundlePathofPlist = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"feel-guide-%d", series] ofType:@"plist"];
  NSDictionary* guides = [NSDictionary dictionaryWithContentsOfFile:bundlePathofPlist];
  return guides;
}

@end
