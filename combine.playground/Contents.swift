import UIKit
import Combine
import SwiftUI
/*
let _ = Just("Hello world")
    .sink { (value) in
        print("value is \(value)")
    }

let notification = Notification(name: .NSSystemClockDidChange, object: nil, userInfo: nil)
let noficiationClockPublisher = NotificationCenter.default.publisher(for: .NSSystemClockDidChange)
    .sink { value in
         print("value is \(value)")
    }
NotificationCenter.default.post(notification)

[1, 5, 9]
    .publisher
    .map { $0 * $0 }
    .sink { print($0) }


let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

struct Task: Decodable {
    let id: Int
    let title: String
    let userId: Int
    let body: String
}

let dataPublisher = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Task].self, decoder: JSONDecoder())

let cancellableSink = dataPublisher
    .sink { completion in
        print(completion)
    } receiveValue: { items in
        print("Result is \(items[0].title)")
    }

[1,5,9]
    .publisher
    .sink { print($0) }

let label = UILabel()
Just("John")
    .map { "My name is \($0)"}
    .assign(to: \.text, on: label)

let subject = PassthroughSubject<Int, Never>()
let subscription = subject
    .sink { print("this is the subscription \($0)") }

subject.send(94)
subject.send(33)

Just(29)
    .subscribe(subject)

let anotherSubject = CurrentValueSubject<String, Never>("I am a...")
let anotherSubscription = anotherSubject
    .sink { print($0)}

anotherSubject.send("Subject")
 

let _ = Just("A data stream")
    .sink { (value) in
        print("value is \(value)")
    }

let subject2 = PassthroughSubject<Int, Never>()

Just(29)
    .subscribe(subject2)

enum FutureError: Error {
    case notMultiple
}

let future = Future<String, FutureError> { promise in
    let calendar = Calendar.current
    let second = calendar.component(.second, from: Date())
    print("second is \(second)")
    if (second.isMultiple(of: 3)) {
        promise(.success("Successful: \(second)"))
    } else {
        promise(.failure(.notMultiple))
    }
}.catch { error in
    Just("Caught the error")
}
.delay(for: .init(1), scheduler: RunLoop.main)
.eraseToAnyPublisher()

future.sink(receiveCompletion: {print($0)}, receiveValue: {print($0)})
 

let tf = UITextField()
let subject = PassthroughSubject<Bool, Never>()
let subscription = subject
    .sink { (value) in
        tf.isEnabled = value
    }

Just([true, false, false])
    .map { $0[2] }
    .subscribe(subject)
 */

/*
let textField = UITextField()
let array = [true, false, false, false, false, true, true]
let publisher = array.publisher
let subscriber = publisher.assign(to: \.isEnabled, on: textField)
textField.publisher(for: \.isEnabled).sink{ print($0) }
let _ = publisher.dropFirst(2).sink{ print($0)}
*/
/*
// URL request
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
let samplePost = Post(userId: 1, id: 1, title: "this is a title", body: "this is a body")

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())

let cancellableSink = publisher
    .sink { completion in
        print(String(describing: completion))
    } receiveValue: { value in
        print("returned value \(value)")
    }
*/

/*
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

enum APIError: Error {
    case networkError(error: String)
    case responseError(error: String)
    case unknownError
}

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
let publisher = URLSession.shared.dataTaskPublisher(for: url!)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())

let cancellableSink = publisher
    .retry(2) // retry the call twice
    .mapError { error -> Error in
        switch error {
        case URLError.cannotFindHost:
            return APIError.networkError(error: error.localizedDescription)
        default:
            return APIError.responseError(error: error.localizedDescription)
        }
    }
    .sink { completion in
        print(String(describing: completion))
    } receiveValue: { value in
        print("returned value \(value)")
    }

Just(7)
    .tryMap { _ in
        throw APIError.unknownError
    }
    .catch { result in
        Just(2)
    }
    .sink { print($0) }
*/

