import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(text: String, isSelected: Bool) {
        categoryLabel.text = text
        categoryLabel.textColor = isSelected ? .black : AppColor.disableText
        bottomView.isHidden = !isSelected
    }
}
