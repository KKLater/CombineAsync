# CombineAsync

[![Release](https://img.shields.io/badge/Release-v0.0.1-green)]()
![Install](https://img.shields.io/badge/Install-SPM-orange)
![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey)

[简体中文](https://github.com/KKLater/CombineAsync/blob/main/README_CN.md)

`Combineasync` 'is an encapsulation based on `Combine Future`. It encapsulates `Future` and provides `async` and `await` API to handle asynchronous events gracefully.

## Requirements

* macOS 10.15 + / iOS 13.0 + / tvOS 13.0 + / watchOS 6.0 +
* Swift 5.0+

If your project environment is MacOS 10.10 + / IOS 9.0 + / tvos 9.0 + / watchos 2.0 +, you have two options:

* [CombineXAsync](https://github.com/KKLater/CombineXAsync)：Base on [CombineX](https://github.com/cx-org/CombineX) 
* [OpenCombineAsync](https://github.com/KKLater/OpenCombineAsync)：Base on [OpenCombine](https://github.com/broadwaylamb/OpenCombine) 

## Installation

### Swift Package Manager (SPM)

Swift Package Manager is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

> Xcode 11+ is required to build `CombineAsync` using Swift Package Manager.

To integrate `CombineAsync` into your Xcode project using Swift Package Manager, add it to the dependencies value of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/KKLater/CombineAsync.git", .upToNextMajor(from: "0.0.1"))
]
```

## Usage

Asynchronous operations need to be wrapped as `Future` objects of `Combine`.

```swift
func background1() -> Future<Int, Error> {
    return Future<Int, Error> { promise in
        let i:Int = Int(arc4random() % 10)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.microseconds(i)) {
            promise(.success(1))
        }
    }
}

func background2(c: Int) -> Future<Int, Error> {
    return Future<Int, Error> { promise in
        let i:Int = Int(arc4random() % 10)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.microseconds(i)) {
            promise(.success(c + 10))
        }
    }
}

func background3(c: Int) -> Future<Int, Error> {
    return Future<Int, Error> { promise in
        let i:Int = Int(arc4random() % 10)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.microseconds(i)) {
            promise(.success(c + 100))
        }
    }
}
```

Before use `async` and  `await` api:

```swift
self.background1().sink { (error) in
    print(error)
} receiveValue: { (a) in
    self.background2(c: a).sink { (error) in
        print(error)
    } receiveValue: { (b) in
        self.background3(c: b).sink { (error) in
            print(error)
        } receiveValue: { (c) in
            print(c) // 111
        }.store(in: &self.cancels)

    }.store(in: &self.cancels)
}.store(in: &cancels)

```

After using the `async` and `await` APIs:

```swift
async {
    do {
        let a = try await(self.background1())
        let b = try await(self.background2(c: a))
        let c = try await(self.background3(c: b))
        main {
            print(c) // 111
        }
    } catch {
        throw error
    }
}
```

## License

`CombineAsync` is released under the `MIT` license. See `LICENSE` for details.

