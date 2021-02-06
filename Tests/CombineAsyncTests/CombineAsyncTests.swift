import XCTest
@testable import CombineAsync
import Combine

final class CombineAsyncTests: XCTestCase {
    
    var cancels = Set<AnyCancellable>()
    
    func testForOriginExample() {
        let exp = expectation(description: "")

        
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
                    
                    exp.fulfill()
                }.store(in: &self.cancels)

            }.store(in: &self.cancels)

        }.store(in: &cancels)
        
        waitForExpectations(timeout: 10, handler: nil)

    }
    
    func testForNormalExample() {
        
        let exp = expectation(description: "")
        async {
            do {
                let a = try await(self.background1())
                let b = try await(self.background2(c: a))
                let c = try await(self.background3(c: b))
                main {
                    print(c)
                    exp.fulfill()
                }
            } catch {
                throw error
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testForCancelExample() {
        
        let exp = expectation(description: "")
        
        let future1 = async { () -> Int in
            let a = try await(self.background1())
            return a
        }
        
        let future = async { () -> Int in
            let a = try await(future1)
            let b = try await(self.background2(c: a))
            let c = try await(self.background3(c: b))
            print(c)
            return c
        }
        future1.cancel?.cancel()
        future.cancel?.cancel()

        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    func background1() -> Future<Int, Error> {
        return Future<Int, Error> { promise in
            let i:Int = Int(arc4random() % 100)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(i)) {
//                promise(.failure(NSError(domain: "a", code: -1, userInfo: nil)))
                promise(.success(1))

            }
        }
    }
    
    func background2(c: Int) -> Future<Int, Error> {
        return Future<Int, Error> { promise in
            let i:Int = Int(arc4random() % 100)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(i)) {
                promise(.success(c + 10))
            }
        }
    }
    
    func background3(c: Int) -> Future<Int, Error> {
        return Future<Int, Error> { promise in
            let i:Int = Int(arc4random() % 100)
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(i)) {
                promise(.success(c + 100))
            }
        }
    }

    static var allTests = [
        ("testForNormalExample", testForNormalExample),
        ("testForCancelExample", testForCancelExample),

    ]
}
