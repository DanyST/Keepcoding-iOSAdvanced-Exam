import Foundation

final class HeroesViewModel {
    private var _viewState: ((HeroesViewState) -> Void)?
    
//    private var heroes = [Hero]()
    
    private func loadData() {
        viewState?(.loading(true))
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            // TODO: Obtener los heroes del backend y darle valor a la propiedad heroes
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                self.viewState?(.updateData)
                self.viewState?(.loading(false))
            }
        }
    }
}

extension HeroesViewModel: HeroesViewControllerDelegate {
    var viewState: ((HeroesViewState) -> Void)? {
        get {
            _viewState
        }
        set {
            _viewState = newValue
        }
    }
    
    var title: String {
        "Discover Heroes"
    }
    
    var dataCount: Int {
        2
    }
    
    func onViewsLoaded() {
        loadData()
    }
    
    func heroCellModel(at index: Int) -> HeroCellModel? {
        HeroCellModel(
            photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
            name: "Goku"
        )
    }
    
    func onItemSelected(at index: Int) {
        viewState?(.navigateToHeroDetail)
    }
}
