//
//  UserViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-29.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
    
    var users = [MovieList]()
    var coreDataStack = CoreDataStack(modelName: "MovieModel")


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    lazy var listDataSource = UITableViewDiffableDataSource<Section, MovieList>(tableView: tableView) { tableView, indexPath, user in
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = user.listName
        
        return cell
    }
    
    
    @IBAction func addUser(_ sender: Any) {
        let alert = UIAlertController(title: "Add New User", message: "Enter Username", preferredStyle: .alert)
        alert.addTextField()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: "Add", style: .default){
            _ in
            guard let text = alert.textFields?[0].text, !text.isEmpty else { return }
            
//            let newList = TaskList(placeholderName: text.capitalized)
            let newUser = MovieList(context: self.coreDataStack.managedContext)
            newUser.listName = text.capitalized
            
            self.coreDataStack.saveContext()
            self.fetchUsers()
        }
        alert.addAction(add)
        
        present(alert, animated: true)
        
    }

    
    func fetchUsers(){
        let fetchRequest: NSFetchRequest<MovieList> = MovieList.fetchRequest()
        let nameSort = NSSortDescriptor(key: "listName", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            users = try coreDataStack.managedContext.fetch(fetchRequest)
            self.loadUsers()
        } catch {
            print("An error during fetching has occurred - \(error.localizedDescription)")
        }
    }
    
    func loadUsers(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(users)
        snapshot.reloadItems(users)
        listDataSource.apply(snapshot)
    }

}
