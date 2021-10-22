import Foundation
import UIKit

// UICollectionView
extension UICollectionView {
    func register<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: name)
        } else {
            register(aClass, forCellWithReuseIdentifier: name)
        }
    }

    func register<T: UICollectionReusableView>(header aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionHeader
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func register<T: UICollectionReusableView>(footer aClass: T.Type) {
        let name = String(describing: aClass)
        let kind = UICollectionView.elementKindSectionFooter
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        } else {
            register(aClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: name)
        }
    }

    func dequeue<T: UICollectionViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func dequeue<T: UICollectionReusableView>(header aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func dequeue<T: UICollectionReusableView>(footer aClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    func scrollToBottom(_ animated: Bool) {
        let section = numberOfSections - 1
        let item = numberOfItems(inSection: section) - 1
        if section < 0 || item < 0 { return }
        let path = IndexPath(item: item, section: section)
        let offset = contentOffset.y
        scrollToItem(at: path, at: .top, animated: animated)
        let delay = (animated ? 0.2 : 0.0) * Double(NSEC_PER_SEC)
        let deadline: DispatchTime = .now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.contentOffset.y != offset {
                strongSelf.scrollToBottom(false)
            }
        }
    }
}

// UITableview
extension UITableView {
    override open var delaysContentTouches: Bool {
        didSet {
            for view in subviews {
                if let scroll = view as? UIScrollView {
                    scroll.delaysContentTouches = delaysContentTouches
                    break
                }
            }
        }
    }
    
    func setSeparatorInsets(_ insets: UIEdgeInsets) {
        separatorInset = insets
        layoutMargins = insets
    }
    
    func scrollToBottom(_ animated: Bool) {
        guard numberOfSections > 0 else { return }
        let section = numberOfSections - 1
        let row = numberOfRows(inSection: section) - 1
        if section < 0 || row < 0 { return }
        let path = IndexPath(row: row, section: section)
        let offset = contentOffset.y
        scrollToRow(at: path, at: .bottom, animated: animated)
        let delay = (animated ? 0.2 : 0.0) * Double(NSEC_PER_SEC)
        let deadline: DispatchTime = .now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: deadline) { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.contentOffset.y != offset {
                strongSelf.scrollToBottom(false)
            }
        }
    }
    
    func scrollToTop() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let indexPath = IndexPath(row: 0, section: 0)
                guard self.hasRowAtIndexPath(indexPath: indexPath) else { return }
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
    
    func register<T: UITableViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forCellReuseIdentifier: name)
        } else {
            register(aClass, forCellReuseIdentifier: name)
        }
    }
    
    func dequeue<T: UITableViewCell>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    
    func dequeue<T: UITableViewCell>(_ aClass: T.Type, for indexPath: IndexPath) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name, for: indexPath) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
    
    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let bundle = Bundle.main
        if bundle.path(forResource: name, ofType: "nib") != nil {
            let nib = UINib(nibName: name, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: name)
        } else {
            register(aClass, forHeaderFooterViewReuseIdentifier: name)
        }
    }
    
    func dequeue<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> T {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: name) as? T else {
            fatalError("`\(name)` is not registed")
        }
        return cell
    }
}

extension UITableViewCell {
    public func setSeparatorInsets(_ insets: UIEdgeInsets) {
        separatorInset = insets
        layoutMargins = insets
    }
}
