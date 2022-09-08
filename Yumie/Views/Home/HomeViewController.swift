import UIKit
import ProgressHUD


class HomeViewController: UIViewController {

    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var specialsCollectionView: UICollectionView!
    
    var categories: [DishCategory] = []
    
    var popularDish: [Dish] = []
    
    var specialsDish: [Dish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ProgressHUD.show()
        
        NetworkService.shared.fetchAllCategories { [weak self] result in
            switch result {
                case .success(let allDishes):
                    ProgressHUD.dismiss()
                    self?.categories = allDishes.categories ?? []
                    self?.popularDish = allDishes.populars ?? []
                    self?.specialsDish = allDishes.specials ?? []
                    
                    self?.categoryCollectionView.reloadData()
                    self?.popularCollectionView.reloadData()
                    self?.specialsCollectionView.reloadData()
                case .failure(let error):
                    ProgressHUD.showError(error.localizedDescription)
            }
        }
        
        registerCells()
    }
    
    private func registerCells() {
        categoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil),
                                        forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        popularCollectionView.register(UINib(nibName: DishPortraitCollectionViewCell.identifier, bundle: nil),
                                        forCellWithReuseIdentifier: DishPortraitCollectionViewCell.identifier)
        
        specialsCollectionView.register(UINib(nibName: DishLandscapeCollectionViewCell.identifier, bundle: nil),
                                        forCellWithReuseIdentifier: DishLandscapeCollectionViewCell.identifier)
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            case categoryCollectionView:
                return categories.count
            case popularCollectionView:
                return popularDish.count
            case specialsCollectionView:
                return specialsDish.count
            default:
                return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            case categoryCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
                cell.setup(category: categories[indexPath.row])
                return cell
                
            case popularCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishPortraitCollectionViewCell.identifier, for: indexPath) as! DishPortraitCollectionViewCell
                cell.setup(dish: popularDish[indexPath.row])
                return cell
                
            case specialsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishLandscapeCollectionViewCell.identifier, for: indexPath) as! DishLandscapeCollectionViewCell
                cell.setup(dish: specialsDish[indexPath.row])
                return cell
                
            default:
                return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let controller = ListDishTableViewController.instantiate()
            controller.category = categories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = DishDetailViewController.instantiate()
            if collectionView == popularCollectionView {
                controller.dish = popularDish[indexPath.row]
            } else if collectionView == specialsCollectionView {
                controller.dish = specialsDish[indexPath.row]
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
