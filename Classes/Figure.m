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
  if (self = [super init]) {
    self.series = [[dict objectForKey:@"series"] intValue];
    self.key = [dict objectForKey:@"key"];
    self.count = [[dict objectForKey:@"count"] intValue];
    self.name = [dict objectForKey:@"name"];
  }
  return self;
}

- (void) countChanged {
  self.launcherItem.badgeNumber = self.count;
  [Figure saveFigures];
}

- (NSString *) achievmentIdentifier {
  return [NSString stringWithFormat:@"F_%@", [self.key stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
}

- (NSArray *) incrementSeriesAchievments:(int)s {
  NSMutableArray *achievements = [[NSMutableArray alloc] initWithCapacity:2];
  NSString *thisSeriesId = [NSString stringWithFormat:@"S%d", s];
  GKAchievement *thisSeriesAchievement = [[AppDelegate getInstance] getAchievementForIdentifier:thisSeriesId];
  float percentThisSeries = thisSeriesAchievement.percentComplete;
  if (percentThisSeries < 100.0) {
    thisSeriesAchievement.percentComplete = percentThisSeries + 100.0/15.999999;
    [achievements addObject:thisSeriesAchievement];
    if (thisSeriesAchievement.percentComplete >= 100.0) {
      GKAchievement *achievement2S = [[AppDelegate getInstance] getAchievementForIdentifier:@"2S"];
      float percent2S = achievement2S.percentComplete;
      if (percent2S < 100.0) {
        achievement2S.percentComplete = percent2S + 100.0/1.999999;
        [achievements addObject:achievement2S];
      }
    }
  }
  return achievements;
}

- (void) incrementSpree:(int)goalCount result:(NSMutableArray *)achievements  {
  GKAchievement *a = [[AppDelegate getInstance] getAchievementForIdentifier:[NSString stringWithFormat:@"%dF", goalCount]];
  float percent = a.percentComplete;
  if (percent < 100.0) {
    a.percentComplete = percent + 100.0/(goalCount - 0.000001);
    [achievements addObject:a];
  }
}
- (NSArray *) incrementFigureSpreeAchievments {
  NSMutableArray *achievements = [[NSMutableArray alloc] initWithCapacity:2];
  [self incrementSpree:10 result:achievements];
  [self incrementSpree:25 result:achievements];
  return achievements;
}

- (NSArray *) reportAchievement {
  NSMutableArray *achievements = [[NSMutableArray alloc] initWithCapacity:4];
  float percentComplete = [[AppDelegate getInstance] getAchievementForIdentifier:[self achievmentIdentifier]].percentComplete;
  if (percentComplete < 100.0) {
    [[AppDelegate getInstance] reportAchievementIdentifier:[self achievmentIdentifier] percentComplete:100.0];
    [achievements addObjectsFromArray:[self incrementFigureSpreeAchievments]];
    [achievements addObjectsFromArray:[self incrementSeriesAchievments:self.series]];
  }
  return achievements;
}

- (void) increaseCount {
  self.count++;
  [self countChanged];
  for (GKAchievement *a in [self reportAchievement]) {
    [[AppDelegate getInstance] reportAchievementIdentifier:a.identifier percentComplete:a.percentComplete];
  };
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
																	 three, @"series", @"3-1", @"key", @"Hola Girl", @"name", zero, @"count", nil]] retain], @"3-1",
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
																	 three, @"series", @"3-7", @"key", @"Indian Chief", @"name", zero, @"count", nil]] retain], @"3-7",
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
	_figures = [NSDictionary dictionaryWithDictionary:figures];
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
		if ([figures count] < 33) {
			[figures addEntriesFromDictionary:[self s3_figures]];
		}
		_figures = [[NSDictionary dictionaryWithDictionary:figures] retain];
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
