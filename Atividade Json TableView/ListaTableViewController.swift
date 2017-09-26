//
//  ListaTableViewController.swift
//  Atividade Json TableView
//
//  Created by Usuário Convidado on 25/09/17.
//  Copyright © 2017 Marina Yumi. All rights reserved.
//

import UIKit

class ListaTableViewController: UITableViewController {
    
    
    var aplicativoArray = [Aplicativo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let urlApi = "http://itunes.apple.com/br/rss/topfreeapplications/limit=10/json"
        
        if let url = URL(string: urlApi){
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                if error != nil{
                    print("o erro é: \(error!)")
                    return
                } else if let jsonData = data{
                    do{
                        let parsedJSON = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
                        //print(parsedJSON)
                        
                        guard let feed = parsedJSON["feed"] as? [String:Any] else { return }
                        guard let apps = feed["entry"] as? [[String:Any]] else { return }
                                for app in apps{
                                    
                                    let objApp = Aplicativo()
                                    
                                    //nome do aplicativo
                                    guard let imname = app["im:name"] as? [String:Any] else { return }
                                    guard let nomeApp = imname["label"] as? String else { return }
                                    
                                    //imagem string com a url
                                    guard let arrayImage = app["im:image"] as? [Any] else { return }
                                    guard let imagem0 = arrayImage[0] as? [String:Any] else { return }
                                    guard let imgStr = imagem0["label"] as? String else { return }
                                    
                                    guard let arrayCat = app["category"] as? [String:Any] else { return }
                                    guard let cat0 = arrayCat["attributes"] as? [String:Any] else { return }
                                    guard let cat = cat0["label"] as? String else { return }
                                    
                                    let myUrl = URL (string: imgStr)
                                    let imageData:Data = try Data(contentsOf: myUrl!)
                                    let minhaImagem = UIImage(data: imageData)
                                    
                                    objApp.nome = nomeApp
                                    objApp.imagemSTR = imgStr
                                    objApp.imagem = minhaImagem
                                    objApp.categoria = cat
                                    
                                    self.aplicativoArray.append(objApp)
                                    
                                }//fim do for app
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }catch{
                        print("Erro no Parser: \(error)")
                    }//fim do catch
                    
                } //fecha else
            }) //fecha o task
            
            task.resume()
        }//fecha o if

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aplicativoArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = aplicativoArray[indexPath.row].nome
        cell.imageView?.image = aplicativoArray[indexPath.row].imagem
        cell.detailTextLabel?.text = aplicativoArray[indexPath.row].categoria
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
