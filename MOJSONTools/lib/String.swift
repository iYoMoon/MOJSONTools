//
//  String.swift
//  MOJSONTools
//
//  Created by Moon on 2022/12/23.
//

import Foundation

extension String {
    
    func uppercased(at: Int) -> String {
        return String(prefix(1).capitalized + dropFirst())
    }
    
    func allRanges(
        of aString: String,
        options: String.CompareOptions = [],
        range: Range<String.Index>? = nil,
        locale: Locale? = nil
    ) -> [Range<String.Index>] {
        
        // the slice within which to search
        let slice = (range == nil) ? self[...] : self[range!]
        
        var previousEnd = startIndex
        var ranges = [Range<String.Index>]()
        
        while let range = slice.range(
            of: aString,
            options: options,
            range: previousEnd ..< endIndex,
            locale: locale
        ) {
            if previousEnd != endIndex { // don't increment past the end
                previousEnd = index(after: range.lowerBound)
            }
            ranges.append(range)
        }
        
        return ranges
    }

    
}
