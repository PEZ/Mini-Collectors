//
//  Figure.m
//  Mini Collector
//
//  Created by PEZ on 2010-08-24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Figure.h"
#import "AppDelegate.h"

#define kArchiveFile @"Figures.archive"

@implementation Figure

@synthesize series = _series;
@synthesize key = _key;
@synthesize count = _count;
@synthesize name = _name;
@synthesize launcherItem = _launcherItem;

static NSDictionary *_figures;

- (Figure *) initFromDict:(NSDictionary *)dict {
  if ((self = [super init])) {
    self.series = [[dict objectForKey:@"series"] intValue];
    self.key = [dict objectForKey:@"key"];
    self.count = [[dict objectForKey:@"count"] intValue];
    self.name = [dict objectForKey:@"name"];
  }
  return self;
}

-(void)dealloc {
	TT_RELEASE_SAFELY(_launcherItem);
	TT_RELEASE_SAFELY(_name);
	TT_RELEASE_SAFELY(_key);
	[super dealloc];
}

- (void) countChanged {
  self.launcherItem.badgeNumber = self.count;
  [Figure saveFigures];
}

- (NSString *) achievmentIdentifier {
  return [NSString stringWithFormat:@"F_%@", [self.key stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
}

- (NSInteger)number {
  return [[[self.key componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue];
}

- (NSArray *) incrementSeriesAchievments:(int)s isInteractive:(BOOL)isInteractive {
  NSMutableArray *achievements = [[[NSMutableArray alloc] initWithCapacity:2] autorelease];
  NSString *thisSeriesId = [NSString stringWithFormat:@"S%d", s];
  GKAchievement *thisSeriesAchievement = [[AppDelegate getInstance] getAchievementForIdentifier:thisSeriesId];
  float percentThisSeries = thisSeriesAchievement.percentComplete;
  if (percentThisSeries < 100.0) {
    thisSeriesAchievement.percentComplete = percentThisSeries + 100.0/15.999999;
    [achievements addObject:thisSeriesAchievement];
    if (thisSeriesAchievement.percentComplete >= 100.0) {
			for (int numSeries = 2; numSeries <= kTotalSeries; numSeries++) {
				GKAchievement *achievementXS = [[AppDelegate getInstance] getAchievementForIdentifier:[NSString stringWithFormat:@"%dS", numSeries]];
				float percentXS = achievementXS.percentComplete;
				if (percentXS < 100.0) {
					achievementXS.percentComplete = percentXS + 100.0/(numSeries - 0.0000001);
					[achievements addObject:achievementXS];
				}
			}
    }
  }
  return achievements;
}

- (void) incrementSpree:(int)goalCount result:(NSMutableArray *)achievements isInteractive:(BOOL)isInteractive  {
  GKAchievement *a = [[AppDelegate getInstance] getAchievementForIdentifier:[NSString stringWithFormat:@"%dF", goalCount]];
  float percent = a.percentComplete;
  if (percent < 100.0) {
    a.percentComplete = percent + 100.0/(goalCount - 0.000001);
    [achievements addObject:a];
  }
}
- (NSArray *) incrementFigureSpreeAchievments:(BOOL)isInteractive {
  NSMutableArray *achievements = [[[NSMutableArray alloc] initWithCapacity:3] autorelease];
  [self incrementSpree:10 result:achievements isInteractive:isInteractive];
  [self incrementSpree:25 result:achievements isInteractive:isInteractive];
  [self incrementSpree:40 result:achievements isInteractive:isInteractive];
  [self incrementSpree:50 result:achievements isInteractive:isInteractive];
  return achievements;
}

- (NSArray *) reportAchievements:(BOOL)isInteractive {
  NSMutableArray *achievements = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
  float percentComplete = [[AppDelegate getInstance] getAchievementForIdentifier:[self achievmentIdentifier]].percentComplete;
  if (percentComplete < 100.0) {
    [[AppDelegate getInstance] reportAchievementIdentifier:[self achievmentIdentifier] percentComplete:100.0];
    [achievements addObjectsFromArray:[self incrementFigureSpreeAchievments:isInteractive]];
    [achievements addObjectsFromArray:[self incrementSeriesAchievments:self.series isInteractive:isInteractive]];
  }
  return achievements;
}

- (void) increaseCount {
  self.count++;
  [self countChanged];
  if ([AppDelegate isGameCenterAvailable]) {
    for (GKAchievement *a in [self reportAchievements:YES]) {
      [[AppDelegate getInstance] reportAchievementIdentifier:a.identifier percentComplete:a.percentComplete];
    }
  }
}

- (void) decreaseCount {
  self.count = self.count == 0 ? 0 : self.count - 1;
  [self countChanged];
}

+ (NSString *) archivePath {
  AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
  return [[delegate applicationDocumentsDirectory] stringByAppendingPathComponent:kArchiveFile];
}

+ (Figure *) figureFromKey:(NSString *)key {
  return [[self figures] objectForKey:key];
}

+ (Figure *) figureFromSeries:(uint)series withNum:(uint)num {
	return [self figureFromKey:[NSString stringWithFormat:@"%d-%d", series, num]];
}

+ (Figure *) figureFromDict:(NSDictionary *)dict {
  return [[self alloc] initFromDict:dict];
}

+ (NSDictionary *) figures {
  return _figures;
}

+ (void) saveFigures {
  BOOL result = [NSKeyedArchiver archiveRootObject:_figures toFile:[self archivePath]];
  if (!result) {
    DLog(@"FAIL: Saving figures to %@", [self archivePath]);
  }
}

+ (NSDictionary *) s3_figures {
	NSNumber *zero = [NSNumber numberWithInt: 0];
	NSNumber *three = [NSNumber numberWithInt: 3];
	return [NSDictionary dictionaryWithObjectsAndKeys:
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-1", @"key", @"Hula Girl", @"name", zero, @"count", nil]] retain], @"3-1",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-2", @"key", @"Gorilla", @"name", zero, @"count", nil]] retain], @"3-2",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-3", @"key", @"Baseball Player", @"name", zero, @"count", nil]] retain], @"3-3",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-4", @"key", @"Tennis Player", @"name", zero, @"count", nil]] retain], @"3-4",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-5", @"key", @"Elf", @"name", zero, @"count", nil]] retain], @"3-5",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-6", @"key", @"Street Punk", @"name", zero, @"count", nil]] retain], @"3-6",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-7", @"key", @"Tribal Chief", @"name", zero, @"count", nil]] retain], @"3-7",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-8", @"key", @"Alien", @"name", zero, @"count", nil]] retain], @"3-8",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-9", @"key", @"Pilot", @"name", zero, @"count", nil]] retain], @"3-9",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-10", @"key", @"Mummy", @"name", zero, @"count", nil]] retain], @"3-10",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-11", @"key", @"Fisherman", @"name", zero, @"count", nil]] retain], @"3-11",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-12", @"key", @"Snowboarder", @"name", zero, @"count", nil]] retain], @"3-12",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-13", @"key", @"Samurai", @"name", zero, @"count", nil]] retain], @"3-13",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-14", @"key", @"Racecar Driver", @"name", zero, @"count", nil]] retain], @"3-14",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-15", @"key", @"Cyborg", @"name", zero, @"count", nil]] retain], @"3-15",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 three, @"series", @"3-16", @"key", @"Sumo Wrestler", @"name", zero, @"count", nil]] retain], @"3-16",
					nil];
}

