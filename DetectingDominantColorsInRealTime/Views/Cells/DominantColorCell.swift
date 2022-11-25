

import UIKit

class DominantColorCell: UITableViewCell {
    
    
    @IBOutlet weak var RColorLabel: UILabel!
    @IBOutlet weak var GColorLabel: UILabel!
    @IBOutlet weak var BColorLabel: UILabel!
    @IBOutlet weak var colorCoveragePercentageLabel: UILabel!
    @IBOutlet weak var backgroundColorUiView: UIView!
    
    static let identifierCell = "DominantColorCell"
    static let nibName = "DominantColorCell"
    static let heightCell:CGFloat = 90
    
    static func getNibCell()->UINib {
        return UINib(nibName:DominantColorCell.nibName, bundle: nil)
        
    }
    
    
    
    func setupData(color:DominantColor) {
        RColorLabel.text = color.RGBcolor.RColor.toString()
        GColorLabel.text = color.RGBcolor.GColor.toString()
        BColorLabel.text = color.RGBcolor.BColor.toString()
        
        
        backgroundColorUiView.backgroundColor = UIColor(red: color.RGBcolor.RColor, green: color.RGBcolor.GColor, blue: color.RGBcolor.BColor)
        
        
        if let colorCoveragePercentage = color.colorCoveragePercentage {
            colorCoveragePercentageLabel.text = colorCoveragePercentage.AddPercentageToString()
        }
    }
    
    
}
