//
//  NSArray+SortIndex.m
//
//  Created by Mat Trudel on 2016-03-11.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

#import "NSArray+SortIndex.h"

#import "NSNumber+SortIndex.h"

@implementation NSArray (SortIndex)

- (void)mz_sortObject:(id)object toBeBetween:(id)before and:(id)after withSortKey:(NSString *)key
{
    NSNumber *index = [NSNumber mz_sortIndexBetween:[before valueForKey:key] and:[after valueForKey:key]];
    if (index != nil) {
        [object setValue:index forKey:key];
    } else {
        // We can't build a new index without shuffling a few other indexes around
        // See if we have room to shuffle forwards
        NSIndexSet *toReIndex;
        if (after != nil) {
            toReIndex = [self mz_indexSetForValuesRequiringReIndexFromItem:after forwards:YES withSortKey:key];
        }
        if (after != nil && ![[self[toReIndex.lastIndex] valueForKey:key] mz_isMaximumSortIndex]) {
            // Reindex forwards
            long long startIndex = (before != nil)? [[before valueForKey:key] longLongValue] : [[NSNumber mz_minimumSortIndex] longLongValue];
            long long endIndex = (toReIndex.lastIndex < self.count - 1)? [[self[toReIndex.lastIndex + 1] valueForKey:key] longLongValue] : [[NSNumber mz_maximumSortIndex] longLongValue];
            long long range = endIndex - startIndex;
            long long i = 1;
            long long divisions = toReIndex.count + 2;
            NSArray *objectsToReIndex = [[self objectsAtIndexes:toReIndex] copy];
            [object setValue:@(startIndex + range * i / divisions) forKey:key];
            for (id reIndexedObject in objectsToReIndex) {
                if (reIndexedObject != object) {
                    [reIndexedObject setValue:@(startIndex + range * ++i / divisions) forKey:key];
                }
            }
        } else {
            // Reindex backwards
            toReIndex = [self mz_indexSetForValuesRequiringReIndexFromItem:before forwards:NO withSortKey:key];
            long long startIndex = (toReIndex.firstIndex > 0)? [[self[toReIndex.firstIndex - 1] valueForKey:key] longLongValue] : [[NSNumber mz_minimumSortIndex] longLongValue];
            long long endIndex = (after != nil)? [[after valueForKey:key] longLongValue] : [[NSNumber mz_maximumSortIndex] longLongValue];
            long long range = endIndex - startIndex;
            long long i = 1;
            long long divisions = toReIndex.count + 2;
            for (id reIndexedObject in [[self objectsAtIndexes:toReIndex] copy]) {
                if (reIndexedObject != object) {
                    [reIndexedObject setValue:@(startIndex + range * i++ / divisions) forKey:key];
                }
            }
            [object setValue:@(startIndex + range * i / divisions) forKey:key];
        }
    }
}

- (void)mz_sortObject:(id)object toStartOfArrayWithSortKey:(NSString *)key
{
    [self mz_sortObject:object toBeBetween:nil and:self.firstObject withSortKey:key];
}

- (void)mz_sortObject:(id)object toEndOfArrayWithSortKey:(NSString *)key
{
    [self mz_sortObject:object toBeBetween:self.lastObject and:nil withSortKey:key];
}

- (BOOL)mz_isValidlySortedByKey:(NSString *)key
{
    return [[self sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:key ascending:YES]]] isEqualToArray:self];
}

#pragma mark - Private methods

- (NSIndexSet *)mz_indexSetForValuesRequiringReIndexFromItem:(id)item forwards:(BOOL)forward withSortKey:(NSString *)key
{
    NSInteger startIndex = [self indexOfObject:item];
    NSInteger offset = 1;

    if (forward) {
        while(startIndex + offset < self.count &&
              [NSNumber mz_sortIndexBetween:[self[startIndex + offset - 1] valueForKey:key] and:[self[startIndex + offset] valueForKey:key]] == nil) {
            offset += 1;
        }
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex, offset)];
    } else {
        while(startIndex - offset >= 0 &&
              [NSNumber mz_sortIndexBetween:[self[startIndex - offset] valueForKey:key] and:[self[startIndex - offset + 1] valueForKey:key]] == nil) {
            offset += 1;
        }
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(startIndex - offset + 1, offset)];
    }
}


@end
