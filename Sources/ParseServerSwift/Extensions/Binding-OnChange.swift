//
//  Binding-OnChange.swift
//  Lokality
//
//  See: https://www.youtube.com/watch?v=qkcKTJhDyLs
//
//  Created by Jayson Ng on 10/1/21.
//

import SwiftUI

extension Binding {

    // onChange
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
    // to use:
    //
    // struct ContentView: View {
    //    @State private var name = ""
    //
    //    var body: some View {
    //        TextField("Enter your name:", text: $name.onChange(nameChanged))
    //            .textFieldStyle(.roundedBorder)
    //    }
    //
    //    func nameChanged(to value: String) {
    //        print("Name changed to \(name)!")
    //    }
    // }

    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }

    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
