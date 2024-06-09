
import UIKit

extension MenuDisplayView {
    
    func setupConstraints() {
       myTableView.translatesAutoresizingMaskIntoConstraints = false
       loaderAnimationView.translatesAutoresizingMaskIntoConstraints = false

       NSLayoutConstraint.activate([
           myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
           myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
           
           loaderAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
           loaderAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
           loaderAnimationView.widthAnchor.constraint(equalToConstant: 300),
           loaderAnimationView.heightAnchor.constraint(equalToConstant: 300)
       ])
   }
}

extension MenuDisplayView: ExpandableHeaderViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Resources.ReuseIdentifierForMenuDisplayView.cellIdentifier) as? ExpandableHeaderView
        if header == nil {
            header = ExpandableHeaderView(reuseIdentifier: Resources.ReuseIdentifierForMenuDisplayView.cellIdentifier)
        }

        header?.customInit(title: firebaseDrinks[section].subMenu.subMenuName, section: section, delegate: self, image: firebaseDrinks[section].subMenu.subMenuImage)
        return header
    }

    func toggleSection(header: ExpandableHeaderView, section: Int) {
        firebaseDrinks[section].isStatus = !firebaseDrinks[section].isStatus
        
        myTableView.beginUpdates()
        for i in 0..<firebaseDrinks[section].menu.count {
            myTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        myTableView.endUpdates()
    }
}

extension MenuDisplayView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if firebaseDrinks[indexPath.section].isStatus {
            return 50
        } else {
            return 0
        }
 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let selectedDrink = firebaseDrinks[indexPath.section].menu[indexPath.row]
                let drinkDescriptionVC = DrinkDescriptionView()

        drinkDescriptionVC.configureCell(imageURL: selectedDrink.images,
                                         nameL: selectedDrink.name,
                                         description: selectedDrink.description)
        
                present(drinkDescriptionVC, animated: true)
        }
}
extension MenuDisplayView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return firebaseDrinks.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firebaseDrinks[section].menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if firebaseDrinks[indexPath.section].isStatus {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlcoViewCell.identifier) as? AlcoViewCell else {
                return UITableViewCell()
            }
            
            let nameAndPrice = firebaseDrinks[indexPath.section].menu[indexPath.row]
                        cell.configure(nameAndPrice: nameAndPrice)
            return cell
        } else {
            return UITableViewCell()
    }
  }
}


