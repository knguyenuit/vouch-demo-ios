import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: Outlets
    //--------------------
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var mainContentView: UIView!
    private var pageViewController: UIPageViewController!
    
    //MARK: Properties
    //--------------------
    private var viewControllers: [UIViewController] = []
    private var categories: [Category] = []
    private var viewModel = HomeViewModel()
    
    private var viewControllerCurrentIndex: Int = 0 {
        didSet {
            guard viewControllers.count > viewControllerCurrentIndex else { return }
            self.collectionView.reloadData()
            pageViewController.setViewControllers(
                [viewControllers[viewControllerCurrentIndex]],
                direction: viewControllerCurrentIndex > oldValue ? .forward : .reverse,
                animated: true)
        }
    }
    
    //MARK: Life cycles
    //--------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        configPageVC()
        configCollectionView()
        bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationDefault(title: "Ticket Detail")
        showBadge(withCount: CartDataDefault.cartBadge)
    }
    
    //MARK: Functions
    //--------------------
    ///Config CollectionView
    private func configCollectionView() {
        collectionView.register(CategoryCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    ///Config PageView
    private func configPageVC() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
    }
    
    private func updateConfigPageView() {
        pageViewController.modalTransitionStyle = .partialCurl
        viewControllers.removeAll()
        for category in categories {
            let viewModel = HomeContentViewModel(category: category)
            let viewController = HomeContentViewController(viewModel: viewModel)
            viewController.delegate = self
            viewControllers.append(viewController)
        }
        pageViewController.view.frame = CGRect(origin: CGPoint.zero, size: mainContentView.frame.size)
        mainContentView.addSubview(pageViewController.view)
        viewControllerCurrentIndex = 0
    }
}

//MARK: UICollectionView Datasource + Delegate
//--------------------
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.item < categories.count else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(CategoryCollectionCell.self, forIndexPath: indexPath)
        cell.configure(text: categories[indexPath.item].name ?? "", isSelected: viewControllerCurrentIndex == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.item < categories.count else { return .zero }
        let text: String = categories[indexPath.item].name ?? ""
        let wordSize = text.sizeOfString(usingFont: UIFont.systemFont(ofSize: 14, weight: .regular))
        var calculatedWidth = CGFloat()
        calculatedWidth = wordSize.width + 16
        return CGSize(width: calculatedWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewControllerCurrentIndex != indexPath.row else { return }
        viewControllerCurrentIndex = indexPath.row
    }
}

//MARK: PageViewController Delegate
//--------------------
extension HomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewControllerCurrentIndex < viewControllers.count - 1 {
            return viewControllers[viewControllerCurrentIndex + 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewControllerCurrentIndex == 0 {
            return nil
        } else {
            return viewControllers[viewControllerCurrentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let currentViewController = pageViewController.viewControllers?.first,
                  let viewControllerCurrentIndex = viewControllers.firstIndex(of: currentViewController) else { return }
            self.viewControllerCurrentIndex = viewControllerCurrentIndex
        }
    }
}

//MARK: BindingData
//--------------------
extension HomeViewController {
    private func bindingData() {
        let input = HomeViewModel.Input(viewWillAppear: rx.viewWillAppear.mapToVoid().asObservable())
        
        let output = viewModel.transform(input: input)
        output.fetchCategorys.drive(onNext: { [weak self] (categories) in
            guard let self = self else { return }
            CategoryDataDefault.saveCategories(categories.data)
            self.categories = categories.data
            self.collectionView.reloadData()
            self.updateConfigPageView()
        }).disposed(by: disposeBag)
        
    }
}

//MARK: HomeContentViewController Delegate
//--------------------
extension HomeViewController: HomeContentViewControllerDelegate {
    func didSelectTicket(_ ticket: Ticket, category: Category?) {
        let viewModel = TicketDetailViewModel(ticket: ticket, category: category)
        self.pushViewController(TicketDetailViewController(viewModel: viewModel), animated: true)
    }
}
