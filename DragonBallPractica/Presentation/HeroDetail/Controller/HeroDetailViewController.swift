import UIKit
import MapKit

final class HeroDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var loadingMapView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Properties
    var viewModel: HeroDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        initViews()
        setObservers()
        viewModel?.onViewsLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}

private extension HeroDetailViewController {
    func initViews() {
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        nameLabel.numberOfLines = 0
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    func setObservers() {
        viewModel?.viewState = { [weak self] state in
            guard let self else { return }
            DispatchQueue.main.async {
                switch state {
                case let .loading(isLoading):
                    self.updateLoadingMapView(isLoading: isLoading)
                case let .updateHero(hero):
                    self.updateSubViews(by: hero)
                case let .updateMap(heroAnnotations):
                    self.updateMapView(with: heroAnnotations)
                }
            }
        }
    }
}

private extension HeroDetailViewController {
    func updateSubViews(by hero: Hero) {
        updateImageView(photo: hero.photo)
        updateNameLabel(name: hero.name)
        updateDescriptionLabel(description: hero.description)
    }
    
    func updateMapView(with heroAnnotations: [HeroAnnotation]) {
        mapView.showAnnotations(heroAnnotations, animated: true)
    }
    
    func updateLoadingMapView(isLoading: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.loadingMapView.alpha = if isLoading { 1 } else { 0 }
        } completion: { [weak self] _ in
            self?.loadingMapView.isHidden = !isLoading
        }
    }
 
    func updateImageView(photo: String?) {
        let url = URL(string: photo ?? "")
        imageView.kf.setImage(with: url)
    }
    
    func updateNameLabel(name: String) {
        nameLabel.text = name
    }
    
    func updateDescriptionLabel(description: String?) {
        descriptionTextView.text = (description ?? "") + (description ?? "")
    }
}

extension HeroDetailViewController {
    @IBAction func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
