.. _array_extensions:

#####################
Extensions for Arrays
#####################
    
In this section we'll develop some extensions for the Array type.

.. sourcecode:: bash

    extension Array {
        func elementCount<T: Equatable> (input: T) -> Int {
            var count = 0
            for el in self {
                if el as! T == input {
                    count += 1
                }
            }
            return count
        }
    }
    

