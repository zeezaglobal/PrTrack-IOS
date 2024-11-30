//
//  BarGraphView.swift
//  FitCanada
//
//  Created by Vijin Raj on 29/11/24.
//

import Foundation
import UIKit

class BarGraphView: UIView {
    var data: [CGFloat] = [10, 40, 50, 60, 55, 70, 65] // Example data
    var labels: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var targetWeight: CGFloat = 60 // Example target weight
    let yAxisStep: CGFloat = 7 // Y-axis step size for labels
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let width = rect.width
        let height = rect.height
        
        // Calculate space for Y-axis labels
        let yAxisLabelWidth: CGFloat = 40
        let availableWidth = width - yAxisLabelWidth
        let maxData = data.max() ?? 1
        let numberOfSteps = 6 // Fixed number of Y-axis points
        let yAxisStep = ceil(maxData / CGFloat(numberOfSteps - 1))
        let scaleFactor = height / (yAxisStep * CGFloat(numberOfSteps - 1))
        
        // Adjust the bar width and spacing
        let totalSpacing = availableWidth * 0.2 // Adjust this factor to control spacing
        let barWidth = (availableWidth - totalSpacing) / CGFloat(data.count)
        let barSpacing = totalSpacing / CGFloat(data.count + 1)
        
        // Clear existing subviews
        subviews.forEach { $0.removeFromSuperview() }
        
        // Draw Y-axis labels
        for i in 0..<numberOfSteps {
            let yValue = CGFloat(i) * yAxisStep
            let y = height - (yValue * scaleFactor)
            
            // Label for Y-axis value
            let label = UILabel(frame: CGRect(x: 0, y: y - 10, width: yAxisLabelWidth, height: 20))
            label.text = "\(Int(yValue))kg"
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            addSubview(label)
            
            // Gridline
            context.setStrokeColor(UIColor.gray.withAlphaComponent(0.5).cgColor)
            context.setLineWidth(0.5)
            context.move(to: CGPoint(x: yAxisLabelWidth, y: y))
            context.addLine(to: CGPoint(x: width, y: y))
            context.strokePath()
        }
        
        // Draw bars with rounded top-left and top-right corners
        for (index, value) in data.enumerated() {
            let x = yAxisLabelWidth + barSpacing + (barWidth + barSpacing) * CGFloat(index)
            let barHeight = value * scaleFactor
            let y = height - barHeight
            
            // Final rectangle for the bar
            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            let barPath = UIBezierPath(roundedRect: barRect,
                                       byRoundingCorners: [.topLeft, .topRight],
                                       cornerRadii: CGSize(width: barWidth * 0.2, height: barWidth * 0.2))
            
            // Start with zero height
            let startBarRect = CGRect(x: x, y: height, width: barWidth, height: 0)
            let startBarPath = UIBezierPath(roundedRect: startBarRect,
                                            byRoundingCorners: [.topLeft, .topRight],
                                            cornerRadii: CGSize(width: barWidth * 0.2, height: barWidth * 0.2))
            
            // Create a shape layer
            let barLayer = CAShapeLayer()
            barLayer.path = barPath.cgPath
            barLayer.fillColor = (index == data.count - 1 ? UIColor(named: "AppPrimaryColor") : UIColor.gray)?.cgColor
            layer.addSublayer(barLayer)
            
            // Animate the bar height
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = startBarPath.cgPath
            animation.toValue = barPath.cgPath
            animation.duration = 0.5 // Animation duration for each bar
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            barLayer.add(animation, forKey: "barAnimation")
            
            // Add a red line for the last bar
            if index == data.count - 1 {
                guard let context = UIGraphicsGetCurrentContext() else { continue }
                context.setStrokeColor(UIColor.red.cgColor)
                context.setLineWidth(1)
                context.setLineDash(phase: 0, lengths: [4, 2]) // Dash pattern: 4 points solid, 2 points space
                context.move(to: CGPoint(x: yAxisLabelWidth, y: y))
                context.addLine(to: CGPoint(x: rect.width, y: y))
                context.strokePath()
            }
            
            // Draw X-axis labels (under each bar)
            let label = UILabel(frame: CGRect(x: x, y: height + 5, width: barWidth, height: 20))
            label.text = labels[index]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 10)
            label.textColor = .white
            addSubview(label)
            
            // Draw bar value
            let valueLabel = UILabel(frame: CGRect(x: x, y: y - 20, width: barWidth, height: 20))
            valueLabel.text = "\(value)kg"
            valueLabel.textAlignment = .center
            valueLabel.font = UIFont.systemFont(ofSize: 10)
            valueLabel.textColor = .white
            addSubview(valueLabel)
        }
    }
}