+ (NSDictionary *) s4_figures {
	NSNumber *zero = [NSNumber numberWithInt: 0];
	NSNumber *four = [NSNumber numberWithInt: 4];
	return [NSDictionary dictionaryWithObjectsAndKeys:
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-1", @"key", @"Artist", @"name", zero, @"count", nil]] retain], @"4-1",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-2", @"key", @"Soccer Player", @"name", zero, @"count", nil]] retain], @"4-2",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-3", @"key", @"The Monster", @"name", zero, @"count", nil]] retain], @"4-3",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-4", @"key", @"Kimono Girl", @"name", zero, @"count", nil]] retain], @"4-4",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-5", @"key", @"Lawn Gnome", @"name", zero, @"count", nil]] retain], @"4-5",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-6", @"key", @"Hockey Player", @"name", zero, @"count", nil]] retain], @"4-6",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-7", @"key", @"Ice Skater", @"name", zero, @"count", nil]] retain], @"4-7",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-8", @"key", @"Musketeer", @"name", zero, @"count", nil]] retain], @"4-8",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-9", @"key", @"Punk Rocker", @"name", zero, @"count", nil]] retain], @"4-9",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-10", @"key", @"Sailor", @"name", zero, @"count", nil]] retain], @"4-10",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-11", @"key", @"Crazy Scientist", @"name", zero, @"count", nil]] retain], @"4-11",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-12", @"key", @"Street Skater", @"name", zero, @"count", nil]] retain], @"4-12",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-13", @"key", @"Surfer Girl", @"name", zero, @"count", nil]] retain], @"4-13",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-14", @"key", @"Hazmat Guy", @"name", zero, @"count", nil]] retain], @"4-14",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-15", @"key", @"Viking", @"name", zero, @"count", nil]] retain], @"4-15",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 four, @"series", @"4-16", @"key", @"Werewolf", @"name", zero, @"count", nil]] retain], @"4-16",
					nil];
}

