

import UIKit

struct Picture {
    var name: String
    var image: UIImage
}

class PicturesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private lazy var tableView = UITableView()
   private let navbar = UINavigationBar()
    let cellReuseIdentifier = "cell"
  private lazy var picture = [Picture]()
  lazy var picturesToShow = [UIImage]()
  private lazy var setingsVC = SettingsViewController()
    var switcherState = false
   

 
    fileprivate func addNavBar() {
        view.addSubview(navbar)
        navbar.translatesAutoresizingMaskIntoConstraints = false
        let navItem = UINavigationItem(title: "Фото")
        let addPictureButton = UIBarButtonItem(title: "Добавить фото", style: .done, target: nil, action: #selector(addPictureButtonPressed))
        navItem.rightBarButtonItem = addPictureButton
        navbar.setItems([navItem], animated: false)
    }
    
    fileprivate func setUpTableView() {
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
    }
    
    fileprivate func getImageFromDocumentDirectory() -> [UIImage] {
        let images = [UIImage]()
        let fileManager = FileManager.default
        do {
            let documentsDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let folderURL = documentsDirectoryURL//.appendingPathComponent("\(documentsDirectoryURL)")
            let urls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for url in urls {
                
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data)
                {
                    picturesToShow.append(image)
                    let fileURL: String = "\(url)"
                    let fileName = URL(fileURLWithPath: fileURL).deletingPathExtension().lastPathComponent
                    let pic = Picture(name: fileName, image: image)
                    picture.append(pic)
                  
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return images
    }
    
    fileprivate func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            navbar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            navbar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            navbar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            navbar.heightAnchor.constraint(equalToConstant: 44),
        
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 44),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        addNavBar()
        setUpTableView()
        setupConstraints()
        getImageFromDocumentDirectory()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    @objc func addPictureButtonPressed() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .photoLibrary
        self.present(vc, animated: true)
    }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
          return  picture.count
      }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) 
        let width = UIScreen.main.bounds.width - 250
        let height = UIScreen.main.bounds.height / 7
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 5, y: 0,
                                                              width: width,
                                                              height: height))
        
        let lbl = TableViewCell()
        cell.addSubview(cellImg)
        cell.addSubview(lbl.pictureName)
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        cell.contentMode = .scaleAspectFit
        
        if defaults.bool(forKey: "value") {
            picture.sort(by: {$0.name < $1.name})
            cell.textLabel?.text = picture[indexPath.row].name
            cellImg.image = picture[indexPath.row].image

        let picName = picture[indexPath.row].name
        cellImg.image = picture[indexPath.row].image
        lbl.pictureName.text = picName
          
        } else {
            picture.sort(by: {$0.name > $1.name})
            
            cell.textLabel?.text = picture[indexPath.row].name
            cellImg.image = picture[indexPath.row].image
            
            let picName = picture[indexPath.row].name //
            cellImg.image = picture[indexPath.row].image
            lbl.pictureName.text = picName //
        }
      
        return cell
      }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Удалить", handler: { [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
           
            picturesToShow.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        // -----удаление файла
            
            let fileManager = FileManager.default
            do {
                let documentsDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let folderURL = documentsDirectoryURL//.appendingPathComponent("\(documentsDirectoryURL)")
                let urls = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                try fileManager.removeItem(at: urls[indexPath.row])
             
            } catch {
                print(error.localizedDescription)
                }
            success(true)
            })
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
    }

    extension PicturesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Сохранить фото", message: "Введите имя файла" , preferredStyle: .alert)
        alert.addTextField(configurationHandler: {textField in
            textField.placeholder = "Имя файла"
        })
        alert.addAction (UIAlertAction(title: "OK", style: .default){ [self] _  in
            
            let textField = alert.textFields![0]
            let image = info[.originalImage] as! UIImage
            if let data = image.pngData() {
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let pic = Picture(name: "\(textField.text!)", image: image)
                let url = documents.appendingPathComponent("\(pic.name)" + ".png")
                do {
                    try data.write(to: url)
                    picture.append(pic)
                    picturesToShow.append(image)
                   self.tableView.reloadData()
                }catch {
                    print(error.localizedDescription)
                }
            }
        })
        present(alert, animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
        
       
}
