import Foundation

enum Hour: String, CaseIterable {
  case hour1 = "1"
  case hour2 = "2"
  case hour3 = "3"
  case hour4 = "4"
  case hour5 = "5"
  case hour6 = "6"
  case hour7 = "7"
  case hour8 = "8"
  case hour9 = "9"
  case hour10 = "10"
  case hour11 = "11"
  case hour12 = "12"
  
  var angle: Double {
    switch self {
    case .hour1:
      return 5*Double.pi/6
    case .hour2:
      return 2*Double.pi/3
    case .hour3:
      return Double.pi/2
    case .hour4:
      return Double.pi/3
    case .hour5:
      return Double.pi/6
    case .hour6:
      return 2*Double.pi
    case .hour7:
      return 11*Double.pi/6
    case .hour8:
      return 5*Double.pi/3
    case .hour9:
      return 3*Double.pi/2
    case .hour10:
      return 4*Double.pi/3
    case .hour11:
      return 7*Double.pi/6
    case .hour12:
      return Double.pi
    }
  }
}
