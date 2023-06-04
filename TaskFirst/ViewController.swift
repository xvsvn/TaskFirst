//
//  ViewController.swift
//  TaskFirst
//
//  Created by Xasan Xasanov on 21/05/23.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    
   @IBOutlet weak var login: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var followingsCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let urlString = "https://api.github.com/users/xvsvn"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            do {
                let gitHubUser = try JSONDecoder().decode(GithubUser.self, from: data)
                guard let imageUrl = URL(string: gitHubUser.avatar_url) else { return }
                
                URLSession.shared.dataTask(with: imageUrl) { imageData, _, _ in
                    if let imageData = imageData, let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            // Assuming image is connected to your UIImageView
                            self.image.image = image
                        }
                    }
                }.resume()
                
                DispatchQueue.main.async {
                    // Assuming login, id, followersCount, and followingsCount are connected to your UI components
                    self.login.text = gitHubUser.login
                    self.id.text = "\(gitHubUser.id)"
                    self.followersCount.text = "\(gitHubUser.followers)"
                    self.followingsCount.text = "\(gitHubUser.following)"
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()


        
    }
    


}

