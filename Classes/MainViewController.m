//
//  TTLauncherViewController.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.


#import "MainViewController.h"
#import "Figure.h"

@interface MainViewController (Private)

static NSDictionary *_barcodes;

@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = @"Minifigures";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                               target:self
                                               action:@selector(scanButtonTapped)] autorelease];
  }
  return self;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [_barcodes release];
  _barcodes = nil;
}

- (void)viewDidUnload {
  [_barcodes release];
}

- (void)dealloc {
  [super dealloc];
  
}

- (NSArray *) launcherItemsForSeries:(int) series {
  NSMutableArray *items = [NSMutableArray array];
  for (int i = 1; i <= 16; i++) {
    NSString *key = [NSString stringWithFormat:@"%d-%d", series, i];
    Figure *figure = [Figure figureFromKey:key];
    if (figure != nil) {
      NSString *name = figure.name;
      NSString *image = [NSString stringWithFormat:@"bundle://%@-57.png", figure.key];
      NSString *url = [NSString stringWithFormat:@"mc://figure/%@", figure.key];
      TTLauncherItem *item = [[[TTLauncherItem alloc] initWithTitle:name image:image URL:url] autorelease];
      item.badgeNumber = figure.count;
      [items addObject:item];
    }
  }
  return items;
}

- (NSArray *) launcherPages {
  
  return [NSArray arrayWithObjects:
          [self launcherItemsForSeries:1],[self launcherItemsForSeries:2], nil
         ];
}

- (void)loadView {
	[super loadView];

  _launcherView = [[LauncherView alloc] initWithFrame:self.view.bounds];
  
  _launcherView.backgroundColor = [UIColor blackColor];
  _launcherView.delegate = self;
  _launcherView.columnCount = 4;
  _launcherView.pages = [self launcherPages];
  [self.view addSubview:_launcherView];
  
  //TTLauncherItem* item = [_launcherView itemWithURL:@"fb://item3"];
  //item.badgeNumber = 4;
  
  /*
	_launcherView.delegate = self;
	_launcherView.columnCount = 4;
	_launcherView.pages = [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:
                          [[[TTLauncherItem alloc] initWithTitle:@"Search Test"
                                                           image:@"bundle://Icon.png"
                                                             URL:@"tt://searchTest" canDelete:YES] autorelease],
                          [[[TTLauncherItem alloc] initWithTitle:@"Photo Test"
                                                           image:@"bundle://Icon.png"
                                                             URL:@"tt://photoTest1" canDelete:YES] autorelease],
                          [[[TTLauncherItem alloc] initWithTitle:@"Table Item"
                                                           image:@"bundle://Icon.png"
                                                             URL:@"tt://tableItemTest" canDelete:YES] autorelease],
                          nil], 
                         nil
                         ];
  */
}

- (void) openURLAction: (NSString *) URL  {
  TTURLAction *action = [TTURLAction actionWithURLPath:URL];
  [action setAnimated:YES];
	[[TTNavigator navigator] openURLAction:action];

}
- (void)launcherView:(TTLauncherView*)launcher didSelectItem:(TTLauncherItem*)item {
	[self openURLAction: item.URL];
}

- (void)launcherViewDidBeginEditing:(TTLauncherView*)launcher {
}

- (void)launcherViewDidEndEditing:(TTLauncherView*)launcher {
}


- (IBAction) scanButtonTapped
{
  // ADD: present a barcode reader that scans from the camera feed
  ZBarReaderViewController *reader = [ZBarReaderViewController new];
  reader.readerDelegate = self;
  
  ZBarImageScanner *scanner = reader.scanner;
  // TODO: (optional) additional reader configuration here
  
  // EXAMPLE: disable rarely used I2/5 to improve performance
  [scanner setSymbology: ZBAR_I25
                 config: ZBAR_CFG_ENABLE
                     to: 0];
  
  // present and release the controller
  [self presentModalViewController: reader
                          animated: YES];
  [reader release];
}