+ (NSDictionary *) s5_figures {
	NSNumber *zero = [NSNumber numberWithInt: 0];
	NSNumber *five = [NSNumber numberWithInt: 5];
	return [NSDictionary dictionaryWithObjectsAndKeys:
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-1", @"key", @"Boxer", @"name", zero, @"count", nil]] retain], @"5-1",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-2", @"key", @"Cave Woman", @"name", zero, @"count", nil]] retain], @"5-2",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-3", @"key", @"Egyptian Queen", @"name", zero, @"count", nil]] retain], @"5-3",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-4", @"key", @"Small Clown", @"name", zero, @"count", nil]] retain], @"5-4",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-5", @"key", @"Evil Dwarf", @"name", zero, @"count", nil]] retain], @"5-5",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-6", @"key", @"Ice Fisherman", @"name", zero, @"count", nil]] retain], @"5-6",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-7", @"key", @"Fitness Instructor", @"name", zero, @"count", nil]] retain], @"5-7",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-8", @"key", @"Gangster", @"name", zero, @"count", nil]] retain], @"5-8",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-9", @"key", @"Gladiator", @"name", zero, @"count", nil]] retain], @"5-9",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-10", @"key", @"Graduate", @"name", zero, @"count", nil]] retain], @"5-10",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-11", @"key", @"Lizard Man", @"name", zero, @"count", nil]] retain], @"5-11",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-12", @"key", @"Lumberjack", @"name", zero, @"count", nil]] retain], @"5-12",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-13", @"key", @"Royal Guard", @"name", zero, @"count", nil]] retain], @"5-13",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-14", @"key", @"Detective", @"name", zero, @"count", nil]] retain], @"5-14",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-15", @"key", @"Snowboarder Guy", @"name", zero, @"count", nil]] retain], @"5-15",
					[[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
																	 five, @"series", @"5-16", @"key", @"Zookeeper", @"name", zero, @"count", nil]] retain], @"5-16",
					nil];
}

+ (NSDictionary *) s6_figures {
  NSNumber *zero = [NSNumber numberWithInt: 0];
  NSNumber *six = [NSNumber numberWithInt: 6];
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-1", @"key", @"Flamenco Dancer", @"name", zero, @"count", nil]] retain], @"6-1",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-2", @"key", @"Lady Liberty", @"name", zero, @"count", nil]] retain], @"6-2",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-3", @"key", @"Clockwork Robot", @"name", zero, @"count", nil]] retain], @"6-3",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-4", @"key", @"Sleepyhead", @"name", zero, @"count", nil]] retain], @"6-4",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-5", @"key", @"Surgeon", @"name", zero, @"count", nil]] retain], @"6-5",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-6", @"key", @"Skater Girl", @"name", zero, @"count", nil]] retain], @"6-6",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-7", @"key", @"Mechanic", @"name", zero, @"count", nil]] retain], @"6-7",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-8", @"key", @"Butcher", @"name", zero, @"count", nil]] retain], @"6-8",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-9", @"key", @"Intergalactic Girl", @"name", zero, @"count", nil]] retain], @"6-9",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-10", @"key", @"Leprechaun", @"name", zero, @"count", nil]] retain], @"6-10",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-11", @"key", @"Genie", @"name", zero, @"count", nil]] retain], @"6-11",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-12", @"key", @"Classic Alien", @"name", zero, @"count", nil]] retain], @"6-12",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-13", @"key", @"Bandit", @"name", zero, @"count", nil]] retain], @"6-13",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-14", @"key", @"Minotaur", @"name", zero, @"count", nil]] retain], @"6-14",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-15", @"key", @"Highland Battler", @"name", zero, @"count", nil]] retain], @"6-15",
          [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                   six, @"series", @"6-16", @"key", @"Roman Soldier", @"name", zero, @"count", nil]] retain], @"6-16",
          nil];
}

