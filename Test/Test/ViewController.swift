//
/**
 * @brief  	<#usage#>
 * @author 	whc
 * @date   	2020/11/13
 */
	

import UIKit

private let AnimalsImageNames: Array<String> = ["bird1","bluebird1","ice1","pig_44","yellowbird1","shelf1","1","pig1"]

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDefaultParams()
        
        self.initSubViews()
    }
    
    //MARK:Private Action
    private func setDefaultParams() {
        self.title = "测试"
    }
    
    private func initSubViews() {
        let redView = UIView.init(frame: CGRect(x: (self.view.frame.size.width - 50) / 2, y: self.view.frame.height - 60, width: 50, height: 50))
        redView.backgroundColor = UIColor.red
        self.view.addSubview(redView)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.view.addGestureRecognizer(tap)
        
        let clean: UIButton = UIButton.init(frame: CGRect.init(x: self.view.frame.size.width - 110, y: self.view.frame.height/2, width: 100, height: 100))
        clean.setTitle("clean", for: .normal)
        clean.setTitleColor(UIColor.white, for: .normal)
        clean.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        clean.addTarget(self, action: #selector(cleanAction), for: .touchUpInside)
        clean.backgroundColor = UIColor.red
        self.view.addSubview(clean)
    }
    
    @objc private func cleanAction() {
        for view in self.view.subviews {
            if view.isKind(of: AnimalsView.self) {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc private func tapAction() {
        let animalsView = AnimalsView.init(frame: CGRect(x: (self.view.frame.size.width - 50) / 2, y: self.view.frame.height - 150, width: 50, height: 50))
        self.view.addSubview(animalsView)
        animalsView.addKitAction()
    }
}

class AnimalsView: UIView {
    private var animalImageView: UIImageView?
    
    private var dynamicAnimator: UIDynamicAnimator?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setDefaultParams()
        
        self.initSubViews()
    }
    
    //MARK:- Private Action
    private func setDefaultParams() {
        self.backgroundColor = UIColor.clear
    }
    
    private func initSubViews() {
        self.animalImageView = UIImageView.init(frame: self.bounds)
        self.animalImageView?.contentMode = .scaleAspectFit
        self.addSubview(self.animalImageView!)
    }
    
    //MARK:- Public Action
    public func addKitAction() {
        self.dynamicAnimator = UIDynamicAnimator.init(referenceView: self.superview!)

        let imageName = AnimalsImageNames[Int(arc4random()) % AnimalsImageNames.count]
        let randomImage = UIImage(named: imageName)
        self.animalImageView?.image = randomImage
        
        let pushBehavior = UIPushBehavior.init(items: [self.animalImageView!], mode: .instantaneous)
        pushBehavior.active = true

        let currnetX: Int = Int(arc4random() % UInt32(self.frame.size.width))
        let currnetY: Int = 10
        let newX: CGFloat = CGFloat(currnetX) - self.animalImageView!.center.x
        let newY: CGFloat = CGFloat(currnetY) - self.animalImageView!.center.y
        pushBehavior.pushDirection = CGVector(dx: newX, dy: newY)
        pushBehavior.magnitude = 10
//        pushBehavior.magnitude = sqrt(newX*newX+newY*newY)*0.01

        self.dynamicAnimator?.addBehavior(pushBehavior)

        let dynamicItemAnimator = UIDynamicItemBehavior.init(items: [self.animalImageView!])
        //弹力  数值越大，弹力越大
        dynamicItemAnimator.elasticity = 0.8
        // 摩擦力
        dynamicItemAnimator.friction = 0
        // 抗阻力
        dynamicItemAnimator.resistance = 0
        dynamicItemAnimator.resistance = 1
        dynamicItemAnimator.angularResistance = 0.2
        //把行为放进动画里
        self.dynamicAnimator?.addBehavior(dynamicItemAnimator)

        //碰撞
        let collisionBehavior = UICollisionBehavior(items: [self.animalImageView!])
        //刚体碰撞
//        collisionBehavior.collisionMode = .boundaries
        collisionBehavior.collisionMode = .everything
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.dynamicAnimator?.addBehavior(collisionBehavior)

        //重力
        let gravityBehavior = UIGravityBehavior(items: [self.animalImageView!])
        gravityBehavior.magnitude = 1
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        self.dynamicAnimator?.addBehavior(gravityBehavior)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
