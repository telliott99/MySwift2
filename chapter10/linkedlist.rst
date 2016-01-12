.. _linkedlist:

###########
Linked List
###########

Linked lists are a basic data structure in computer science.  The typical scenario is a program written in C, with each **node** allocated on the "heap", using memory requested by the program, and referenced by a pointer.  Imagine a parade of boats hooked together by chains.  Insertion of a new boat involves simply unhooking one chain and hooking up two new ones.

https://en.wikipedia.org/wiki/Linked_list

In this section we look at a linked list implemented in Swift.  

I got the code from here:

https://medium.com/@ranleung/linked-list-bc0d825e7144#.9wocecba8

fixed a critical typo, and changed the nomenclature a bit.

.. sourcecode:: swift

    class Node<T: Equatable> {
        var value: T? = nil
        var next: Node? = nil
    }

    class LinkedList<T: Equatable> {
        var head = Node<T>()

        func insert(value: T) {
            // we start empty, value will be nil
            if head.value == nil {
                head.value = value
                
            } else {
                // traverse until we find a node without a next one
                var current = head
                while current.next != nil {
                    current = current.next!
                }

            // once found, create a new node
            // connect it to the linked list
            let newNode = Node<T>()
            newNode.value = value
            current.next = newNode
            }
        }

        func remove(value: T) {
            if head.value == nil {
                return
            }
            
            // Check if the value is at the head
            if head.value == value {
                head = head.next!
            }

            // traverse to find node with this value, if present
            var current = self.head
            var previousNode = Node<T>()

            // if value is present, exit the loop
            while current.value != value && current.next != nil {
                previousNode = current
                current = current.next!
            }

            // once found, connect the previous node
            // to the current node's next
            if current.value == value {
                if current.next != nil {
                    previousNode.next = current.next
                } else {
                    // we're at the end, the next is nil
                    previousNode.next = nil
                }
            }
        }

        func printAllKeys() {
            print("head: \(head.value)")
            var current: Node! = head
            print("-----")
            print(current.value)
            while current != nil && current.value != nil {
                print("Value: \(current.value!)")
                current = current.next
            }
        }
    }

    var myList = LinkedList<Int>()
    myList.insert(100)
    myList.insert(200)
    myList.insert(300)
    myList.remove(100)
    myList.printAllKeys()

Here is what the debug view prints in a Playground:

.. sourcecode:: bash

    head: Optional(200)
    -----
    Optional(200)
    Value: 200
    Value: 300