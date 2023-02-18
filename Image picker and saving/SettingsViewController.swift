

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
   lazy var tableView = UITableView()
    let cellReuseIdentifier = "TableViewCell"
    let textForCell = ["Сортировка по алфавиту", "Сменить пароль"]
    
   lazy var switcher: UISwitch = {
        let swtc = UISwitch(frame: CGRect(x: 325, y: 40,
                                          width: 20,
                                          height: 10))
     
       swtc.setOn(true, animated: false)
       swtc.addTarget(self, action: #selector(switcherAction), for: .valueChanged)
       return swtc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        view.addSubview(tableView)
        setUpTableView()
        setupConstraints()
        
    }
    fileprivate func setUpTableView() {
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.allowsSelection = true
        tableView.separatorStyle = .singleLine
            }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
   @objc func switcherAction(_sender: UISwitch) {
       let key = switcher.isOn
       defaults.set(false, forKey: "\(key)")
       let vc = PicturesViewController()
       self.navigationController?.pushViewController(vc, animated: true)
       vc.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return textForCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TableViewCell
        cell.textLabel?.text = textForCell[indexPath.row]
        let swt = switcher
        if indexPath.row == 1 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
            cell.selectionStyle = .none
            cell.addSubview(swt)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
            if (indexPath.row == 1) {
               let vc = ChangePasswordViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
