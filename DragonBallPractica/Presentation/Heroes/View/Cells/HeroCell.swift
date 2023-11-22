import UIKit
import Kingfisher

final class HeroCell: UITableViewCell {
    
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var opacityView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        heroImageView.layer.cornerRadius = 8
        heroImageView.clipsToBounds = true
        heroImageView.layer.shadowRadius = 8
        heroImageView.layer.shadowOffset = .zero
        heroImageView.layer.shadowColor = UIColor.gray.cgColor
        heroImageView.layer.shadowOpacity = 0.4
        opacityView.layer.cornerRadius = 8
        opacityView.clipsToBounds = true
        opacityView.layer.opacity = 0.25
        
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
