//: Binary Tree http://zhangxi.me

import UIKit

class Node
{
    var leftNode:Node? = nil
    var rightNode:Node? = nil
    var value:AnyObject?
    
    init(value:Int)
    {
        self.value = value
    }

    func preOrderTraverse(action:(node:Node)->())
    {
        action(node: self)
        self.leftNode?.preOrderTraverse(action)
        self.rightNode?.preOrderTraverse(action)
    }
    func inOrderTraverse(action:(node:Node)->())
    {
        self.leftNode?.inOrderTraverse(action)
        action(node: self)
        self.rightNode?.inOrderTraverse(action)
    }
    func postOrderTraverse(action:(node:Node)->())
    {
        self.leftNode?.postOrderTraverse(action)
        self.rightNode?.postOrderTraverse(action)
        action(node: self)
    }
    typealias TraversalAction = (node:Node)->(Bool)
    
    func levelOrderTraverse(action:TraversalAction)
    {
        if action(node: self) == false
        {
            return
        }
        
        var currentLevel = [self]
        var nextLevel    = [Node]()
        
        if self.leftNode != nil
        {
            nextLevel.append(self.leftNode!)
        }
        if self.rightNode != nil
        {
            nextLevel.append(self.rightNode!)
        }
        
        while nextLevel.isEmpty == false {
            currentLevel = nextLevel
            nextLevel.removeAll()
            
            for node in currentLevel
            {
                if node.leftNode != nil
                {
                    nextLevel.append(node.leftNode!)
                }
                if node.rightNode != nil
                {
                    nextLevel.append(node.rightNode!)
                }
                if action(node: node) == false
                {
                    return
                }
            }
        }
    }

    func height() -> Int
    {
        let leftHeight  = (self.leftNode?.height() ?? 0) + 1
        let rightHeight = (self.rightNode?.height() ?? 0) + 1
        return max(leftHeight,rightHeight)
    }

    func count() -> Int
    {
        let leftCount = self.leftNode?.count() ?? 0
        let rightCount = self.rightNode?.count() ?? 0
        return leftCount + rightCount + 1
    }

    func invert()
    {
        swap(&self.leftNode, &self.rightNode)
        self.leftNode?.invert()
        self.rightNode?.invert()
    }
    func isFull() -> Bool
    {
        var full = true
        self.levelOrderTraverse { (node) in
            
            if((node.leftNode == nil) && (node.rightNode == nil)) ||
              ((node.leftNode != nil) && (node.rightNode != nil))
            {
                return true
            }else
            {
                full = false
                return false
            }
        }
        return full
    }
    func isComplete() -> Bool
    {

        var lastNode = false
        var complete = true
        
        self.levelOrderTraverse { (node) in
            
            if lastNode == false && (node.leftNode == nil || node.rightNode == nil)
            {
                lastNode = true
            }else if lastNode && (node.leftNode != nil || node.rightNode != nil)
            {
                complete = false
                return false
            }
            return true
         }
        return complete
    }
    func isBalanced() -> Bool
    {
        func balance(node:Node) -> Bool
        {
            let leftHeight  = node.leftNode?.height() ?? 0
            let rightHeight = node.rightNode?.height() ?? 0
        
            if abs(leftHeight-rightHeight) > 1
            {
                return false
            }else
            {
                if node.leftNode == nil && node.rightNode == nil
                {
                    return true
                }
                return (node.leftNode?.isBalanced() ?? true) && (node.rightNode?.isBalanced() ?? true)
            }
        }
        return balance(self)
    }
    
    func treeView() -> TreeView {
        return TreeView(root:self)
    }
}

class TreeView : UIView
{
    var root:Node!
    var height:Int!
    
    init(root:Node) {
        
        self.root   = root
        self.height = root.height()
        
        let height =    CGFloat(self.height) * 50
        let width  =    CGFloat(pow(2.0, Double(self.height-1)))  * 60 + 100
        
        super.init(frame: CGRectMake(0,0,width,height))
        
    }

    func preOrderCreatNode(node:Node,position:CGPoint,level:Int)
    {
        //draw the node
        let str = String(node.value as! Int) as NSString
        str.drawAtPoint(position, withAttributes:[NSForegroundColorAttributeName:UIColor.greenColor(),NSFontAttributeName:UIFont.systemFontOfSize(18)])
        
        
        let space:CGFloat = pow(2,(CGFloat(height)-CGFloat(level))) * 15
        
        if node.leftNode != nil
        {
            let newPosition = CGPointMake(position.x-space, position.y+50)
            preOrderCreatNode(node.leftNode!,position:newPosition,level: level+1)
            drawLine(position,to:newPosition)

        }
        if node.rightNode != nil
        {
            let newPosition = CGPointMake(position.x+space, position.y+50)
            preOrderCreatNode(node.rightNode!,position:newPosition,level: level+1)
            drawLine(position,to:newPosition)
        }
    }

    func drawLine(from:CGPoint,to:CGPoint)
    {
        let deltaFrom = CGPointMake(7, 20)
        let deltaTo   = CGPointMake(7, 0)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextMoveToPoint(context, from.x + deltaFrom.x, from.y + deltaFrom.y);
        CGContextAddLineToPoint(context, to.x + deltaTo.x, to.y + deltaTo.y);
        CGContextDrawPath(context, .FillStroke)
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        preOrderCreatNode(root, position: CGPointMake(self.frame.size.width/2, 10),level:1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension Array
{
    func tree(array:Array? = nil)-> Node?
    {
        return createTree(self)
    }
    func createTree(array:Array) -> Node?
    {
        if array.isEmpty
        {
            return nil
        }
        
        let middle = array.count/2
        let middleNode    = Node(value:array[middle] as! Int)
        
        let leftSubArray  = Array(array[0 ..< middle])
        let rightSubArray = Array(array[middle+1 ..< array.count])
        
        middleNode.leftNode  = createTree(leftSubArray)
        middleNode.rightNode = createTree(rightSubArray)
        
        return middleNode;
    }
}

let tree0    = [1].tree()!
tree0.treeView()
tree0.isComplete() //true
tree0.isFull()     //true
tree0.isBalanced() //true


let tree1    = [1,2,3,4,5,6,7].tree()!
tree1.treeView()
tree1.isComplete() //true
tree1.isFull()     //true
tree1.isBalanced() //true


let tree2    = [1,2,3,4,5,6,7,8,9].tree()!
tree2.treeView()
tree2.isComplete() //false
tree2.isFull()     //false
tree2.isBalanced() //true
tree2.count()


let tree3    = [1,2,3,4].tree()!
tree3.leftNode?.leftNode?.rightNode = Node(value: 5)
tree3.treeView()
tree3.isComplete() //false
tree3.isFull()     //false
tree3.isBalanced() //false
