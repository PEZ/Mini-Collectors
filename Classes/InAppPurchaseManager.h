//
//  InAppPurchaseManager.h
//  Mini Collector
//
//  Created by PEZ on 2010-10-02.

#import <StoreKit/StoreKit.h>
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerSeriesTransactionFailedNotification_%@"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerSeriesTransactionSucceededNotification_%@"
#define kInAppPurchaseManagerSeriesContentProvidedNotification @"kInAppPurchaseManagerSeriesContentProvidedNotification_%@"
#define kInAppPurchaseManagerSeriesUpgradeTransactionReceipt @"kInAppPurchaseManagerSeriesUpgradeTransactionReceipt_%@"

#define kInAppPurchaseSeries3UpgradeProductId @"com.pezius.minicollector.series3"
#define kInAppPurchaseSeries4UpgradeProductId @"com.pezius.minicollector.series4"
#define kInAppPurchaseSeries5UpgradeProductId @"com.pezius.minicollector.series5"
#define kInAppPurchaseSeries7UpgradeProductId @"com.pezius.minicollector.series7"
#define kInAppPurchaseUnlockProductId @"com.pezius.minicollector.unlock"

#define kInAppPurchaseProducts [NSArray arrayWithObjects:kInAppPurchaseSeries3UpgradeProductId, kInAppPurchaseSeries4UpgradeProductId, kInAppPurchaseSeries5UpgradeProductId, kInAppPurchaseSeries7UpgradeProductId, kInAppPurchaseUnlockProductId, nil]
#define kIsSeriesProductUnlocked @"isSeries%dProductUnlocked"
#define kIsProductUnlocked @"isProductUnlocked"

#define seriesKey(key, series) [NSString stringWithFormat:key, series]
#define productIdKey(key, productId) [NSString stringWithFormat:key, productId]

#define kInAppPurchaseProductsUnlocked [NSArray arrayWithObjects:seriesKey(kIsSeriesProductUnlocked, 3), seriesKey(kIsSeriesProductUnlocked, 4), seriesKey(kIsSeriesProductUnlocked, 5), seriesKey(kIsSeriesProductUnlocked, 7), kIsProductUnlocked, nil]

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
  NSMutableDictionary *_seriesProducts;
  SKProductsRequest *productsRequest;
}

- (void)requestSeriesUpgradeProductData;
- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchase:(NSString*)productId;
- (void)provideContent:(NSString *)productId;
- (NSDictionary*) seriesProducts;

+ (InAppPurchaseManager *) getInstance;
+ (NSString*)productIdForSeries:(uint)series;
+ (uint)seriesForProductId:(NSString*)productId;

@end