- (NSDictionary *) barcodes {
  if (_barcodes == nil) {
    _barcodes = [[NSDictionary alloc] initWithObjectsAndKeys:
                 @"2-1", @"673419146791",
                 @"2-2", @"673419146807",
                 @"2-3", @"673419146814",
                 @"2-4", @"673419146821",
                 @"2-5", @"673419146838",
                 @"2-6", @"673419146845",
                 @"2-7", @"673419146852",
                 @"2-8", @"673419146869",
                 @"2-9", @"673419146876",
                 @"2-10", @"673419146883",
                 @"2-11", @"673419146890",
                 @"2-12", @"673419147064",
                 @"2-13", @"673419147071",
                 @"2-14", @"673419147088",
                 @"2-15", @"673419147095",
                 @"2-16", @"67341947101",
                 @"2-1", @"673419146951",
                 @"2-2", @"673419146968",
                 @"2-3", @"673419146975",
                 @"2-4", @"673419146982",
                 @"2-5", @"673419146999",
                 @"2-6", @"67341947002",
                 @"2-7", @"673419147019",
                 @"2-8", @"673419147026",
                 @"2-9", @"673419147033",
                 @"2-10", @"673419147040",
                 @"2-11", @"673419147057",
                 @"2-12", @"673419146906",
                 @"2-13", @"673419146913",
                 @"2-14", @"673419146920",
                 @"2-15", @"673419146937",
                 @"2-16", @"673419146944",
                 @"1-1", @"673419133760",
                 @"1-2", @"673419133777",
                 @"1-3", @"673419133784",
                 @"1-4", @"673419133791",
                 @"1-5", @"673419133807",
                 @"1-6", @"673419133814",
                 @"1-7", @"673419133821",
                 @"1-8", @"673419133838",
                 @"1-9", @"673419133845",
                 @"1-10", @"673419133852",
                 @"1-11", @"673419133869",
                 @"1-12", @"673419133876",
                 @"1-13", @"673419133883",
                 @"1-14", @"673419133890",
                 @"1-15", @"673419133906",
                 @"1-16", @"673419134071",
                 @"1-1", @"673419133913",
                 @"1-2", @"673419133920",
                 @"1-3", @"673419133944",
                 @"1-4", @"673419133951",
                 @"1-5", @"673419133968",
                 @"1-6", @"673419133975",
                 @"1-7", @"673419133982",
                 @"1-8", @"673419133999",
                 @"1-9", @"673419134002",
                 @"1-10", @"673419134019",
                 @"1-11", @"673419134026",
                 @"1-12", @"673419134033",
                 @"1-13", @"673419134040",
                 @"1-14", @"673419134057",
                 @"1-15", @"673419134064",
                 @"1-16", @"673419133937",                 
                 nil];
  }
  return _barcodes;
}

- (NSString *) trimLeadingZeroes:(NSString *) s {
  NSInteger i = 0;
  while ([[NSCharacterSet characterSetWithCharactersInString:@"0"] characterIsMember:[s characterAtIndex:i]]) {
    i++;
  }
  return [s substringFromIndex:i];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
  [reader dismissModalViewControllerAnimated: NO];

  id<NSFastEnumeration> results =
  [info objectForKey: ZBarReaderControllerResults];
  ZBarSymbol *symbol = nil;
  for(symbol in results)
    // EXAMPLE: just grab the first barcode
    break;
  
  NSString *code = [self trimLeadingZeroes:symbol.data];    
  NSString *fig = [[self barcodes] valueForKey:code];
  if (fig != NULL) {
    [self openURLAction:[NSString stringWithFormat:@"mc://figure/%@", fig]];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Barcode: %@", code]
                                                    message:@"That barcode doesn't match a Minifigure. (Tried the other barcode on the bag?)"
                                                   delegate:self cancelButtonTitle:@"Roger that" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
  }  
}

@end
