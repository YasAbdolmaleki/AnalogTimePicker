import Foundation

public protocol AnalogTimePicking {
  func draw()
  func selectedTime(_ touches: Set<UITouch>) -> Int
}
