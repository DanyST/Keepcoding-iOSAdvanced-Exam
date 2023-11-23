import UIKit
import Kingfisher

final class HeroCell: UITableViewCell {
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var containerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cornerRadius: CGFloat = 8.0
        
        heroImageView.layer.cornerRadius = cornerRadius
        heroImageView.clipsToBounds = true
       
        opacityView.layer.cornerRadius = cornerRadius
        opacityView.layer.opacity = 0.25
        
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.shadowRadius = cornerRadius
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 0.4
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        heroImageView.image = nil
        nameLabel.text = nil
        heroImageView.kf.cancelDownloadTask()
    }
}

extension HeroCell {
    func updateViews(model: HeroCellModel) {
        update(name: model.name)
        update(photo: model.photo)
    }
    
    private func update(name: String?) {
        nameLabel.text = name
    }
    
    private func update(photo: String?) {
        let url = URL(string: photo ?? "")
        heroImageView.kf.setImage(with: url)
    }
}

extension HeroCell: ReusableView {}
