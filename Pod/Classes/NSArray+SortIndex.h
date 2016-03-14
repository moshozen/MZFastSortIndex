//
//  NSArray+SortIndex.h
//
//  Created by Mat Trudel on 2016-03-11.
//  Copyright (c) 2016 Moshozen Inc. All rights reserved.
//

@import Foundation;

@interface NSArray (SortIndex)

- (void)mz_setSortKey:(NSString *)key onObject:(id)object toLieAtSortedIndex:(NSInteger)sortedIndex;
- (NSNumber *)mz_valueForKeyToLieAtStartOfSortedArray:(NSString *)key;
- (NSNumber *)mz_valueForKeyToLieAtEndOfSortedArray:(NSString *)key;

@end
