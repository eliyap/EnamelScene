//
//  MakeUnichars.swift
//  https://gist.github.com/yossan/c34e6850c542bda747ab4d6fc68a7eaf
//

import Foundation

func makeUnichars(from str: NSString) -> [UInt16] {
    let range = NSRange(location:0, length: str.length)

    let encoding = String.Encoding.utf16.rawValue
    let maxLength = str.maximumLengthOfBytes(using: encoding)
    let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: maxLength, alignment: 0)
    var usedLength: Int = 0

    str.getBytes(rawPointer,
        maxLength: maxLength,
        usedLength: &usedLength,
        encoding: encoding,
        range: range,
        remaining: nil)

    let rawBufferPointer = UnsafeRawBufferPointer(start: rawPointer, count: usedLength)
    let bufferPointer = rawBufferPointer.bindMemory(to: UInt16.self)

    return Array(bufferPointer)
}
