//
//  NSNumber+SortIndex.m
//
//  Created by Mat Trudel on 2016-03-11.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

#import "NSNumber+SortIndex.h"

static const mz_sort_t kLowestIndex = INT32_MIN + 1;
static const mz_sort_t kHighestIndex = INT32_MAX;

@implementation NSNumber (SortIndex)

+ (NSNumber *)mz_minimumSortIndex
{
    return @(kLowestIndex);
}

+ (NSNumber *)mz_maximumSortIndex
{
    return @(kHighestIndex);
}

+ (instancetype)mz_sortIndexBetween:(NSNumber *)prevNumber and:(NSNumber *)nextNumber
{
    mz_sort_t prev = (prevNumber != nil)? prevNumber.mz_sortValue : kLowestIndex;
    mz_sort_t next = (nextNumber != nil)? nextNumber.mz_sortValue : kHighestIndex;

    if (prev < next - 1 || (prevNumber == nil && next == kLowestIndex + 1)) {
        long long base = prev;
        long long range = (long long)next - prev;
        return @(base + range / 2);
    } else {
        return nil;
    }
}

- (mz_sort_t)mz_sortValue
{
    return self.intValue;
}

- (BOOL)mz_isMinimumSortIndex
{
    return [self isEqualToNumber:@(kLowestIndex)];
}

- (BOOL)mz_isMaximumSortIndex
{
    return [self isEqualToNumber:@(kHighestIndex)];
}

@end
