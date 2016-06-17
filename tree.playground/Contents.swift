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
}

class TreeView : UIView
{
    var root:Node!
    var height:Int!
    
    init(root:Node) {
        
        self.root   = root
        self.height = root.height()
        
        let height =    CGFloat(self.height) * 50
        let width  =    CGFloat(pow(2.0, Double(self.height)-1))  * 100
        
        super.init(frame: CGRectMake(0,0,width,height))
        
    }

    func preOrderCreatNode(node:Node,position:CGPoint,level:Int)
    {
        //draw the node
        let str = String(node.value) as NSString
        str.drawAtPoint(position, withAttributes:[NSForegroundColorAttributeName:UIColor.greenColor(),NSFontAttributeName:UIFont.systemFontOfSize(18)])
        
        
        let space:CGFloat = pow((CGFloat(height)-CGFloat(level)),2) * 15 + 15
        
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


let root = Node(value: 18)
root.leftNode  = Node(value: 12)
root.rightNode = Node(value: 13)
root.leftNode?.leftNode   = Node(value: 4)
root.leftNode?.rightNode  = Node(value: 6)
root.rightNode?.leftNode  = Node(value: 8)
root.rightNode?.rightNode = Node(value: 12229)
root.leftNode?.leftNode?.leftNode    = Node(value: 40)
root.leftNode?.leftNode?.rightNode   = Node(value: 50)
root.leftNode?.rightNode?.leftNode   = Node(value: 60)
root.leftNode?.rightNode?.rightNode  = Node(value: 65)
root.rightNode?.leftNode?.leftNode   = Node(value: 90)
root.rightNode?.leftNode?.rightNode  = Node(value: 75)
root.rightNode?.rightNode?.leftNode  = Node(value: 45)
root.rightNode?.rightNode?.rightNode = Node(value: 30)


TreeView(root: root)

