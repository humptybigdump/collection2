knoten = ["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8"]
kante_12 = {
  "start": "v1",
  "ende":  "v2",
  "laenge": 3    
}
kante_13 = {
  "start": "v1",
  "ende":  "v3",
  "laenge": 2    
}
kante_24 = {
  "start": "v2",
  "ende":  "v4",
  "laenge": 5    
}
kante_31 = {
  "start": "v3",
  "ende":  "v1",
  "laenge": 1   
}
kante_32 = {
  "start": "v3",
  "ende":  "v2",
  "laenge": 1    
}
kante_42 = {
  "start": "v4",
  "ende":  "v2",
  "laenge": 4    
}
kante_43 = {
  "start": "v4",
  "ende":  "v3",
  "laenge": 2   
}
kante_45 = {
  "start": "v4",
  "ende":  "v5",
  "laenge": 9    
}
kante_46 = {
  "start": "v4",
  "ende":  "v6",
  "laenge": 5    
}
kante_56 = {
  "start": "v5",
  "ende":  "v6",
  "laenge": 8   
}
kante_64 = {
  "start": "v6",
  "ende":  "v4",
  "laenge": 11    
}
kante_67 = {
  "start": "v6",
  "ende":  "v7",
  "laenge": 6   
}
kante_68 = {
  "start": "v6",
  "ende":  "v8",
  "laenge": 2    
}
kante_87 = {
  "start": "v8",
  "ende":  "v7",
  "laenge": 3   
}
kanten = [kante_12, kante_13, kante_24, kante_31, kante_32, kante_42, kante_43, kante_45, kante_46, kante_56, kante_64, kante_67, kante_68, kante_87]

#List comprehension als hilfreiches Konstrukt (Filter von Listenelementen)
#print([kante for kante in kanten if kante["start]=="v1"])

matrix = []
for i in knoten:
    for j in knoten:
        if i == j:
            matrix.append({"von": i, "nach": j, "weglaenge": 0, "vorgaenger": i})
        elif len([kante["laenge"] for kante in kanten if kante["start"] == i and kante["ende"] == j]) > 0:
            matrix.append({"von": i, "nach": j, "weglaenge": [kante["laenge"] for kante in kanten if kante["start"] == i and kante["ende"] == j][0], "vorgaenger": i})
        else:
            matrix.append({"von": i, "nach": j, "weglaenge": float('inf'), "vorgaenger": None})
            
for j in knoten:
    for i in knoten:
        for k in knoten:
            c_ij = [eintrag["weglaenge"] for eintrag in matrix if eintrag["von"] == i and eintrag["nach"] == j][0]
            c_jk = [eintrag["weglaenge"] for eintrag in matrix if eintrag["von"] == j and eintrag["nach"] == k][0]
            c_ik = [eintrag["weglaenge"] for eintrag in matrix if eintrag["von"] == i and eintrag["nach"] == k][0]
            if c_ij + c_jk < c_ik:
                for eintrag in matrix:
                    if eintrag["von"] == i and eintrag["nach"] == k:
                        eintrag["weglaenge"] = c_ij + c_jk
                        p_jk = [eintrag["vorgaenger"] for eintrag in matrix if eintrag["von"] == j and eintrag["nach"] == k][0]
                        eintrag["vorgaenger"] = p_jk
                        
for eintrag in matrix:
    print(eintrag)