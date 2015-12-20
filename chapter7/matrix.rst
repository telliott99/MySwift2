.. _matrix:

######
Matrix
######

The docs have an example of a two-dimensional array or matrix of double values.  I've modified it to store Ints.  The row and column variables provide entry to the underlying data structure, which is just an array of Ints.

.. sourcecode:: bash

    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Int]
        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            grid = Array(count: rows * columns, repeatedValue: 0)
        }
        func indexIsValidForRow(row: Int, column: Int) -> Bool {
            return row >= 0 && row < rows && column >= 0 && column < columns
        }    
        subscript(row: Int, column: Int) -> Int {
            get {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                return grid[(row * columns) + column]
            }
            set {
                assert(indexIsValidForRow(row, column: column), "Index out of range")
                grid[(row * columns) + column] = newValue
            }
        }
    }

    var m = Matrix(rows: 2, columns: 2)
    m[0, 1] = 1
    m[1, 0] = 3
    println(m)
    println("\(m[0,0]) \(m[0,1])\n\(m[1,0]) \(m[1,1])")

.. sourcecode:: bash

    > xcrun swift test.swift
    test.Matrix
    0 1
    3 0

I'm going to strip out the error checking since I never make mistakes.  :)
And then I want a more flexible way of printing the matrix.  To build each line of the output, convert a slice, obtained by calling ``grid[range]``, to a String.  I found this:

http://vperi.com/2014/06/04/flatten-an-array-to-a-string-swift-extension/

.. sourcecode:: bash

    extension Slice {
      func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
          str += "\(item)"
          if idx < self.count-1 {
            str += separator
          }
        }
        return str
      }
    }

    var a = [1,2,3]
    var s = a[0...2]
    println(s.combine("*"))

.. sourcecode:: bash

    > xcrun swift test.swift
    1*2*3
    >

This extension builds the string by repeated concatenation.  Probably the library method ``join(sep,array)`` would be better, except it takes an array of String values.  So we'll go with this for the time being.

Now, we take the modified class (no error checking), and add to it a method ``repr`` and a couple other tricks:

.. sourcecode:: bash

    extension Array {
        func combine(separator: String) -> String {
            var str : String = ""
            for (idx, item) in enumerate(self) {
                str += "\(item)"
                if idx < self.count-1 {
                    str += separator
                }
            }
            return str
        }
    }

    extension String {
        func rjust(n: Int) -> String {
            let length = countElements(self)
            var extra = n - length
            if extra <= 0 { return self }
            let pad = String(count: extra, repeatedValue: Character(" "))
            return pad + self
        }   
    }

    struct Matrix {
        let rows: Int, columns: Int
        var grid: [Int] = [0]

        init(rows: Int, columns: Int) {
            self.rows = rows
            self.columns = columns
            self.grid = Array(count: rows * columns, repeatedValue: 0)
        }

        init(rows: Int, columns: Int, values: [Int] = [0]) {
            self.rows = rows
            self.columns = columns
            if countElements(values) != rows*columns {
                self.grid = Array(count: rows * columns, repeatedValue: 0)
            }
            else {
                self.grid = values
            }
        }

        subscript(row: Int, column: Int) -> Int {
            get {
                return self.grid[(row * columns) + column]
            }
            set {
                self.grid[(row * columns) + column] = newValue
            }
        }

        var repr: String {
            get {
                let n = countElements(String(maxElement(grid)))
                var s = ""
                for i in 0...rows-1 {
                    var str_array = [String]()
                    var c: String
                    let current = i*rows
                    for j in 0...columns-1 {
                         c = String(self.grid[current + j])
                         str_array.append(c.rjust(n))
                    }
                    let slice = Array(str_array[0...str_array.count-1])
                    s += slice.combine(" ")
                    if i < rows - 1 { s += "\n" }
                }
                return s
            }
        }
    }

    var m = Matrix(rows: 2, columns: 2, values:[1,2,3,4])
    println(m.repr)
    m[0, 1] = 1995
    m[1, 0] = 500
    println(m.repr)
    
.. sourcecode:: bash

    > xcrun swift test.swift
    1 2
    3 4
       1 1995
     500    4
    >
    
I added a String extension that does ``rjust``, and changed the Slice extension to be on Array instead, and convert to an Array before calling ``combine``.  There is a constructor that takes input data for the matrix, as well as the dimensions.