+ (NSDictionary *) s7_figures {
    NSNumber *zero = [NSNumber numberWithInt: 0];
    NSNumber *seven = [NSNumber numberWithInt: 7];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-1", @"key", @"Aztec Warrior", @"name", zero, @"count", nil]] retain], @"7-1",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-2", @"key", @"Bagpiper", @"name", zero, @"count", nil]] retain], @"7-2",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-3", @"key", @"Bride", @"name", zero, @"count", nil]] retain], @"7-3",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-4", @"key", @"Bunny Suite Guy", @"name", zero, @"count", nil]] retain], @"7-4",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-5", @"key", @"Dare Devil", @"name", zero, @"count", nil]] retain], @"7-5",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-6", @"key", @"Evil Knight", @"name", zero, @"count", nil]] retain], @"7-6",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-7", @"key", @"Computer Programmer", @"name", zero, @"count", nil]] retain], @"7-7",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-8", @"key", @"Hippie", @"name", zero, @"count", nil]] retain], @"7-8",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-9", @"key", @"Ocean King", @"name", zero, @"count", nil]] retain], @"7-9",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-10", @"key", @"Grandma Visitor", @"name", zero, @"count", nil]] retain], @"7-10",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-11", @"key", @"Rocker Girl", @"name", zero, @"count", nil]] retain], @"7-11",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-12", @"key", @"Galaxy Patrol", @"name", zero, @"count", nil]] retain], @"7-12",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-13", @"key", @"Swimming Champion", @"name", zero, @"count", nil]] retain], @"7-13",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-14", @"key", @"Jungle Boy", @"name", zero, @"count", nil]] retain], @"7-14",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-15", @"key", @"Tennis Ace", @"name", zero, @"count", nil]] retain], @"7-15",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     seven, @"series", @"7-16", @"key", @"Viking Woman", @"name", zero, @"count", nil]] retain], @"7-16",
            nil];
}
            
+ (NSDictionary *) s8_figures {
    NSNumber *zero = [NSNumber numberWithInt: 0];
    NSNumber *eight = [NSNumber numberWithInt: 8];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-1", @"key", @"Actor", @"name", zero, @"count", nil]] retain], @"8-1",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-2", @"key", @"Pirate Captain", @"name", zero, @"count", nil]] retain], @"8-2",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-3", @"key", @"Conquistador", @"name", zero, @"count", nil]] retain], @"8-3",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-4", @"key", @"Evil Robot", @"name", zero, @"count", nil]] retain], @"8-4",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-5", @"key", @"Alien Villainess", @"name", zero, @"count", nil]] retain], @"8-5",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-6", @"key", @"Diver", @"name", zero, @"count", nil]] retain], @"8-6",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-7", @"key", @"Vampire Bat", @"name", zero, @"count", nil]] retain], @"8-7",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-8", @"key", @"Fairy", @"name", zero, @"count", nil]] retain], @"8-8",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-9", @"key", @"Football Player", @"name", zero, @"count", nil]] retain], @"8-9",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-10", @"key", @"Businessman", @"name", zero, @"count", nil]] retain], @"8-10",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-11", @"key", @"Downhill Skier", @"name", zero, @"count", nil]] retain], @"8-11",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-12", @"key", @"Red Cheerleader", @"name", zero, @"count", nil]] retain], @"8-12",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-13", @"key", @"Santa", @"name", zero, @"count", nil]] retain], @"8-13",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-14", @"key", @"Lederhosen Guy", @"name", zero, @"count", nil]] retain], @"8-14",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-15", @"key", @"DJ", @"name", zero, @"count", nil]] retain], @"8-15",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     eight, @"series", @"8-16", @"key", @"Cowgirl", @"name", zero, @"count", nil]] retain], @"8-16",
            nil];
}

