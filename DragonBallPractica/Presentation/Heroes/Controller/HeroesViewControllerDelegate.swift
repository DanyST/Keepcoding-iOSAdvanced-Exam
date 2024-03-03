import Foundation

protocol HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? { get set }
    var title: String { get }
    var dataCount: Int { get }
    func onViewsLoaded()
    func heroCellModel(at index: Int) -> HeroCellModel?
    func onItemSelected(at index: Int)
    func logoutButtonDidtap()
    func mapButtonDidTap()
}
