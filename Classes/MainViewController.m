//
//  TTLauncherViewController.m
//  Three20
//
//  Created by Rodrigo Mazzilli on 9/25/09.


#import "MainViewController.h"

@interface MainViewController (Private)
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
}

- (void)viewDidUnload {
}

- (void)dealloc {
  [super dealloc];
}

- (NSArray *) launcherItemsForSeries:(int) series {
  NSMutableArray *items = [NSMutableArray array];
  for (int i = 1; i <= 16; i++) {
    NSString *name = [NSString stringWithFormat:@"%d-%d", series, i];
    NSString *image = [NSString stringWithFormat:@"bundle://%@-57.png", name];
    NSString *url = [NSString stringWithFormat:@"mc://figure/%@", name];
    TTLauncherItem *item = [[[TTLauncherItem alloc] initWithTitle:name image:image URL:url] autorelease];
    [items addObject:item];
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

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
  // ADD: get the decode results
  id<NSFastEnumeration> results =
  [info objectForKey: ZBarReaderControllerResults];
  ZBarSymbol *symbol = nil;
  for(symbol in results)
    // EXAMPLE: just grab the first barcode
    break;
  
  // EXAMPLE: do something useful with the barcode data
  //resultText.text = symbol.data;
  
  //EXAMPLE: do something useful with the barcode image
  //resultImage.image =
  //[info objectForKey: UIImagePickerControllerOriginalImage];
  
  // ADD: dismiss the controller (NB dismiss from the *reader*!)
  [reader dismissModalViewControllerAnimated: NO];
  [self openURLAction:@"fb://item3"];
}

@end
