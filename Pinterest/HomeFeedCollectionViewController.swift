//
//  HomeFeedCollectionViewController.swift
//  Pinterest
//
//  Created by Adrian Alejandro Sandoval Perez on 4/4/19.
//  Copyright © 2019 Adrian Alejandro Sandoval Perez. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let sectionInsets = UIEdgeInsets(top: 50.0,
                                         left: 20.0,
                                         bottom: 50.0,
                                         right: 20.0)
var collectionView: UICollectionView?
var screenSize: CGRect!
var screenWidth: CGFloat!
var screenHeight: CGFloat!

var statusImageView : UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    return imageView
}()

var zoomImageView = UIImageView()

let imagenes: [UIImage] = [#imageLiteral(resourceName: "pinterest")]

class HomeFeedCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        self.navigationItem.title = "Bienvenido a Pinterest"
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        
        //Titulo para el boton de retroceder
        let backButton = UIBarButtonItem()
        backButton.title = "Atras"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        collectionView?.register(PinCell.self, forCellWithReuseIdentifier: "Pin")
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
    }
    @objc func addTapped(){
        self.navigationController?.pushViewController(UploadImageVC(), animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth/2, height: screenWidth/2);
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pin", for: indexPath) as! PinCell
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pin", for: indexPath) as! PinCell
        
        statusImageView = cell.imageView1
        //zoomImageView = cell.imageView1
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil),let keyWindow = UIApplication.shared.keyWindow {
            
         
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.alpha = 1
            keyWindow.addSubview(zoomImageView)
            
            //let height = (self.view.frame.width / imagenes[indexPath.row].size.width ) *  imagenes[indexPath.row].size.height
            let height = (self.view.frame.width / imagenes[indexPath.row].size.width ) *  imagenes[indexPath.row].size.height
            UIView.animate(withDuration: 0.20, delay: 0, options: .curveEaseOut, animations: {
                zoomImageView.frame = CGRect(x: 0, y:75, width: self.view.frame.width, height: height)
            })
            
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCrossDissolve, animations: {
                zoomImageView.alpha = 0
            })
            
            let details = PinDetailsController()
            details.image = statusImageView.image
            details.height = height
            
            
            self.navigationController?.pushViewController(details, animated: true)
        }
    }
    
}

extension HomeFeedCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        //100 / 80 * 80
        let height = (self.view.frame.width / imagenes[0].size.height) * imagenes[0].size.height

        //let width = (imagenes[0].size.width) * imagenes[0].size.width) / self.view.frame.height
        return height
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        maxHeightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        var halfView = collectionView.bounds.height / 2
        return halfView + (halfView / 4)
    }
}

class PinCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupViews()
    }
    let imageView1 : UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = imagenes[0]
        return img
    }()
    
    //Label
    let label1 : UILabel = {
        let label2 = UILabel()
        label2.textColor = .black
        label2.translatesAutoresizingMaskIntoConstraints = false
        return label2
    }()
    
    //Imagen de puntitos
    let imageViewOptions : UIImageView = {
        let imageView3 = UIImageView()
        imageView3.image = #imageLiteral(resourceName: "3Puntos")
        imageView3.translatesAutoresizingMaskIntoConstraints = false
        return imageView3
    }()
    
    
    func setupViews(){
        self.addSubview(imageView1)
        self.addSubview(label1)

        self.backgroundColor = .white
        imageView1.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView1.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 9/10).isActive = true
        imageView1.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 4/5).isActive = true
        
        label1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: (17 / 3 )).isActive = true
        label1.leftAnchor.constraint(equalTo: imageView1.leftAnchor).isActive = true
        label1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 80/100).isActive = true
        label1.heightAnchor.constraint(equalToConstant: 17).isActive = true
        //label1.backgroundColor = .red //Coloracion de prueba
        
        //Set image de puntitos
        self.addSubview(imageViewOptions)
        imageViewOptions.centerYAnchor.constraint(equalTo: label1.centerYAnchor).isActive = true
        imageViewOptions.rightAnchor.constraint(equalTo: imageView1.rightAnchor).isActive = true
        imageViewOptions.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 7/100).isActive = true
        imageViewOptions.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 7/100).isActive = true
        
        //Propieades de celda en general
        self.backgroundColor = .white
        //self.backgroundColor = .orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
