
import UIKit
import Firebase
import Lottie


final class MenuDisplayView: UIViewController,MenuViewProtocol {
    
    var firebaseDrinks: [FirebaseDrink] = []
    private var hasLoadedOnce = false

     let loaderAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: Resources.LoaderAnimationView.loaderForBar)
        animationView.loopMode = .loop
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()

     let myTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        
        return tableView
    }()    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        registerCells()
        setupDelegate()
        setupViews()
        setupConstraints()
 }

    func showLoader() {
           DispatchQueue.main.async {
               self.loaderAnimationView.isHidden = false
               self.loaderAnimationView.play()
           }
       }
       
       func hideLoader() {
           DispatchQueue.main.async {
               self.loaderAnimationView.stop()
               self.loaderAnimationView.isHidden = true
           }
       }
       
       func updateDrinkList(_ drinks: [FirebaseDrink]) {
           DispatchQueue.main.async {
               self.firebaseDrinks = drinks
               self.myTableView.reloadData()
           }
       }
    func showError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }

   private func setupViews() {
        self.view.addSubview(myTableView)
       self.view.addSubview(loaderAnimationView)

    }
    private func setupDelegate() {
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    private func registerCells() {
        myTableView.register(AlcoViewCell.self, forCellReuseIdentifier: AlcoViewCell.identifier)
    }

}





