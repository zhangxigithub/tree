//: Tree http://zhangxi.me

import UIKit

class Node
{
    var leftNode,rightNode:Node?
    var value:Int = 0
    
    init(value:Int)
    {
        self.value = value
    }

    
    func preVisit(action:(node:Node)->())
    {
        action(node: self)
        self.leftNode?.preVisit(action)
        self.rightNode?.preVisit(action)
    }
    func inVisit(action:(node:Node)->())
    {
        self.leftNode?.inVisit(action)
        action(node: self)
        self.rightNode?.inVisit(action)
    }
    func postVisit(action:(node:Node)->())
    {
        self.leftNode?.postVisit(action)
        self.rightNode?.postVisit(action)
        action(node: self)
    }
    func height() -> Int
    {
        var leftHeight = 1
        var rightHeight = 1
        
        if self.leftNode != nil
        {
            leftHeight = self.leftNode!.height() + 1
        }
        if self.rightNode != nil
        {
            rightHeight = self.rightNode!.height() + 1
        }
        return max(leftHeight, rightHeight)
    }
    func treeView() -> TreeView {
        return TreeView(root:self)
    }
    func invert()
    {
        let tmp        = self.leftNode
        self.leftNode  = self.rightNode
        self.rightNode = tmp
        
        self.leftNode?.invert()
        self.rightNode?.invert()
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
        let str = String(node.value) as NSString
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
    func tree()-> Node?
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

let array    = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
let root     = array.tree()!
root.treeView()
root.invert()
root.treeView()
root.leftNode?.treeView()


