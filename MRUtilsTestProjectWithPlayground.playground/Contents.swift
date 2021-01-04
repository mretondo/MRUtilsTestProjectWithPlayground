import UIKit
import SwiftUI
import MRUtils

//
// test to sort array of people with different names and birth years (asending/desending)
//
@objcMembers
final class Person: NSObject
{
    let first: String
    let last: String
    let yearOfBirth: Int

    init(first: String, last: String, yearOfBirth: Int)
    {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
        // super.init() implicitly called here
    }

    override var debugDescription: String {
        return first + " " + last + " " + String(yearOfBirth)
    }

    override var description: String { "\(first) \(last) \(yearOfBirth)" }
}

// Define an array of people with different names and birth years
let people = [
    Person(first: "Emily",  last: "Young",  yearOfBirth: 2002),
    Person(first: "David",  last: "Gray",   yearOfBirth: 1991),
    Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
    Person(first: "Ava",    last: "Barnes", yearOfBirth: 2000),
    Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
    Person(first: "Ava",    last: "Barnes", yearOfBirth: 1998),
]

//
// use SortDescriptor.swift from MRUtils to do multi-level sorting
//
let sortByYear: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth })
let sortByFirstName: SortDescriptor<Person> = sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)
let sortByLastName: SortDescriptor<Person> = sortDescriptor(key: { $0.last }, by: String.localizedStandardCompare)
let sortByYearDesending: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth }, by: >)

var combinedSortDescriptors: SortDescriptor<Person> = combineSortDescriptors (using: [sortByLastName, sortByFirstName, sortByYear])
var asendingPeople = people.sorted(by: combinedSortDescriptors)
var desendingPeople = people.sorted(by: combineSortDescriptors (using: [sortByLastName, sortByFirstName, sortByYearDesending]))

//
// Sort Finder filenames only by their extensions
// Missing extensions come first i.e. "file", then by empty extensions i.e. "file.” and finally by extensions
//
extension String {
    var fileExtension: String? {
        guard let period = lastIndex(of: ".") else { return nil }

        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }
}

var files = ["file.swift", "one", "two", "test.h", "three", "file.h", "file.", "file.c"]

let compare = lift(String.localizedStandardCompare)
let filesAsending = files.sorted(by: sortDescriptor(key: { $0.fileExtension }, by: compare))
// ["one", "two", "three", "file.", "file.c", "test.h", "file.h", "file.swift"]
filesAsending

var filesDescending: String {
    files.sort { e0, e1 in
        // don't swap items if both don't have extensions
        if e1.fileExtension == nil && e0.fileExtension == nil {
            return false
        }

        // if file on the right has no extension it comes first
        if e0.fileExtension == nil {
            return true
        }

        // if file on the left has no extension it comes first
        if e1.fileExtension == nil {
            return false
        }

        return e1.fileExtension.flatMap { e0.fileExtension?.localizedStandardCompare($0) } == .orderedDescending
    }
    // files ["one", "two", "three", "file.swift", "test.h", "file.h", "file.c", "file."]
    return files.description
}


//
// use String extensions from StringUtils.swift to learn how to use Strings in Swift
//
var str2 = "🇩🇪👨‍👩‍👧‍👦👩‍❤️‍👩🇺🇸🇫🇷🇮🇹🇬🇧🇪🇸🇯🇵🇷🇺🇨🇳"
var c = str2[2]
print(type(of: c))
var d = str2[str2.startIndex]
print(type(of: d))
str2[1] == "👨‍👩‍👧‍👦"
str2[...4]
str2[..<4]
str2[1...4]
str2[1..<4]
str2[6...]
str2[6..<8]

var houses = "🏠🏡🏠🏡🏠"
houses.replace(from: 3, maxLength: 1, with: "🐴")
houses = "🏠🏡🏠🏡🏠"
houses.replace(from: 3, maxLength: 1, with: "🐴A")
houses = "\u{00E9}Aﬃ🏡🏠"
houses.replace(from: 2, maxLength: 2, with: "e")
houses = "🏠🏡🏠🏡🏠"
houses.replace(from: 2, maxLength: 1, with: "ﬃ🐴A")


// String experiments
let hello = "hello"
let startIndex = hello.startIndex // 0
let endIndex = hello.endIndex     // 5
hello[startIndex]                 // "h"
let x = hello[hello.index(before: endIndex)]                 // "h"

let ss = "Hello, Swift"
ss[ss.startIndex..<ss.endIndex]

let earth = "🌍"

let multipleFlags: Character = "🇩🇪🇺🇸🇫🇷🇮🇹🇬🇧🇪🇸🇯🇵🇷🇺🇨🇳" // DE US FR IT GB ES JP RU CN
print (multipleFlags) // single character YEP! single character
var multipleFlagsString = String(multipleFlags) + "!"
multipleFlagsString.count // 10 user perceived characters
print (multipleFlagsString) // string of 10 charaters


