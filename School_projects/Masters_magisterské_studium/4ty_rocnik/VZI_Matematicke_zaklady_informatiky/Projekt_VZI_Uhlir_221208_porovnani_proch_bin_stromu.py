# projekt na porovnání zátěže rekurzivního procházení BST a procházení pomocí fronty u velkých stromů

import stack
import queue
from timeit import default_timer
import random

class Node:
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None
    
    def set_data(self, data):
        self.data = data

    def get_data(self):
        return self.data
    
    def set_left(self, node):
        self.left = node

    def get_left(self):
        return self.left

    def set_right(self, node):
        self.right = node

    def get_right(self):
        return self.right
    
class BSTree():
    def __init__(self):
        self.root = None
        self.node_ammount = 0

    def get_root(self):
        return self.root
    
    def insert(self, data):
        self.root = self.insert_data(self.root, data)
    
    def insert_data(self, parent, data):
        if parent == None:
            return Node(data)
        if data == parent.get_data():
            return parent
        if data < parent.get_data():
            parent.set_left(self.insert_data(parent.get_left(), data))
        else:
            parent.set_right(self.insert_data(parent.get_right(), data))
        return parent
    
# Přidání metod pro procházení stromu

    #global node_ammount
    
    def dfs_traverse_pre_order(self, node):         # zpětné procházení stomu
        if node is not None:
            self.dfs_traverse_pre_order(node.get_left())
            self.dfs_traverse_pre_order(node.get_right())
            self.node_ammount += 1
        

    def dfs_traverse_in_order_LH(self, node):       # postupné procházení od nejmenšího
        if node is not None:
            self.dfs_traverse_in_order_LH(node.get_left())
            self.dfs_traverse_in_order_LH(node.get_right())

    def dfs_traverse_in_order_HL(self, node):       # postupné procházení od největšího
        if node is not None:
            self.dfs_traverse_in_order_HL(node.get_right())
            self.dfs_traverse_in_order_HL(node.get_left())
            
    def dfs_traverse_post_order(self, node):        # procházení po vrstvách
        if node is not None:
            self.dfs_traverse_post_order(node.get_left())
            self.dfs_traverse_post_order(node.get_right())  

    def dfs_traverse(self, node):       # procházení zásobníkem (last in first out)
        lifo = stack.Stack()
        lifo.push(node)
        while not lifo.is_empty():
            actual_node = lifo.pop()
            if actual_node != None:
                lifo.push(actual_node.get_right())
                lifo.push(actual_node.get_left())

    def bfs_traverse(self, node):       # procházení frontou (first in first out)
        fifo = queue.Queue()
        fifo.push(node)
        while not fifo.is_empty():
            actual_node = fifo.pop()
            if actual_node != None:
                fifo.push(actual_node.get_left())
                fifo.push(actual_node.get_right())


# algoritmus pro generování strom
tree = BSTree()

# nastavení maximální hodnoty ve stromu

# print("")
# print("")

# n = int(input("vložte maximální hodnotu ve stromu (maximálně 1,000,000):"))
# if n > 1000000:
#     #raise ValueError("Zadaná hodnota příliš vysoká")
#     print("Zadaná hodnota příliš vysoká!")
#     n = int(input("Zadejde hodnotu znovu:"))
#     if n > 1000000:
#         print("Zadaná hodnota opět přííliš vysoká!!!")
#         print("Hodnota bude zaokrouhlena na 1,000,000")
#         n = 1000000

# print("----")
# print("Maximální velikost stromu nastavena na: ", n)
# print("----")

# pevné nastavení počtu prvků
n = 1000000

i = 0
velikost = "10^" + str(len(str(n))-1)
print("Spuštěno generování stromu o maximálním počtu", velikost, "prvků")
start = default_timer()
while i < n:
    temp_data = random.sample(range(n+1), 1)
    tree.insert(temp_data)
    i += 1
    # print("index:", i, "-->", temp_data)
end = default_timer()
time = end - start
jednotka = "s"
if time > 60:
    time = time / 60
    jednotka = "min"

print("Generace stromu hotova", "||", "čas procesu:",round(time, 4), jednotka)

print("===============================================================")
print("===============================================================")
# měření zpětného procházení stromu
start = default_timer()
tree.dfs_traverse_pre_order(tree.get_root())
end = default_timer()
print("PreOrder hotovo", "||", "čas procesu:",round(end-start, 4), "s")

print("===============================================================")
# měření postupného procházení od největšího prvku stromu
start = default_timer()
tree.dfs_traverse_in_order_HL(tree.get_root())
end = default_timer()
print("InOrder od nejvyššího hotovo", "||", "čas procesu:",round(end-start, 4), "s")

print("===============================================================")
# měření postupného procházení od nejmenšího prvku stromu
start = default_timer()
tree.dfs_traverse_in_order_LH(tree.get_root())
end = default_timer()
print("InOrder od nejnižšího hotovo", "||", "čas procesu:",round(end-start, 4), "s")

print("===============================================================")
# měření procházení stromu po vrstvách
start = default_timer()
tree.dfs_traverse_post_order(tree.get_root())
end = default_timer()
print("PostOrder hotovo", "||", "čas procesu:",round(end-start, 4), "s")

print("===============================================================")
# měření procházení stromu zásobníkem (stack / LIFO)
start = default_timer()
tree.dfs_traverse(tree.get_root())
end = default_timer()
print("Zásobník LIFO dokončen", "||", "čas procesu:",round(end-start, 4), "s")

print("===============================================================")
# měření procházení stromu frontou (queue / FIFO)
start = default_timer()
tree.bfs_traverse(tree.get_root())
end = default_timer()
print("Fronta FIFO dokončena", "||", "čas procesu:",round(end-start, 4), "s")

print("===============================================================")
print("Reálný počet prvků ve stromu:", tree.node_ammount)

print("")
print("")