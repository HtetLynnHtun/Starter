//
//  playground.swift
//  Starter
//
//  Created by kira on 05/02/2022.
//

import Foundation

var colors = ["red", "green", "blue"]
var regionList : Set = ["Yangon", "Mandalay", "Shan"]
var townShipList : [String: [String]] = [
    "Yangon": ["Tarmwe", "Yankin", "Insein"]
]

var doOnNext:((String) -> String)? = nil

func main() {
    print("Hello from main")
    let name = "Htet Lynn Htun"
    
    colors.append("Yellow")
    let townships = townShipList["Yangon"] ?? []
    print(townships)
    
    var indexForWhile = 0
    while indexForWhile < 3 {
        print("While loop")
        print(colors[indexForWhile])
        indexForWhile += 1
    }
    
    var indexForRWhile = 0
    repeat {
        print("Repeat loops")
        print(colors[indexForRWhile])
        indexForRWhile += 1
    } while indexForRWhile < 3
    
    doOnNext = { name in
        debugPrint("Hello, \(name)")
        return "Hello, \(name)"
    }
    
    var incrementBy5 = makeIncrementer(forIncrement: 5)
    incrementBy5()
    print(incrementBy5())
    
    
    decrease(total: 10, doDecrease: {
        print("This is not trailing")
    })
    
    decrease(total: 20) {
        print("This is trailing")
    }
    
    let mayBeString: String
    mayBeString = "Hello"
    print(mayBeString)
}

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

func decrease(total: Int, doDecrease: () -> Void) -> Void {
//    we can call doDecrease inside this
    print("Decrease process")
}
