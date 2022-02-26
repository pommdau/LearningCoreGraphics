/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

@IBDesignable class CounterView: UIView {
    
    // MARK: - Properties
    
    private struct Constants {
        static let numberOfGlasses = 8  // 一日に飲むグラスの目標
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counter: Int = 5 {  // グラスの消費数
        didSet {
            if counter <= Constants.numberOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height)
        let startAngle: CGFloat = 3 * .pi / 4  // 135度
        let endAngle: CGFloat = .pi / 4  // 45度
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius / 2 - Constants.arcWidth / 2,  // Strokeの中心を通る
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        // Draw the outline
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle  // e.g. 2π - 3/4π + π/4 = 3/2π = 270度
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        
        // Draw the outer arc
        let outerArcRadius = bounds.width / 2 - Constants.halfOfLineWidth
        let outlinePath = UIBezierPath(
            arcCenter: center,
            radius: outerArcRadius,
            startAngle: startAngle,
            endAngle: outlineEndAngle,
            clockwise: true)
        
        // Draw the inner arc
        let innerArcRadius = bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth  // Strokeの内側を通る
        outlinePath.addArc(
            withCenter: center,
            radius: innerArcRadius,
            startAngle: outlineEndAngle,
            endAngle: startAngle,
            clockwise: false)
        
        outlinePath.close()
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
        
        /**マーカの表示**/
        // Counter View markers
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // 1 - Save original state
        context.saveGState()
        outlineColor.setFill()
        
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        
        // 2 - The marker rectangle positioned at the top left
        let markerPath = UIBezierPath(rect: CGRect(
            x: -markerWidth / 2,
            y: 0,
            width: markerWidth,
            height: markerSize))
        
        // 3 - 中央に移動
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...Constants.numberOfGlasses {
            // 4 - Save the centered context
            context.saveGState()
            // 5 - Calculate the rotation angle
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            // Rotate and translate
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            
            // 6 - Fill the marker rectangle
            markerPath.fill()
            // 7 - Restore the centered context for the next rotate
            context.restoreGState()
        }
        
        // 8 - Restore the original state in case of more painting
        context.restoreGState()
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
}
