def findPivotColumn():
    minEntry = float('inf')
    pivotColumn = float('inf')
    for i in range(0, noVariables):
        if c[i] < minEntry and c[i] < 0:
            minEntry = c[i]
            pivotColumn = i
    return pivotColumn

def findPivotColumnDual():
    maxQuotient = -float('inf')
    pivotColumn = float('inf')
    for i in range(0, noVariables):
        if A[pivotRow][i] < 0 and c[i] / A[pivotRow][i] > maxQuotient:
            maxQuotient = c[i] / A[pivotRow][i]
            pivotColumn = i
    return pivotColumn
    
def findPivotRow():
    minQuotient = float('inf')
    pivotRow = float('inf')
    for i in range(0, noConstraints):
        if A[i][pivotColumn] > 0 and b[i] / A[i][pivotColumn] < minQuotient:
            minQuotient = b[i] / A[i][pivotColumn]
            pivotRow = i
    return pivotRow

def findPivotRowDual():
    minEntry = float('inf')
    pivotRow = float('inf')
    for i in range(0, noConstraints):
        if b[i] < minEntry and b[i] < 0:
            minEntry = b[i]
            pivotRow = i
    return pivotRow

def pivotize():
    aux = basisVariables[pivotRow] 
    basisVariables[pivotRow] = nonBasisVariables[pivotColumn]
    nonBasisVariables[pivotColumn] = aux
    pivotElement = A[pivotRow][pivotColumn]

    A_new = []
    for i in range(0, noConstraints):
        A_new.append([])
        for j in range(0, noVariables):
            A_new[i].append(A[i][j] - A[i][pivotColumn] * A[pivotRow][j] / pivotElement)
    for i in range(0, noConstraints):
        A_new[i][pivotColumn] = -A[i][pivotColumn] / pivotElement
    for j in range(0, noVariables):
        A_new[pivotRow][j] = A[pivotRow][j] / pivotElement
    A_new[pivotRow][pivotColumn] = 1 / A[pivotRow][pivotColumn]
    
    b_new = []
    for i in range(0, noConstraints):
        b_new.append(b[i] - b[pivotRow] * A[i][pivotColumn] / pivotElement)
    b_new[pivotRow] = b[pivotRow] / pivotElement
    
    c_new = []
    for j in range(0, noVariables):
        c_new.append(c[j] - c[pivotColumn] * A[pivotRow][j] / pivotElement)
    c_new[pivotColumn] = -c[pivotColumn] / pivotElement
    
    z_new = z - c[pivotColumn] * b[pivotRow] / pivotElement
    
    return [basisVariables, nonBasisVariables, A_new, b_new, c_new, z_new]

def stabilizeTableau():
    for i in range(0, len(b)):
        for j in range(0, len(c)):
            if abs(A[i][j] - round(A[i][j])) < 0.001:
                A[i][j] = round(A[i][j])
        if abs(b[i] - round(b[i])) < 0.001:
            b[i] = round(b[i])
            
def getRowIndexWithNonIntegerValue():
    rowIndex = -1
    for i in range(0, len(b)):
        if abs(b[i] - round(b[i])) > 0.001 and basisVariables[i].startswith("x") and rowIndex == -1:
            rowIndex = i
    return rowIndex

def printTableau():
    print("\nTableau:")
    print("\t\t", end =" ")
    for j in range(0, noVariables):
        print(str(nonBasisVariables[j]) + "\t".expandtabs(5), end =" ")
    print()
    print("----------------------------------")
    print("z" + "\t", end =" ")
    print("|" + "\t", end =" ")
    for j in range(0, noVariables):
        print(str(c[j]) + "\t", end =" ")
    print("|" + "\t", end =" ")
    print(z)
    print("----------------------------------")
    for i in range(0, noConstraints):
        print(str(basisVariables[i]) + "\t", end =" ")
        print("|" + "\t", end =" ")
        for j in range(0, noVariables):
            print(str(A[i][j]) + "\t", end =" ")
        print("|" + "\t", end =" ")
        print(b[i])

nonBasisVariables = ["x1", "x2"]
c = [4, -1]
A = [[7, -2], [2, -2], [0, 1]]
b = [14, 3, 3]
z = 0

noVariables = len(c)
noConstraints = len(b)
basisVariables = []
for i in range(0, noConstraints):
    basisVariables.append("x" + str(i+1+noVariables))
for i in range(0, noVariables):
    c[i] = -c[i]

printTableau()

while min(c) < 0:
    pivotColumn = findPivotColumn()
    pivotRow = findPivotRow()
    [basisVariables, nonBasisVariables, A, b, c, z] = pivotize()
    printTableau()
    
rowIndex = getRowIndexWithNonIntegerValue()
while rowIndex != -1:
    additionalRow = []
    for j in range(0, len(c)):
        if A[rowIndex][j] >= 0:
            additionalRow.append(-(A[rowIndex][j] - int(A[rowIndex][j])))
        else:
            additionalRow.append(-(A[rowIndex][j] - int(A[rowIndex][j])) - 1)
    A.append(additionalRow)
    b.append(-(b[rowIndex] - int(b[rowIndex])))
    basisVariables.append("s")
    noConstraints = int(noConstraints + 1)
    stabilizeTableau()
    printTableau()
    while min(b) < -0.001:
        pivotRow = findPivotRowDual()
        pivotColumn = findPivotColumnDual()
        [basisVariables, nonBasisVariables, A, b, c, z] = pivotize()
        stabilizeTableau()
        printTableau()
    rowIndex = getRowIndexWithNonIntegerValue()