+ (NSDictionary *) s9_figures {
    NSNumber *zero = [NSNumber numberWithInt: 0];
    NSNumber *nine = [NSNumber numberWithInt: 9];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-1", @"key", @"Hollywood Starlet", @"name", zero, @"count", nil]] retain], @"9-1",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-2", @"key", @"Roman Emperor", @"name", zero, @"count", nil]] retain], @"9-2",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-3", @"key", @"Alien Avenger", @"name", zero, @"count", nil]] retain], @"9-3",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-4", @"key", @"Forest Maiden", @"name", zero, @"count", nil]] retain], @"9-4",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-5", @"key", @"Plumber", @"name", zero, @"count", nil]] retain], @"9-5",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-6", @"key", @"Mermaid", @"name", zero, @"count", nil]] retain], @"9-6",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-7", @"key", @"Battle Mech", @"name", zero, @"count", nil]] retain], @"9-7",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-8", @"key", @"Roller Derby Girl", @"name", zero, @"count", nil]] retain], @"9-8",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-9", @"key", @"Mr. Good and Evil", @"name", zero, @"count", nil]] retain], @"9-9",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-10", @"key", @"Fortune Teller", @"name", zero, @"count", nil]] retain], @"9-10",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-11", @"key", @"Judge", @"name", zero, @"count", nil]] retain], @"9-11",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-12", @"key", @"Chicken Suit Guy", @"name", zero, @"count", nil]] retain], @"9-12",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-13", @"key", @"Policeman", @"name", zero, @"count", nil]] retain], @"9-13",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-14", @"key", @"Waiter", @"name", zero, @"count", nil]] retain], @"9-14",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-15", @"key", @"Heroic Knight", @"name", zero, @"count", nil]] retain], @"9-15",
            [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                                     nine, @"series", @"9-16", @"key", @"Cyclops", @"name", zero, @"count", nil]] retain], @"9-16",
            nil];
}


