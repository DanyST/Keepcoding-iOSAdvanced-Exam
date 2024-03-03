import Foundation

protocol HeroesMapViewControllerDelegate {
    var title: String { get }
    var viewState: ((HeroesMapViewState) -> Void)? { get set }
    func onViewsLoaded()
    func didSelect(heroAnnotation: HeroAnnotation)
}
