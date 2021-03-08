//
//  ContentView.swift
//  MRUtilsTestProjectWithPlayground
//
//  Created by Mike Retondo on 1/2/21.
//

import SwiftUI
import MRUtils

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

//
// sort array of people with different names and birth years (asending/desending)
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
let sortByYear: SortDescriptor<Person>           = sortDescriptor(key: { $0.yearOfBirth })
let sortByYearDesending: SortDescriptor<Person>  = sortDescriptor(key: { $0.yearOfBirth }, by: >)
let sortByFirstName: SortDescriptor<Person>      = sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)
let sortByLastName: SortDescriptor<Person>       = sortDescriptor(key: { $0.last }, by: String.localizedStandardCompare)

//var files = ["file.swift", "one", "two", "test.h", "three", "file.h", "file.", "file.c"]
var files = ["b", "a.", "a", "b.", "a.x", "b.h"]

struct ContentView: View {
    var asendingPeople  = people.sorted(by: combineSortDescriptors (using: [sortByLastName, sortByFirstName, sortByYear]))
    var desendingPeople = people.sorted(by: combineSortDescriptors (sortByLastName, sortByFirstName, sortByYearDesending))

    //
    // file names sorted like Finder
    //
    let fileNamesAsending = files.sorted(by: sortDescriptor(key: { $0 },
                                                            by: String.localizedStandardCompare))
    let fileNamesDesending = files.sorted(by: sortDescriptor(key: { $0 },
                                                             ascending: false,
                                                             by: String.localizedStandardCompare))

    //
    // file extensions sorted like Finder
    // 'lift' allows String.localizedStandardCompare to take optionals
    //
    let extensionsAsending = files.sorted(by: sortDescriptor(key: { $0.fileExtension },
                                                             by: lift(String.localizedStandardCompare)))
    let extensionsDesending = files.sorted(by: sortDescriptor(key: { $0.fileExtension },
                                                              ascending: false,
                                                              by: lift(String.localizedStandardCompare)))

    //
    // file extensions sorted descending like Finder NOT using SortDescriptor
    //
    var fileExtensionsDescending: [String] {
        return files.sorted { lhs, rhs in
            switch (lhs.fileExtension, rhs.fileExtension) {
                case (nil, nil): return false   // don't swap
                case (nil, _): return false     // descending so nil comes second
                case (_, nil): return true      // descending so nil comes second
                case (_, _): return lhs.fileExtension!.localizedStandardCompare(rhs.fileExtension!) == .orderedDescending
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(asendingPeople.description).padding()
            Text(desendingPeople.description).padding()
            VStack() {
                Text("files.description")
                Text(files.description)
            }.padding()
            VStack() {
                Text("fileNamesAsending/Desending")
                Text(fileNamesAsending.description)
                Text(fileNamesDesending.description)
            }.padding()
            VStack() {
                Text("extensionsAsending/Desending")
                Text(extensionsAsending.description)
                Text(extensionsDesending.description)
            }.padding()
            VStack() {
                Text("fileExtensionsDescending")
                Text(fileExtensionsDescending.description)
            }.padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
