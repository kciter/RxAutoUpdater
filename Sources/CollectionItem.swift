
import Foundation

public class CollectionItem<Element>: VariableArray<Element> {
    public override init() {
        super.init()
    }
    
    public override init(count: Int, repeatedValue: Element) {
        super.init(count: count, repeatedValue: repeatedValue)
    }
    
    public override init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
        super.init(sequence)
    }

	public required init(arrayLiteral elements: Element...) {
	    super.init()
	    self.elements = elements
	}
}