+ (void) resetFigures {
  NSNumber *zero = [NSNumber numberWithInt: 0];
	NSNumber *one = [NSNumber numberWithInt: 1];
	NSNumber *two = [NSNumber numberWithInt: 2];
    NSMutableDictionary *figures =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-1", @"key", @"Robot", @"name", zero, @"count", nil]] retain], @"1-1",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-2", @"key", @"Zombie", @"name", zero, @"count", nil]] retain], @"1-2",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-3", @"key", @"Ninja", @"name", zero, @"count", nil]] retain], @"1-3",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-4", @"key", @"Deep Sea Diver", @"name", zero, @"count", nil]] retain], @"1-4",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-5", @"key", @"Space Man", @"name", zero, @"count", nil]] retain], @"1-5",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-6", @"key", @"Forestman", @"name", zero, @"count", nil]] retain], @"1-6",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-7", @"key", @"Cowboy", @"name", zero, @"count", nil]] retain], @"1-7",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-8", @"key", @"Tribal Hunter", @"name", zero, @"count", nil]] retain], @"1-8",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-9", @"key", @"Magician", @"name", zero, @"count", nil]] retain], @"1-9",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-10", @"key", @"Wrestler", @"name", zero, @"count", nil]] retain], @"1-10",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-11", @"key", @"Cheerleader", @"name", zero, @"count", nil]] retain], @"1-11",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-12", @"key", @"Circus Clown", @"name", zero, @"count", nil]] retain], @"1-12",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-13", @"key", @"Demolition Dummy", @"name", zero, @"count", nil]] retain], @"1-13",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-14", @"key", @"Caveman", @"name", zero, @"count", nil]] retain], @"1-14",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-15", @"key", @"Skater", @"name", zero, @"count", nil]] retain], @"1-15",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              one, @"series", @"1-16", @"key", @"Nurse", @"name", zero, @"count", nil]] retain], @"1-16",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-1", @"key", @"Pharaoh", @"name", zero, @"count", nil]] retain], @"2-1",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-2", @"key", @"Vampire", @"name", zero, @"count", nil]] retain], @"2-2",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-3", @"key", @"Spartan", @"name", zero, @"count", nil]] retain], @"2-3",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-4", @"key", @"Disco Stu", @"name", zero, @"count", nil]] retain], @"2-4",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-5", @"key", @"Pop Star", @"name", zero, @"count", nil]] retain], @"2-5",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-6", @"key", @"Ringmaster", @"name", zero, @"count", nil]] retain], @"2-6",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-7", @"key", @"Lifeguard", @"name", zero, @"count", nil]] retain], @"2-7",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-8", @"key", @"Adventurer", @"name", zero, @"count", nil]] retain], @"2-8",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-9", @"key", @"Karate Master", @"name", zero, @"count", nil]] retain], @"2-9",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-10", @"key", @"Surfer", @"name", zero, @"count", nil]] retain], @"2-10",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-11", @"key", @"Witch", @"name", zero, @"count", nil]] retain], @"2-11",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-12", @"key", @"Mime", @"name", zero, @"count", nil]] retain], @"2-12",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-13", @"key", @"Motorcycle Cop", @"name", zero, @"count", nil]] retain], @"2-13",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-14", @"key", @"Mr. Maracas", @"name", zero, @"count", nil]] retain], @"2-14",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-15", @"key", @"Downhill Skier", @"name", zero, @"count", nil]] retain], @"2-15",
     [[Figure figureFromDict:[NSDictionary dictionaryWithObjectsAndKeys:
                              two, @"series", @"2-16", @"key", @"Weightlifter", @"name", zero, @"count", nil]] retain], @"2-16",
     nil];
	[figures addEntriesFromDictionary:[self s3_figures]];
	[figures addEntriesFromDictionary:[self s4_figures]];
	[figures addEntriesFromDictionary:[self s5_figures]];
	[figures addEntriesFromDictionary:[self s6_figures]];
    [figures addEntriesFromDictionary:[self s7_figures]];
    [figures addEntriesFromDictionary:[self s8_figures]];
    [figures addEntriesFromDictionary:[self s9_figures]];
	_figures = [[NSDictionary dictionaryWithDictionary:figures] retain];
	[self saveFigures];
}

+ (void) loadFigures {
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self archivePath]]) {
		NSMutableDictionary *figures;
        @try {
            figures = [NSMutableDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]]];
        }
        @catch (NSException * e) {
            [self resetFigures];
        }
        if (figures != nil) {
            if ([figures count] == 32) {
                [figures addEntriesFromDictionary:[self s3_figures]];
            }
            if ([figures count] == 48) {
                [figures addEntriesFromDictionary:[self s4_figures]];
            }
            if ([figures count] == 64) {
                [figures addEntriesFromDictionary:[self s5_figures]];
            }
            if ([figures count] == 80) {
                [figures addEntriesFromDictionary:[self s6_figures]];
            }
            if ([figures count] == 96) {
                [figures addEntriesFromDictionary:[self s7_figures]];
            }
            if ([figures count] == 112) {
                [figures addEntriesFromDictionary:[self s8_figures]];
            }
            if ([figures count] == 128) {
                [figures addEntriesFromDictionary:[self s9_figures]];
            }
            _figures = [[NSDictionary dictionaryWithDictionary:figures] retain];
        }
        else {
            [self resetFigures];
        }
    }
    else {
        [self resetFigures];
    }
}


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)coder {
  //[super encodeWithCoder:coder];
  [coder encodeObject:_key forKey:@"key"];
  [coder encodeInteger:_series forKey:@"series"];
  [coder encodeObject:_name forKey:@"name"];
  [coder encodeInteger:_count forKey:@"count"];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  _key = [[coder decodeObjectForKey:@"key"] retain];
  _series  = [coder decodeIntegerForKey:@"series"];
  _name = [[coder decodeObjectForKey:@"name"] retain];
  _count  = [coder decodeIntegerForKey:@"count"];
  return self;
}

@end
