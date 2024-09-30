//
//  UserViewController.swift
//  Assignment1
//
//  Created by Evan Proulx on 2024-09-29.
//

import UIKit
import CoreData

class UserViewController: UIViewController {
    //MARK: Properties
    var users = [MovieList]()
    var coreDataStack = CoreDataStack(modelName: "MovieModel")

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //populate table with users
        fetchUsers()
        tableView.delegate = self
    }
    
    //MARK: Table
    lazy var listDataSource = UITableViewDiffableDataSource<Section, MovieList>(tableView: tableView) { tableView, indexPath, user in
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = user.listName
        
        return cell
    }
    
    //MARK: Methods
    @IBAction func addUser(_ sender: Any) {
        let alert = UIAlertController(title: "Add New User", message: "Enter Username", preferredStyle: .alert)
        alert.addTextField()
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: "Add", style: .default){
            _ in
            guard let text = alert.textFields?[0].text, !text.isEmpty else { return }
            
            let newUser = MovieList(context: self.coreDataStack.managedContext)
            newUser.listName = text.capitalized
            
            self.coreDataStack.saveContext()
            self.fetchUsers()
        }
        alert.addAction(add)
        
        present(alert, animated: true)
        
    }

    //Reload users
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? FavoriteViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let movieList = listDataSource.itemIdentifier(for: indexPath)
        destination?.movieList = movieList
        destination?.coreDataStack = coreDataStack
        
    }
}


//MARK: Delegate
//allow for swiping on row to delete record
extension UserViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove"){
            _, _, completionHandler in
            guard let userToRemove = self.listDataSource.itemIdentifier(for: indexPath) else{return}
            
            //alert before deleting
            let alert = UIAlertController(title: "DELETE", message: "Are you sure you want to delte?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive){
                _ in
                //delete movie
                self.coreDataStack.managedContext.delete(userToRemove)
                self.coreDataStack.saveContext()
                //refresh list
                self.fetchUsers()
                
                completionHandler(true)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel){
                _ in
            })
            //show alert
            self.present(alert, animated: true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

