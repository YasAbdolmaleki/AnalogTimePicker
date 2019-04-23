import UIKit

public class AnalogTimePicker: AnalogTimePicking {
  
  // MARK: Radius
  
  private let clockRadius: CGFloat
  private let hourRadius: CGFloat
  
  // MARK: Colors
  
  private let clockColor: CGColor
  private let hourCircleColor: CGColor
  private let selectedHourCircleColor: CGColor
  private let timeTextColor: CGColor
  
  private let viewContainer: UIView
  
  private var handleLayer: CAShapeLayer = CAShapeLayer()
  
  public init(
    hourSizeRatio: CGFloat,
    hourColor: UIColor = UIColor(red:0.45, green:0.01, blue:0.01, alpha:1.0),
    selectedHourColor: UIColor = UIColor(red:0.10, green:0.60, blue:0.42, alpha:1.0),
    clockColor: UIColor = UIColor(red:0.45, green:0.01, blue:0.01, alpha:1.0),
    timeTextColor: UIColor = UIColor.white,
    viewContainer: UIView
  ) {
    self.clockRadius = viewContainer.frame.width/2
    self.hourRadius = (clockRadius*2)*hourSizeRatio
    self.hourCircleColor = hourColor.cgColor
    self.clockColor = clockColor.cgColor
    self.selectedHourCircleColor = selectedHourColor.cgColor
    self.timeTextColor = timeTextColor.cgColor
    self.viewContainer = viewContainer
  }
  
  // MARK: - Public Functions
  
  public func drawTimePicker() {
    drawClock()
    drawEachTime()
  }
  
  public func selectedTime(_ touches: Set<UITouch>) -> Int {
    guard let point = touches.first?.location(in: viewContainer) else { return 0 }
    guard let sublayers = viewContainer.layer.sublayers as? [CAShapeLayer] else { return 0 }
    
    var selectedHour: Int?
    for layer in sublayers {
      guard let name = layer.name, let angle = Hour(rawValue: name)?.angle else { continue }
      
      if layer.fillColor == selectedHourCircleColor {
        layer.fillColor = hourCircleColor
      }
      
      if let path = layer.path, path.contains(point) {
        layer.fillColor = selectedHourCircleColor
        handleLayer.removeFromSuperlayer()
        drawHandle(at: pointToCircle(at: angle))
        selectedHour = Int(name)
      }
    }
    
    guard let hour = selectedHour else { return 0 }
    return hour
  }
  
  // MARK: - Draw Inital Clock
  
  private func drawClock() {
    let circlePath = UIBezierPath(
      arcCenter: CGPoint(x: clockRadius,y: clockRadius),
      radius: CGFloat(clockRadius),
      startAngle: CGFloat(0),
      endAngle:CGFloat(Double.pi * 2),
      clockwise: true
    )
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = circlePath.cgPath
    shapeLayer.fillColor = clockColor
    
    viewContainer.layer.addSublayer(shapeLayer)
  }
  
  private func drawEachTime() {
    let hours: [Hour] = Hour.allCases
    
    hours.forEach { hour in
      viewContainer.layer.addSublayer(drawCircle(at: hour))
    }
  }
  
  private func drawCircle(at hour: Hour) -> CAShapeLayer {
    let circlePoint = positionCircle(at: hour.angle)
    
    let circlePath = UIBezierPath(
      arcCenter: circlePoint,
      radius: hourRadius,
      startAngle: CGFloat(0),
      endAngle:CGFloat(Double.pi * 2),
      clockwise: true
    )
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.name = hour.rawValue
    shapeLayer.path = circlePath.cgPath
    shapeLayer.fillColor = hourCircleColor
    
    let textLayer = CATextLayer()
    textLayer.string = hour.rawValue
    textLayer.fontSize = hourRadius*0.8
    textLayer.foregroundColor = timeTextColor
    textLayer.alignmentMode = .center
    
    let midRadius = hourRadius/2
    let origin = CGPoint(x: circlePoint.x-midRadius, y: circlePoint.y-midRadius)
    let size = CGSize(width: hourRadius, height: hourRadius)
    textLayer.frame = CGRect(origin: origin, size: size)
    
    shapeLayer.addSublayer(textLayer)
    
    return shapeLayer
  }
  
  private func positionCircle(at angle: Double) -> CGPoint {
    return CGPoint(
      x: (clockRadius-hourRadius) * CGFloat(sin(angle)) + clockRadius,
      y: (clockRadius-hourRadius) * CGFloat(cos(angle)) + clockRadius
    )
  }
  
  // MARK: - Handle Time Selection
  
  private func drawHandle(at point: CGPoint) {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: clockRadius, y: clockRadius))
    path.addLine(to: point)
    
    handleLayer.path = path.cgPath
    handleLayer.name = "handleLayer"
    handleLayer.strokeColor = selectedHourCircleColor
    handleLayer.lineWidth = 3.0
    
    viewContainer.layer.addSublayer(handleLayer)
  }

  private func pointToCircle(at angle: Double) -> CGPoint {
    return CGPoint(
      x: (clockRadius-2*hourRadius) * CGFloat(sin(angle)) + clockRadius,
      y: (clockRadius-2*hourRadius) * CGFloat(cos(angle)) + clockRadius
    )
  }
}
