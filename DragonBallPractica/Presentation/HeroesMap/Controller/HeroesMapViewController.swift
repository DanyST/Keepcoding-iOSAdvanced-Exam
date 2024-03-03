import UIKit
import MapKit

final class HeroesMapViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
        
    // MARK: - Properties
    var viewModel: HeroesMapViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.title
        initViews()
        setObservers()
        viewModel?.onViewsLoaded()
    }
}

// MARK: - Configure View
private extension HeroesMapViewController {
    func initViews() {
        mapView.delegate = self
    }
    
    func setObservers() {
        viewModel?.viewState = { state in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch state {
                case let .loading(isLoading):
                    self.updateLoadingView(isLoading: isLoading)
                case let .updateMap(heroAnnotations):
                    self.updateMap(by: heroAnnotations)
                case let .navigateToHeroDetail(hero):
                    self.navigateToHeroDetail(hero: hero)
                }
            }
        }
    }
}

// MARK: - Update Views
private extension HeroesMapViewController {
    func updateLoadingView(isLoading: Bool) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.loadingView.alpha = if isLoading { 1 } else { 0 }
        } completion: { [weak self] _ in
            self?.loadingView.isHidden = !isLoading
        }
    }
    
    func updateMap(by heroAnnotations: [HeroAnnotation]) {
        mapView.showAnnotations(heroAnnotations, animated: true)
    }
}

// MARK: - Navigation
private extension HeroesMapViewController {
    func navigateToHeroDetail(hero: Hero) {
        let storyboard = UIStoryboard.storyboard(.heroDetail)
        let viewController: HeroDetailViewController = storyboard.instantiateViewController()
        let getHeroLocationsUseCase = GetHeroLocationsUseCase()
        let heroLocationsToHeroAnnotationsMapper = HeroLocationsToHeroAnnotationsMapper()
        let viewModel = HeroDetailViewModel(
            hero: hero,
            getHeroLocationsUseCase: getHeroLocationsUseCase,
            heroLocationsToHeroAnnotationsMapper: heroLocationsToHeroAnnotationsMapper
        )
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - MKMapViewDelegate
extension HeroesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        guard let heroAnnotation = annotation as? HeroAnnotation else { return }
        viewModel?.didSelect(heroAnnotation: heroAnnotation)
    }
}
