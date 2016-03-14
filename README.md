# MZFastSortIndex

[![CI Status](http://img.shields.io/travis/moshozen/MZFastSortIndex.svg?style=flat)](https://travis-ci.org/Mat Trudel/MZFastSortIndex)
[![Version](https://img.shields.io/cocoapods/v/MZFastSortIndex.svg?style=flat)](http://cocoapods.org/pods/MZFastSortIndex)
[![License](https://img.shields.io/cocoapods/l/MZFastSortIndex.svg?style=flat)](http://cocoapods.org/pods/MZFastSortIndex)
[![Platform](https://img.shields.io/cocoapods/p/MZFastSortIndex.svg?style=flat)](http://cocoapods.org/pods/MZFastSortIndex)

## Usage

`MZFastSortIndex` allows you to sort and reorder objects in an unordered collection
in a performant way, using a single `NSNumber` field to store sort order. To do this,
we derive a value for the object's sort field which will place it in the
expected spot in the collection when sorted. Where necessary, `MZFastSortIndex` 
will also re-index other objects in the collection to provide space for the
necessary insertions. It does so in a manner which optimizes the index in terms
of usage of the number range, and thus minimizes the number of reindexes needed
on subsequent insertions.

This approach has a bunch of upsides for unordered collections in practice;
reordering an object in a collection (by dragging the UI item in a table or
collection view, for example) typically results in a single object being
mutated; in the common case no intervening records have to update their index
values to keep the collection in the expected order. In the case where objects
need to be shuffled to make room for the newly inserted or moved object,
`MZFastSortIndex` automatically does this for you, optimally reindexing objects
to provide the most possible room for future moves or insertions.

Deleting a single object will always leave all other objects in the
collection untouched; remaining objects do not need to have their index values
shuffled down to fill the gap. 

You can apply `MZFastSortIndex` to any existing integer sort field that validly
sorts the objects in your collection in ascending order. It will maintain
a valid sort of the existing items, and will gradually grow the index out to
make optimal use of the range of possible index values.

In terms of Core Data models, `MZFastSortIndex` will work with any integer field
at least 32 bits wide (in particular, it grew out of a project where we used an
`Integer 32` sort field).

At read time, all that's needed is to sort your collection as you normally would
(via `NSSortDescriptor` objects, for example). In cases where your data is backed 
by a Core Data store, you can then have Core Data index your sort field for 
super-fast reading courtesy of SQLite.

## To Be Done

While `MZFastSortIndex` is suitable for use in the common case, there are a few
things planned for its future:

* [ ] Remove NSObject allocation from inside the tight loops. There's some
  simple numeric stuff that we do that's probably better expressed as standard
  scalars
* [ ] Explore behaviour when full. We currently use signed int32's as the range
  of possible indexes. There is no explicit test case to cover index exhaustion
  and there should be
* [ ] Allow for (optional) 64 bit indexes. Currently we (lazily) rely on being
  able to perform 32 bit math with `long long`s to avoid overflow. We need to
  tighten up this math so we can provide the option of 64 bit indexes.

## Requirements

iOS 8 and ARC. `MZFastSortIndex` works with any KVC compliant data source.

## Installation

MZFastSortIndex is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MZFastSortIndex"
```

## Author

Mat Trudel, mat@geeky.net

## License

MZFastSortIndex is available under the MIT license. See the LICENSE file for more info.
