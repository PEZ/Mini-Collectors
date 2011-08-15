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
+ (NSDictionary*)guidesForSeries:(NSInteger)series;
@end

@implementation FeelGuideViewController

static NSDictionary* _guides;

-(id)initWithKey:(NSString*)key {
  if ((self = [super initWithNibName:nil	bundle:nil])) {
    Figure* figure = [Figure figureFromKey:key];
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
		self.title = figure.name;
		
    NSDictionary* guides  = [[self class] guidesForSeries:figure.series];

		NSString *s = [NSString stringWithFormat:@"<img class=\"figureImageRight\" src=\"bundle://%d-%d-320.png\" width=\"57\" height=\"57\" />",
                   figure.series, figure.number];
    s = [NSString stringWithFormat:@"%@To identify the figure inside a \"blind\" package try the following: \
Check the bump codes for a close match. That can often (but not always) help narrowing it down. Combine with feeling the bag closely.<br/><br/>", s];
    s = [NSString stringWithFormat:@"%@<b>Bump codes</b><br/>", s];
    s = [NSString stringWithFormat:@"%@<div><img src=\"bundle://bump-%d-%d.png\" width=\"232\" /></div><br/>", s, figure.series, figure.number];
    s = [NSString stringWithFormat:@"%@<b>Feel tips for %@</b><br/>", s, figure.name];
    s = [NSString stringWithFormat:@"%@<i>Special items: %@.</i><br/>", s,
         [[[guides objectForKey:@"figures"] objectForKey:figure.key] objectForKey:@"items"]];
    s = [NSString stringWithFormat:@"%@%@<br/><br/>", s,
         [[[guides objectForKey:@"figures"] objectForKey:figure.key] objectForKey:@"guide"]];
    s = [NSString stringWithFormat:@"%@<b>General feel tips</b><br/>", s];
    s = [NSString stringWithFormat:@"%@%@", s, [[guides objectForKey:@"general"] objectForKey:@"guide"]];
    TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];
    [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:s]]];
    self.dataSource = dataSource;
  }
  return self;
}

+ (NSDictionary*)guidesForSeries:(NSInteger)series {
  if (_guides == nil) {
    NSString *bundlePathofPlist = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"feel-guide-%d", series] ofType:@"plist"];
    _guides = [[NSDictionary dictionaryWithContentsOfFile:bundlePathofPlist] retain];
  }
  return _guides;
}

@end
