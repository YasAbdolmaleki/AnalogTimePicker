import Foundation

public protocol AnalogTimePicking {
  func drawTimePicker()
  func selectedTime(_ touches: Set<UITouch>) -> Int
}