/*
// tests
import XCTest

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
let samplePost = Post(userId: 1, id: 1, title: "this is a title", body: "this is a body")

enum APIError: Error {
    case networkError(error: String)
    case responseError(error: String)
    case invalidRequest
    case unknownError
}

struct APIService {
    static func getPosts() -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        let publisher = URLSession.shared.dataTaskPublisher(for: url!)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.invalidRequest
                }
                return data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        return publisher
    }
}

class MyTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    let expectedTitle = "this is a title"
    let expectedId = 1
    
    func testPublisher() {
        let _ = APIService.getPosts()
            .sink(receiveCompletion: { error in
                print("Completed subscription \(String(describing: error))")
            }, receiveValue: { results in
                print("Got \(results.count) posts back")
                XCTAssert(results.count > 0)
                XCTAssert(results.count == 100, "we got \(results.count) instead of 100 posts back")
                XCTAssert(results[0].title == self.expectedTitle, "got \(results[0].title) instead of \(self.expectedTitle)")
            })
            .store(in: &subscriptions)
    }
}

class TestObserver : NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        print("🚫 \(description) line:\(lineNumber)")
    }
    
    func testCaseDidFinish(_ testCase: XCTestCase) {
        if testCase.testRun?.hasSucceeded == true {
            print("✅ \(testCase)")
        }
    }
}

let observer = TestObserver()
XCTestObservationCenter.shared.addTestObserver(observer)

MyTests.defaultTestSuite.run()
 
*/
/*
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

let emptyPost = Post(userId: 0, id: 0, title: "Empty", body: "no results")
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())
    .map{ $0.first }
    .replaceNil(with: emptyPost)
    .compactMap({$0.title})

let cancellableSink = publisher
    .sink(receiveCompletion: { completion in
        print(String(describing: completion))
    }) { value in
        print(value)
    }
*/

/*
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

print("publisher: on main thread?: \(Thread.current.isMainThread)")
print("publisher: thread info: \(Thread.current)")

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
let queue = DispatchQueue(label: " a queue")
let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map { $0.data }
    .decode(type: [Post].self, decoder: JSONDecoder())

print("publisher: on main thread?: \(Thread.current.isMainThread)")
print("publisher: thread info: \(Thread.current)")

let cancellableSink = publisher
    .subscribe(on: queue)
//    .receive(on: DispatchQueue.main)
//    .receive(on: DispatchQueue.global())
    .sink { completion in
        print("subscriber: on main thread?: \(Thread.current.isMainThread)")
        print("subscriber: thread info: \(Thread.current)")
    } receiveValue: { value in
        print("subscriber: on main thread?: \(Thread.current.isMainThread)")
        print("subscriber: thread info: \(Thread.current)")
    }
*/

/*
// custom publisher

extension Publisher {
    func isPrimeInteger<T: BinaryInteger>() -> Publishers.CompactMap<Self, T> where
        Output == T {
        compactMap(self.isPrime)
    }
    
    func isPrime<T: BinaryInteger>(_ n: T) -> T? {
        guard n != 2 else { return n }
        guard n % 2 != 0 && n > 1 else { return nil }
        
        var i = 3
        while i * i <= n {
            if (Int(n) % i) == 0 {
                return nil
            }
            i += 2
        }
        
        return n
    }
}

let numbers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]

numbers.publisher.isPrimeInteger().sink { print( $0 )}
*/

// backpressure
let cityPublisher = (["San Jose", "San Francisco", "Menlo Park", "Palo Alto"]).publisher

final class CitySubscriber: Subscriber {
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    func receive(_ input: String) -> Subscribers.Demand {
        print("City: \(input)")
        return .none
    }
    func receive(completion: Subscribers.Completion<Never>) {
        print("subscription \(completion)")
    }
}

let citySubscription = CitySubscriber()
cityPublisher.subscribe(citySubscription)
