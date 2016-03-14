//
//  NSNumber+SortIndex.h
//
//  Created by Mat Trudel on 2016-03-11.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

@import Foundation;

typedef int32_t mz_sort_t;

@interface NSNumber (SortIndex)
@property(readonly) mz_sort_t mz_sortValue;
@property(readonly) BOOL mz_isMinimumSortIndex;
@property(readonly) BOOL mz_isMaximumSortIndex;

+ (NSNumber *)mz_minimumSortIndex;
+ (NSNumber *)mz_maximumSortIndex;

+ (instancetype)mz_sortIndexBetween:(NSNumber *)prev and:(NSNumber *)next;

@end
