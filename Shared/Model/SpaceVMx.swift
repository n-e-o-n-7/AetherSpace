////
////  CanvasVM.swift
////  Aether
////
////  Created by 许滨麟 on 2021/3/16.
////
//
//import Combine
//import CoreData
//import SwiftUI
//
//class SpaceVM: ObservableObject {
//    let saveSubject = PassthroughSubject<Int, Never>()
//    var space: Space {
//        didSet {
//            if let lastNodeId = space.lastNodeId {
//                self.nowNode = self.space.nodes[lastNodeId]
//            } else {
//                self.nowNode = nil
//            }
//        }
//    }
//
//    @Published var nowNode: Node? = nil {
//        didSet {
//            if nowNode?.id != oldValue?.id {
//                if let node = self.nowNode {
//                    print("nowNode change")
//                    initData(node: node)
//                } else {
//                    initData()
//                }
//            }
//
//        }
//    }
//    init() {
//        self.space = Space()
//    }
//    //    deinit {
//    //        debugPrint(space.id, "vm deinit")
//    //        //MARK: - save? and fisrtnode
//    //        if let nowNode = nowNode {
//    //            space.lastNode = nowNode
//    //        } else if let firstNode = nodes.first {
//    //            space.lastNode = firstNode
//    //        }
//    //        viewContext.saveContext()
//    //    }
//
//    @Published var links: [UUID:Link] = [:]
//    var saveLinks: [UUID:Link] = [:]
//
//    @Published var nodes: [UUID:Node] = [:]
//    var saveNodes:[UUID:Node] = [:]
//
//    var nodePosition: [UUID: PositionVM] = [:]
//
//    func initData() {
//        links = [:]
//        saveLinks = links
//        nodes = [:]
//        saveNodes = nodes
//        nodePosition = [:]
//    }
//    func initData(node: Node) {
//        let asHeadLinks = node.asHeadLinkIds.mapValues { space.links[$0]! }
//        let asTailLinks = node.asTailLinkIds.mapValues { space.links[$0]! }
//
//        links = asHeadLinks.merging(asTailLinks){(ashead,_) in ashead}
//        saveLinks = links
//        let HeadNodes = Dictionary(uniqueKeysWithValues: asTailLinks.map { link -> (UUID,Node) in
//            let node = space.nodes[link.value.headNodeId]!
//            return (node.id,node)
//        })
//
//
//        let TailNodes = Dictionary(uniqueKeysWithValues: asHeadLinks.map { link -> (UUID,Node) in
//            let node = space.nodes[link.value.tailNodeId]!
//            return (node.id,node)
//        })
//
//
//        nodes = HeadNodes.merging(TailNodes){(head,_) in head}
//        saveNodes = nodes
//        let HeadNodePosition = Dictionary(
//            uniqueKeysWithValues: asTailLinks.map {
//                ($0.value.headNodeId, PositionVM(offset: $0.value.headOffset))
//            })
//        let TailNodePosition = Dictionary(
//            uniqueKeysWithValues: asHeadLinks.map {
//                ($0.value.tailNodeId, PositionVM(offset: $0.value.tailOffset))
//            })
//
//        nodePosition = HeadNodePosition.merging(TailNodePosition) { (head, _) in head}
//
//        nodePosition[node.id] = PositionVM()
//
//    }
//
//    func addNode(type: Node.Species, content: NodeContent, position: CGPoint) {
//        let newNode = Node(type: type, content: content)
//        let id = newNode.id
//
//        stack.append(.addNode(newNode))
//        nodes[id]=newNode
//        nodePosition[newNode.id] = PositionVM(offset: position)
//
//        switch type {
//        case .image, .sound:
//            let token = SubscriptionToken()
//            if let pub = upload(data: content.data, name: content.fileName) {
//                pub.sink(
//                    receiveCompletion: { c in
//                        token.unseal()
//                    },
//                    receiveValue: { value in
//                        //MARK: - maybe ?
//
//                        self.nodes[id]!.content.fileName = value.savePath
//                        //operation
//                    }
//                )
//                .seal(in: token)
//            }
//        default: break
//        }
//    }
//
//    func removeNode(id:UUID){
//        if let node = nodes[id] {
//            stack.append(.removeNode(node))
//            nodes[id] = nil
//            nodePosition.removeValue(forKey: node.id)
//
//            //delete all links
//        }
//    }
//
//    func addLink(head: Node, tail: Node) {
//        //MARK: -same link
//        //new node
//        if head.id != tail.id {
//            let newLink = Link(head: head, tail: tail, tailOffset: .zero)
//            //nodes
//            if nodes[head.id] != nil{
//                nodes[head.id]!.asHeadLinkIds[newLink.id] = newLink.id
//            } else {
//                nowNode?.asHeadLinkIds[newLink.id] = newLink.id
//            }
//            if nodes[tail.id] != nil {
//                nodes[tail.id]!.asTailLinkIds[newLink.id] = newLink.id
//            } else {
//                nowNode?.asTailLinkIds[newLink.id] = newLink.id
//            }
//            links[newLink.id] = newLink
//        }
//        //MARK: -no nowNode
//
//    }
//
//    func removeLink(id:UUID){
//        if let link = links[id]{
//            nodes[link.headNodeId]?.asHeadLinkIds[link.id] = nil
//            nodes[link.tailNodeId]?.asTailLinkIds[link.id] = nil
//            links[id] = nil
//        }
//    }
//
//    func save(nextNode: Node? = nil) {
//        print("save")
//        if let n = nowNode ?? nodes.popFirst()?.value {
//            var newSpace = space
//
//            let newLinks = links.mapValues { link -> Link in
//
//                var newlink = link
//
//                if newlink.headNodeId == n.id {
//
//                    newlink.tailOffset = nodePosition[newlink.tailNodeId]!.save.subtract(
//                        nodePosition[newlink.headNodeId]!.save)
//
//                } else if newlink.tailNodeId == n.id {
//
//                    newlink.headOffset = nodePosition[newlink.headNodeId]!.save.subtract(
//                        nodePosition[newlink.tailNodeId]!.save)
//
//                } else {
//
//                    newlink.tailOffset = nodePosition[newlink.tailNodeId]!.save.subtract(
//                        nodePosition[newlink.headNodeId]!.save)
//                    newlink.headOffset = CGPoint(x: -newlink.tailOffset.x, y: -newlink.tailOffset.y)
//                }
//                return newlink
//            }
//
//
//
//            saveLinks.forEach { (id,_) in
//                newSpace.links[id] = newLinks[id]
//            }
//            newLinks.forEach{(id,_) in
//                newSpace.links[id] = newLinks[id]
//            }
//
//            saveNodes.forEach { (id,_) in
//                newSpace.nodes[id] = nodes[id]
//            }
//            nodes.forEach{(id,_) in
//                newSpace.nodes[id] = nodes[id]
//            }
//
//            newSpace.nodes[n.id] = n
//
//            newSpace.lastNodeId = nextNode?.id ?? n.id
//
//            space = newSpace
//        }
//    }
//
//    var stack: [Operation] = []
//
//    func backout() {
//        guard let op = stack.popLast() else { return }
//        switch op {
//        case .addNode(let node):
//            <#code#>
//        case .removeNode(let node):
//
//        case .editNode(let node):
//
//        case .addLink(let link):
//
//
//        case .removeLink(let link):
//
//        }
//
//    }
//}
//