var ligature = "ﬃ"
ligature.count // -> 1 user perceived character
ligature += " ffi" // append non ligature
ligature.count // -> 1 user perceived character
// get the EXACT number of bytes needed to store the String
var numberOfBytes = ligature.lengthOfBytes(using: .utf32)
// Get an ESTIMATE of the maximum number of bytes needed to store the String
// May be considerably greater than the actual length needed, faster than lengthOfBytes(using:)
var maxNumberOfBytes = ligature.maximumLengthOfBytes(using: .utf32)
print ("\(ligature) number of bytes is \(maxNumberOfBytes)") // -> 20
"ﬃ".maximumLengthOfBytes(using: .utf16)
"ﬃ".maximumLengthOfBytes(using: .utf8)

var e = "\u{00E9}"
e.count // -> 1 user perceived character
e.length
e.maximumLengthOfBytes(using: .utf8)
e.maximumLengthOfBytes(using: .utf16)   // note utf16 in this case takes up less memory than utf8
e.maximumLengthOfBytes(using: .utf32)
e = "e\u{0301}" // append non ligature
e.count // -> 1 user perceived character
e.length
e.maximumLengthOfBytes(using: .utf8)
e.maximumLengthOfBytes(using: .utf16)   // note utf16 in this case takes up less memory than utf8
e.maximumLengthOfBytes(using: .utf32)
// get the EXACT number of bytes needed to store the String in memory which Swift 5 now uses utf8 instead of utf16
numberOfBytes = e.lengthOfBytes(using: .utf8)
// Get an ESTIMATE of the maximum number of bytes needed to store the String
// May be considerably greater than the actual length needed, faster than lengthOfBytes(using:)
maxNumberOfBytes = e.maximumLengthOfBytes(using: .utf32)
print ("\(e) number of bytes is \(maxNumberOfBytes)") // -> 8
"\u{00E9}".maximumLengthOfBytes(using: .utf16)
"e\u{0301}".maximumLengthOfBytes(using: .utf8)

var s = "\u{00E9}" // é
var t = "\u{0065}\u{0301}" // e + ´
print("\(t)")
var isEqual : Bool
isEqual = s == t
let equality = isEqual ? "equal" : "not equal"
print ("\(s) is \(equality ) to \(t)") // => é is not equal to e + ´

var bytes = 0
let dogString = "Dog‼🐶"    // !! is one character
for scalar in dogString.unicodeScalars {
    bytes += 4
    print("\(scalar) ")
}
print ("\(dogString) count is \(dogString.count)")
print ("Total Scalar bytes \(bytes)") // Total Scalar bytes 20

var codeUnits = ""
for codeUnit in dogString.utf8 {
    codeUnits += "\(codeUnit)" + " "
}
print ("\(dogString) count is \(dogString.utf8.count)")
print("\(codeUnits) ", terminator: "")
// Prints "68 111 103 226 128 188 240 159 144 182 "
print("")


bytes = 0
var cafeString = "Café"
for scalar in cafeString.unicodeScalars {
    bytes += 4
    print("\(scalar) ")
}
print ("\(cafeString) count is \(cafeString.count)")
print ("Total bytes \(bytes)")
// Total bytes 16
codeUnits = ""
for codeUnit in cafeString.utf16 {
    codeUnits += "\(codeUnit) "
}
print ("\(cafeString) count is \(cafeString.utf8.count)")
print ("\(cafeString) count is \(cafeString.utf16.count*2)")
print ("\(cafeString) count is \(cafeString.unicodeScalars.count*4)")
print("\(codeUnits) ", terminator: "")
print("")
(cafeString as NSString).length

bytes = 0
cafeString = "Cafe\u{0301}"
for scalar in cafeString.unicodeScalars {
    bytes += 4
    print("\(scalar) ")
}
print ("\(cafeString) count is \(cafeString.utf8.count)")
print ("\(cafeString) count is \(cafeString.utf16.count*2)")
print ("\(cafeString) count is \(cafeString.unicodeScalars.count*4)")
print ("\(cafeString) count is \(cafeString.count)")
print ("Total bytes \(bytes)")
// Total bytes 20
codeUnits = ""
for codeUnit in cafeString.utf16 {
    codeUnits += "\(codeUnit) "
}
print("\(codeUnits) ", terminator: "")
print("") // newline
(cafeString as NSString).length



var spain = "España"
spain.count      // 6
spain.unicodeScalars.count  // 6
spain.utf16.count           // 6
spain.utf8.count            // 7


let greeting = "Guten Tag!"
greeting[greeting.startIndex]
// G
greeting[greeting.index(before: greeting.endIndex)]
// !
greeting[greeting.index(after: greeting.startIndex)]
// u
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]
// a

let cafe = "Café"
// Unicode safe
let composedCafe = "Café"
let decomposedCafe = "Cafe\u{0301}"
print(cafe.hasPrefix(composedCafe)) // Prints "true"
print(cafe.hasPrefix(decomposedCafe)) // Prints "true"
print(cafe.hasSuffix(decomposedCafe))  // Prints "true"
print(cafe.suffix(1))
print(decomposedCafe.suffix(1))

