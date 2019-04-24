import UIKit

public class AnalogTimePicker {
  
  private var clockDialLayer: CAShapeLayer = CAShapeLayer()
  
  // MARK: - Dependencies
  
  private let viewContainer: UIView
  
  private let clockFaceRadius: CGFloat
  private let clockDialRadius: CGFloat
  
  private let clockFaceColor: CGColor
  private let clockDialColor: CGColor
  private let clockDialTextColor: CGColor
  private let selectedClockDialColor: CGColor
  
  private let clockDialTextFont: UIFont?
 
  public init(
    viewContainer: UIView,
    clockDialSizeRatioToClockFace: CGFloat = 0.08,
    clockDialColor: UIColor = UIColor.maroon,
    selectedClockDialColor: UIColor = UIColor.forestGreen,
    clockFaceColor: UIColor = UIColor.salmon,
    clockDialTextColor: UIColor = UIColor.white,
    clockDialTextFont: UIFont? = UIFont(name: "Arial-BoldMT", size: 17.0)
  ) {
    self.viewContainer = viewContainer
    self.clockFaceRadius = viewContainer.frame.width/2
    self.clockDialRadius = (clockFaceRadius*2)*clockDialSizeRatioToClockFace
    self.clockDialColor = clockDialColor.cgColor
    self.clockFaceColor = clockFaceColor.cgColor
    self.selectedClockDialColor = selectedClockDialColor.cgColor
    self.clockDialTextColor = clockDialTextColor.cgColor
    self.clockDialTextFont = clockDialTextFont
  }
  
  // MARK: - Draw Clock
  
  private func drawClockFace() {
    let layer = circleShapeLayer(radius: clockFaceRadius, fillColor: clockFaceColor)
    viewContainer.layer.addSublayer(layer)
  }
  
  private func drawClockPivot() {
    let layer = circleShapeLayer(radius: clockFaceRadius*0.03, fillColor: selectedClockDialColor)
    viewContainer.layer.addSublayer(layer)
  }
  
  private func drawClockDial() {
    Hour.allCases.forEach { time in
      drawTimeCircleWithText(for: time)
    }
  }
  
  private func drawTimeCircleWithText(for time: Hour) {
    let coordinate = calculateCoordinate(at: time.angle, minus: clockDialRadius)
    let layer = circleShapeLayer(radius: clockDialRadius, fillColor: clockDialColor, name: time.rawValue, arcCenter: coordinate)
    
    let textLayer = CATextLayer()
    textLayer.string = time.rawValue
    textLayer.font = clockDialTextFont
    textLayer.fontSize = clockDialRadius*0.8
    textLayer.foregroundColor = clockDialTextColor
    textLayer.alignmentMode = .center
    
    let midRadius = clockDialRadius/2
    let origin = CGPoint(x: coordinate.x-midRadius, y: coordinate.y-midRadius)
    let size = CGSize(width: clockDialRadius, height: clockDialRadius)
    textLayer.frame = CGRect(origin: origin, size: size)
    
    layer.addSublayer(textLayer)
    viewContainer.layer.addSublayer(layer)
  }
  
  // MARK: - Handle Selected Time
  
  private func drawClockHand(at angle: Double) {
    let point = calculateCoordinate(at: angle, minus: 2*clockDialRadius)
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: clockFaceRadius, y: clockFaceRadius))
    path.addLine(to: point)
    
    clockDialLayer.path = path.cgPath
    clockDialLayer.strokeColor = selectedClockDialColor
    clockDialLayer.lineWidth = 3.0
    
    viewContainer.layer.addSublayer(clockDialLayer)
  }
  
  // MARK: - Helper
  
  private func calculateCoordinate(at angle: Double, minus axis: CGFloat) -> CGPoint {
    return CGPoint(
      x: (clockFaceRadius-axis) * CGFloat(sin(angle)) + clockFaceRadius,
      y: (clockFaceRadius-axis) * CGFloat(cos(angle)) + clockFaceRadius
    )
  }
  
  private func circleShapeLayer(radius: CGFloat, fillColor: CGColor, name: String? = nil, arcCenter: CGPoint? = nil) -> CAShapeLayer {
    let circlePath = UIBezierPath(
      arcCenter: arcCenter ?? CGPoint(x: clockFaceRadius,y: clockFaceRadius),
      radius: radius,
      startAngle: CGFloat(0),
      endAngle:CGFloat(Double.pi * 2),
      clockwise: true
    )
    
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = circlePath.cgPath
    shapeLayer.fillColor = fillColor
    shapeLayer.name = name
    
    return shapeLayer
  }
}


extension AnalogTimePicker: AnalogTimePicking {
  public func draw() {
    drawClockFace()
    drawClockPivot()
    drawClockDial()
  }
  
  public func selectedTime(_ touches: Set<UITouch>) -> Int {
    guard
      let point = touches.first?.location(in: viewContainer),
      let sublayers = viewContainer.layer.sublayers as? [CAShapeLayer] else { return 0 }
    
    var selectedHour: Int?
    sublayers.forEach { layer in
      guard let name = layer.name, let angle = Hour(rawValue: name)?.angle else { return }
      
      if layer.fillColor == selectedClockDialColor {
        layer.fillColor = clockDialColor
      }
      
      guard let path = layer.path, path.contains(point) else { return }
      
      layer.fillColor = selectedClockDialColor
      clockDialLayer.removeFromSuperlayer()
      drawClockHand(at: angle)
      selectedHour = Int(name)
    }
    
    guard let hour = selectedHour else { return 0 }
    return hour
  }
}
