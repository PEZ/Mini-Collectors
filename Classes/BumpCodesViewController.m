//
//  BumpCodesViewController.m
//  Mini Collector
//
//  Created by Peter Stromberg on 2011-01-09.
//  Copyright 2011 NA. All rights reserved.
//

#import "BumpCodesViewController.h"
#import "NSMutableArray+Shuffle.h"
#import "Figure.h"

@implementation BumpCodesViewController

-(void)addItemForNumber:(NSNumber*)n forSeries:(NSInteger)series toDataSource:(TTListDataSource*)dataSource {
  Figure* figure = [Figure figureFromSeries:series withNum:[n intValue]];
	uint count = [figure count];
  if (series < 5) {
    [dataSource.items addObject:
     [TTTableStyledTextItem itemWithText:
      [TTStyledText textFromXHTML:
       [NSString stringWithFormat:@"<img src=\"bundle://bump-%d-%@.png\" width=\"232\" />%@", series, n,
        count > 0 ? [NSString stringWithFormat:@" <b>(%d)</b>", count] : @""]]
                                     URL:[NSString stringWithFormat:@"mc://hidden/%d-%@", series, n]]];
  }
  else if (series < 7) {
    [dataSource.items addObject:
     [TTTableStyledTextItem itemWithText:
      [TTStyledText textFromXHTML:
       [NSString stringWithFormat:@"<img class=\"figureTableImage\" src=\"bundle://%d-%@-57.png\" width=\"57\" height=\"57\" /><div class=\"tableMessageContent\"><b>%@%@</b><br/><img src=\"bundle://bump-%d-%@.png\" width=\"232\" /></div>",
        series, n,
        figure.name, count > 0 ? [NSString stringWithFormat:@" (%d)", count] : @"",
        series, n]]
                                     URL:[NSString stringWithFormat:@"mc://feel_guide/%d-%@", series, n]]];    
  }
}

-(id)initWithSeries:(NSInteger)series {
  if ((self = [super initWithNibName:nil	bundle:nil])) {
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
		self.title = @"Bump Codes";
		
		NSString *help = [NSString stringWithFormat:@"The Series %d bags are \"bump coded\". Along the <b>bottom seal of the back of the bag</b> \
there are some \"raised\" bumps/dots. <i>They can be really tricky to see, but they are there.</i> \
Match those bumps with the patterns below and tap it. Watch out for when the seal is cut too tightly:\n\
<img src=\"bundle://Seal-cut.png\" heigt=\"136\" width=\"297\" />", series];

    TTListDataSource* dataSource = [[[TTListDataSource alloc] init] autorelease];

		NSMutableArray* nonTrickies = [NSMutableArray arrayWithCapacity:16];
		for (int i = 1; i < 17; i++) {
			[nonTrickies addObject:N(i)];
		}

		if (series == 3) {
			NSArray* trickies1 = [NSArray arrayWithObjects:N(2), N(7), N(13), nil];
			NSArray* trickies2 = [NSArray arrayWithObjects:N(4), N(12), N(3), N(16), N(8), N(10), N(11), nil];
			[nonTrickies removeObjectsInArray:trickies1];
			[nonTrickies removeObjectsInArray:trickies2];
			
			for (NSNumber* n in nonTrickies) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}
			[dataSource.items shuffle];
			
			[dataSource.items insertObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil] atIndex:0];
			
			help = @"The patterns can be pretty similar. Watch out for the following codes. \
Consider tapping and choose to <b>Reveal</b> and combine with feeling the bag to maximize your chanses of getting it right.";	
			[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
			for (NSNumber* n in trickies2) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}		
			
			help = @"Some of the patterns are <b>extra</b> tricky. They are grouped together below and \
represent the <b>Gorilla</b>, the <b>Indian Chief</b>, and the <b>Samurai</b>. In that order.";	
			[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
			for (NSNumber* n in trickies1) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}		
		}
		if (series == 4) {
			NSArray* trickies1 = [NSArray arrayWithObjects:N(5), N(6), N(8), N(1), N(11), N(2), N(12), nil];
			[nonTrickies removeObjectsInArray:trickies1];

			for (NSNumber* n in nonTrickies) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}
			[dataSource.items insertObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil] atIndex:0];

			help = @"The patterns can be very similar. Watch out for the following codes. \
Consider tapping and choose to <b>Reveal</b> and combine with feeling the bag to maximize \
your chanses of getting it right. <a href=\"http://www.mocpages.com/moc.php/259838\">Here's a complete Series 4 feeling guide</a>.";	
			[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
			for (NSNumber* n in trickies1) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}		
						
      help = @"If you find errors with the codes, please tell me here \
      http://blog.betterthantomorrow.com/2011/03/18/series-4-minifigures-codes-support/";	
      [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
		}

		if (series == 5) {
			for (NSNumber* n in nonTrickies) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}
      
      help = @"The bump codes for Series 5 are quite unreliable. Be adviced that: \
<i>Feeling the bag is often necessary.</i> Use the bump codes  below to try narrow it down. Feel the bag. Attached to \
each figure below is a \"feel guide\" that aims to help you identify what's in that bag. <b>Good luck!</b>";

			[dataSource.items insertObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil] atIndex:0];
      
			/*
       help = @"The patterns can be very similar. Watch out for the following codes. \
      Consider tapping and choose to <b>Reveal</b> and combine with feeling the bag to maximize \
      your chanses of getting it right. <a href=\"http://www.mocpages.com/moc.php/259838\">Here's a complete Series 4 feeling guide</a>.";	
			[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
			for (NSNumber* n in trickies1) {
				[self addItemForNumber:n forSeries:series toDataSource:dataSource];
			}
       */
			
			
      help = @"Watch out for when the seal is cut too tightly:\n\
              <img src=\"bundle://Seal-cut.png\" heigt=\"136\" width=\"297\" />";      
			[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];

      help = @"If you find errors with the codes, please tell me here; http://is.gd/series5";	
      [dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
		}

		self.dataSource = dataSource;
  }
  return self;
}

@end