if let i = cafe.index(of: "é") {
    print (cafe[i])
    print (i)
    let j = i.samePosition(in: cafe.utf8)!
    print (cafe[j])
    print (j)
    print(Array(cafe.utf8[j...]))
    // Prints "[195, 169]"
    print(Array(cafe.utf16[j...]))
    // Prints "[233]"
    print(Array(cafe.unicodeScalars[j...]))
    // Prints "["\\u{00E9}"]"
}

"é".prefix(0)
"a".prefix(1)
"a".prefix(2)
//"a".prefix(-1) // thoughs exception

//"a".infix(from: 1)
"a".infix(from: 0, maxLength: 2)

"a".suffix(0)
"a".suffix(1)
"a".suffix(2)
//"a".suffix(-1) // thoughs exception

let rawInput = "126 a.b 22219 zzzzzz"
let numericPrefix = rawInput.prefix(while: { "0"..."9" ~= $0 })
numericPrefix

var str = String ("Hello, playground")

// don't allow index beond the end
let safeIdx = str.index(str.startIndex, offsetBy: 50, limitedBy: str.endIndex)

var toIndex = str.index(str.endIndex, offsetBy: -4)
var substring = str[..<toIndex]
toIndex = str.index(str.startIndex, offsetBy: 4)
substring = str[..<toIndex]
var range = str.lineRange(for: str.startIndex..<str.index(str.startIndex, offsetBy: 1))

let s1 = "They call me 'Bell'"
let s2 = "They call me 'Stacey'"
print(strncmp(s1, s2, 15))

//str.prefix(-1)  // error
//str.infix(from: -1)   // error
str[2...] // same as infix
str.infix(from: 2)
str.infix(from: 30)
str.infix(from: 16)
str.infix(from: 17)
str.infix(from: 70)
//str.infix(from: -2, maxLength: 0)   // error
//str.infix(from: 0, maxLength: -1)   // error
//str.infix(from: -2, maxLength: -1)   // error
//str.infix(from: 2, maxLength: -1)   // error
str.infix(from: 16, maxLength: 0)
str.infix(from: 16, maxLength: 1)
str.infix(from: 16, maxLength: 10)
str.infix(from: 17, maxLength: 0)
str.infix(from: 17, maxLength: 1)
str.infix(from: 17, maxLength: 10)
str.infix(from: 30, maxLength: 0)
str.infix(from: 30, maxLength: 1)
str.infix(from: 30, maxLength: 10)
str.infix(from: 2, maxLength: 30)
str.infix(from: 7, maxLength: 10)

// make sure from: position is treated as an index so percieved characters are
// parsed and not code points (all the flags are really 1 character in unicode)
var flags = "0123" + String(multipleFlags) + "DEF"
flags.count
flags.length
flags.infix(from: 4)
flags[5...] // same as infix
flags.infix(from: 5)
flags.infix(from: 13)
flags.infix(from: 2, maxLength: 70)
flags.infix(from: 6, maxLength: 4)

var numbers = "3742961"
var positiveInfix = numbers.infix(from: 1, while: { $0 != "6" })
positiveInfix // positiveInfix == "7429"
positiveInfix = numbers.infix(from: 1) { $0 != "6" }  // with while - predicate outside of paramaters
positiveInfix // positiveInfix == "7429"

"🇺🇸".count
"🇺🇸\n".count
"🇺🇸\r".count
"🇺🇸\r\n".count    // \r\n is treatead as 1 glyph in standard UNICODE

"🇺🇸".size
"🇺🇸\n".size
"🇺🇸\r".size
"🇺🇸\r\n".size    // \r\n is treatead as 2 characters in 'size'

// note these are the same as 'size'
"🇺🇸".utf8.count
"🇺🇸\n".utf8.count
"🇺🇸\r".utf8.count
"🇺🇸\r\n".utf8.count    // \r\n is treatead as 2 characters in UTF8

"🇺🇸\r\n".lengthOfBytes(using: .utf8)  // utf8 treats \r\n as 2 characters
"🇺🇸\r\n".lengthOfBytes(using: .utf16) // utf16 treats \r\n as 2 characters
"🇺🇸\r\n".lengthOfBytes(using: .unicode)
"🇺🇸\r\n".lengthOfBytes(using: .ascii)  // ascii requires all characters to be ascii else 0 is returned

// \r\n as a pair is treated as 1 standard UNICODE character but as utf8 it's treated as 2 seperate characters.
// There the only ascii characters to be treated differently in standard UNICODE vs. UTF8.
"\n".count
"\n".size
"\r".count
"\r".size
"\r\n".count // count treats string as Unicode and NOT UTF8 i.e. NOT pure ascii so it's 1 character
"\r\n".size // size treats string as utf8 which treats ALL ascii characters as 1 character
"\r\n".utf8.count // same as 'size'
"\r\n".lengthOfBytes(using: .ascii)

"\n\r".count
"\n\r".size
"\n\r\r\n".count
"\n\r\r\n".size

numbers = "12\n34\n"
numbers.count
numbers.size
numbers.length  // length in utf16 code points which uses 2 bytes for each code point
numbers.lengthOfBytes(using: .utf16)    // basically the same as (numbers.length * 2)

