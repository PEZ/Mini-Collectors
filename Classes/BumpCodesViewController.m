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
	uint count = [[Figure figureFromSeries:series withNum:[n intValue]] count];
  [dataSource.items addObject:
			 [TTTableStyledTextItem itemWithText:
				[TTStyledText textFromXHTML:
				 [NSString stringWithFormat:@"<img src=\"bundle://bump-%d-%@.png\" width=\"232\" height=\"30\"/>%@", series, n,
					count > 0 ? [NSString stringWithFormat:@" <b>(%d)</b>", count] : @""]]
																			 URL:[NSString stringWithFormat:@"mc://hidden/%d-%@", series, n]]];
}

-(id)initWithSeries:(NSInteger)series {
  if (self = [super initWithNibName:nil	bundle:nil]) {
    self.autoresizesForKeyboard = YES;
    self.variableHeightRows = YES;
		self.title = @"Bump Codes";
		
		NSString *help = [NSString stringWithFormat:@"The Series %d bags are \"bump coded\". Along the <b>bottom seal of the back of the bag</b> \
there are some \"raised\" bumps/dots. <i>They can be really tricky to see, but they are there.</i> \
Match those bumps with the patterns below and tap it. \
(The figures you have already collected are marked as such in the list so that you know what figures you are looking for.)", series];

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
			help = [NSString stringWithFormat:@"%@ Please note that the codes for Series %d are freshly discovered \
and it seems they can differ some between batches. The general advice is to combine the codes with really feeling the bags.", help, series];
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
			
			
		}

		help = @"If you find errors with the codes, please tell me here \
		http://blog.betterthantomorrow.com/2011/03/18/series-4-minifigures-codes-support/";	
		[dataSource.items addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:help lineBreaks:YES URLs:YES] URL:nil]];
		self.dataSource = dataSource;
  }
  return self;
}

@end
