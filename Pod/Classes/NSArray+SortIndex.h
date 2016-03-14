//
//  NSArray+SortIndex.h
//
//  Created by Mat Trudel on 2016-03-11.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

@import Foundation;

@interface NSArray (SortIndex)

- (void)mz_sortObject:(id)object toBeBetween:(id)before and:(id)after withSortKey:(NSString *)key;
- (void)mz_sortObject:(id)object toStartOfArrayWithSortKey:(NSString *)key;
- (void)mz_sortObject:(id)object toEndOfArrayWithSortKey:(NSString *)key;

- (BOOL)mz_isValidlySortedByKey:(NSString *)key;

@end
