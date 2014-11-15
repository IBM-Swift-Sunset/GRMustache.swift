//
//  EachFilter.swift
//  GRMustache
//
//  Created by Gwendal Roué on 31/10/2014.
//  Copyright (c) 2014 Gwendal Roué. All rights reserved.
//

class EachFilter: Filter {
    
    func mustacheFilterByApplyingArgument(argument: Value) -> Filter? {
        return nil
    }
    
    func transformedMustacheValue(value: Value, error outError: NSErrorPointer) -> Value? {
        if value.isEmpty {
            return value
        } else if let dictionary: [String: Value] = value.object() {
            return transformedDictionary(dictionary)
        } else if let array: [Value] = value.object() {
            return transformedSequence(array)
        } else if let set = value.object() as? NSSet {
            return transformedSet(set)
        } else {
            if outError != nil {
                outError.memory = NSError(domain: GRMustacheErrorDomain, code: GRMustacheErrorCodeRenderingError, userInfo: [NSLocalizedDescriptionKey: "filter argument error: not iterable"])
            }
            return nil
        }
    }
    
    private func transformedSequence<T: CollectionType where T.Generator.Element == Value, T.Index: Comparable, T.Index.Distance == Int>(collection: T) -> Value {
        var mustacheValues: [Value] = []
        let start = collection.startIndex
        let end = collection.endIndex
        var i = start
        while i < end {
            let value = collection[i]
            let index = distance(start, i)
            let last = i.successor() == end
            let replacementValue = ReplacementValue(value: value, index: index, key: nil, last: last)
            mustacheValues.append(Value(replacementValue))
            i = i.successor()
        }
        return Value(mustacheValues)
    }
    
    private func transformedSet(set: NSSet) -> Value {
        var mustacheValues: [Value] = []
        let count = set.count
        var index = 0
        for item in set {
            let value = Value(item)
            let last = index == count
            let replacementValue = ReplacementValue(value: value, index: index, key: nil, last: last)
            mustacheValues.append(Value(replacementValue))
            ++index
        }
        return Value(mustacheValues)
    }
    
    private func transformedDictionary(dictionary: [String: Value]) -> Value {
        var mustacheValues: [Value] = []
        let start = dictionary.startIndex
        let end = dictionary.endIndex
        var i = start
        while i < end {
            let (key, value) = dictionary[i]
            let index = distance(start, i)
            let last = i.successor() == end
            let replacementValue = ReplacementValue(value: value, index: index, key: key, last: last)
            mustacheValues.append(Value(replacementValue))
            i = i.successor()
        }
        return Value(mustacheValues)
    }
    
    private class ReplacementValue: Cluster, Renderable {
        let value: Value
        let index: Int
        let last: Bool
        let key: String?
        
        init(value: Value, index: Int, key: String?, last: Bool) {
            self.value = value
            self.index = index
            self.key = key
            self.last = last
        }
        
        var mustacheBool: Bool { return value.mustacheBool }
        var mustacheFilter: Filter? { return (value.object() as Cluster?)?.mustacheFilter }
        var mustacheTagObserver: TagObserver? { return (value.object() as Cluster?)?.mustacheTagObserver }
        var mustacheTraversable: Traversable? { return (value.object() as Cluster?)?.mustacheTraversable }
        var mustacheRenderable: Renderable? { return self }
        
        func renderForMustacheTag(tag: Tag, renderingInfo: RenderingInfo, contentType outContentType: ContentTypePointer, error outError: NSErrorPointer) -> String? {
            var position: [String: Value] = [:]
            position["@index"] = Value(index)
            position["@indexPlusOne"] = Value(index + 1)
            position["@indexIsEven"] = Value(index % 2 == 0)
            position["@first"] = Value(index == 0)
            position["@last"] = Value(last)
            if let key = key {
                position["@key"] = Value(key)
            }
            let renderingInfo = renderingInfo.renderingInfoByExtendingContextWithValue(Value(position))
            return value.renderForMustacheTag(tag, renderingInfo: renderingInfo, contentType: outContentType, error: outError)
        }
    }
}