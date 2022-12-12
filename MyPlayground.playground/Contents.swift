import UIKit

protocol AProtocol {
  associatedtype AType: BProtocol
  var model: AType { get set }
}

protocol BProtocol {}
class B: BProtocol {}

protocol CProtocol: BProtocol {}
class C: CProtocol {}

Codable

class A: AProtocol {
//    typealias AType = CProtocol
  var model: AType

  init() {
    self.model = C()
  }
}
