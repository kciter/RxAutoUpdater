
import Foundation
import RxSwift
import RxCocoa

public enum VariableArrayChangeEventType {
    case Insert
    case Remove
    case Update
}

public struct VariableArrayChangeEvent<Element> {
    public let type: VariableArrayChangeEventType
    public let values: [Element]
    public let indexes: [Int]
    
    private init(type: VariableArrayChangeEventType, values: [Element], indexes: [Int]) {
        self.type = type
        self.values = values
        self.indexes = indexes
    }
}

public class VariableArray<Element>: ArrayLiteralConvertible {
    public typealias E = Element
    
    public let rx_changeEvent = PublishSubject<VariableArrayChangeEvent<Element>>()
    
    public var elements: [E]
    
    public init() {
        elements = []
    }
    
    public init(count:Int, repeatedValue: Element) {
        elements = Array(count: count, repeatedValue: repeatedValue)
    }
    
    public init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
        elements = Array(sequence)
    }
    
    public required init(arrayLiteral elements: Element...) {
        self.elements = elements
    }
    
    public func asObservable() -> Observable<[E]> {
        return Observable.just(elements)
    }
    
    public func toObservable() -> Observable<E> {
        return elements.toObservable()
    }
    
    deinit {
        rx_changeEvent.on(.Completed)
    }
}

// Append Extension
extension VariableArray {
    public func append(element: Element) {
        self.elements.append(element)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Insert,
                values: [element],
                indexes: [self.elements.count-1])
            )
        )
    }
    
    public func append(arrayLiteral elements: Element...) {
        self.elements.appendContentsOf(elements)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Insert,
                values: elements,
                indexes: Array((self.elements.count-elements.count)...elements.count))
            )
        )
    }
    
    public func append<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
        let elements = Array(sequence)
        self.elements.appendContentsOf(elements)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Insert,
                values: elements,
                indexes: Array((self.elements.count-elements.count)...elements.count))
            )
        )
    }
}

// Remove Extension
extension VariableArray {
    public func removeAll(keepCapacity: Bool = false) {
        let tempElements = self.elements
        self.elements.removeAll(keepCapacity: keepCapacity)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Remove,
                values: tempElements,
                indexes: Array(0..<tempElements.count))
            )
        )
    }
    
    public func removeLast(n: Int = 1) {
        guard self.elements.isEmpty == false else {
            return
        }
        
        let start = self.elements.count-n
        let end = self.elements.count-1
        let tempElements = Array(self.elements[(self.elements.count-n)...(self.elements.count-1)])
        self.elements.removeLast(n)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Remove,
                values: tempElements,
                indexes: Array(start..<(end+1)))
            )
        )
    }
    
    public func removeFirst(n: Int = 1) {
        guard self.elements.isEmpty == false else {
            return
        }
        
        let tempElements = Array(self.elements[0...(n-1)])
        self.elements.removeFirst(n)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Remove,
                values: tempElements,
                indexes: Array(0..<n))
            )
        )
    }
    
    public func removeAtIndex(index: Int) {
        let element = self.elements.removeAtIndex(index)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Remove,
                values: [element],
                indexes: [index])
            )
        )
    }
    
    public func removeRange(subRange: Range<Int>) {
        let tempElements = Array(self.elements[subRange])
        self.elements.removeRange(subRange)
        rx_changeEvent.on(.Next(
            VariableArrayChangeEvent<Element>(
                type: .Remove,
                values: tempElements,
                indexes: Array(subRange))
            )
        )
    }
}

extension VariableArray: Indexable {
    public var startIndex: Int {
        return elements.startIndex
    }
    
    public var endIndex: Int {
        return elements.endIndex
    }
}

extension VariableArray: CollectionType {
    public subscript(index: Int) -> Element {
        get {
            return elements[index]
        }
        set {
            elements[index] = newValue
            if index == elements.count {
                rx_changeEvent.on(.Next(
                    VariableArrayChangeEvent<Element>(
                        type: .Insert,
                        values: [newValue],
                        indexes: [index])
                    )
                )
            } else {
                rx_changeEvent.on(.Next(
                    VariableArrayChangeEvent<Element>(
                        type: .Update,
                        values: [newValue],
                        indexes: [index])
                    )
                )
            }
        }
    }
    
    public subscript(bounds: Range<Int>) -> ArraySlice<Element> {
        get {
            return elements[bounds]
        }
        set {
            elements[bounds] = newValue
            rx_changeEvent.on(.Next(
                VariableArrayChangeEvent<Element>(
                    type: .Update,
                    values: Array(elements[bounds]),
                    indexes: Array(bounds))
                )
            )
        }
    }
    
    public func generate() -> IndexingGenerator<[Element]> { // <===
        return IndexingGenerator(elements)
    }
}

extension VariableArray: CustomDebugStringConvertible {
    public var description: String {
        return elements.description
    }
}

extension VariableArray: CustomStringConvertible {
    public var debugDescription: String {
        return elements.debugDescription
    }
}
