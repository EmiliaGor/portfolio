# from colorama import Fore, Back, Style5
import random
# Emilia Gornisiewicz 27.01.2023

class Graph:
    Adj_matrix = []  # Macierz sasiedztwa
    n = 0
    m = 0

    # konstruktor ustawia wartości macierzy sasiedztwa na 0 krawedzie sa nie poloczone
    def __init__(self, n, m):
        random.seed()
        self.Adj_matrix = [[0 for i in range(n*m)] for j in range(n*m)]
        self.n = n
        self.m = m

    def add_edge(self, x, y):  # funkcja dodajaca krawedzie grafu
        self.Adj_matrix[x][y] = 1
        self.Adj_matrix[y][x] = 1

    def rem_edge(self, x, y):  # funkcja usuwajaca krawedzie grafu
        self.Adj_matrix[x][y] = 0
        self.Adj_matrix[y][x] = 0

    def get_edges(self, x):  # funkcja zwracjaca krawedzie wychodzoce z wirzcholka o indeksie x
        result = []
        for i in range(0, len(self.Adj_matrix[x])):
            if(self.are_connected(i, x)):
                result.append([i, x])
        return result

    # funkcja sprawdzajaca czy wierzcholki o inkesach x i y sa poloczone
    def are_connected(self, x, y):
        if(self.Adj_matrix[x][y] > 0):
            return True
        else:
            return False

    def make_walls(self):  # funkcja laczoca wierzcholki w kszalt prostokata
        i = 0
        j = 1
        while(j < self.n*self.m):  # laczy wirzcholki w rzedy
            if(i % self.n != (self.n-1)):
                self.add_edge(i, j)
            i += 1
            j += 1

        i = 0
        j = self.n
        while(j < self.n*self.m):  # laczy wirzcholki w kolumny
            self.add_edge(i, j)
            i += 1
            j += 1


    # funkcja usuwa krawedzie zgodnie z algorytmem prima - w ksztalt minimalnego drzewa rozpinajacego 
    # jednak zamiast krawedzi o najmniejszej wadze wybiera je losowo
    # Wynikiem jest labirynt gdzie między dwoma dowlonymi polami istnieje dokladnie jedna trasa
    def prim(self):  
        g.make_walls()
        walls = []
        cells = []
        rand = []
        cells.append(0)
        for i in self.get_edges(0): # dodaje "sciany" wirzcholka poczatkowego do listy scian
            walls.append(i)
        while (len(walls) > 0):
            rand = walls[random.randint(0, len(walls)-1)] # Losuje krawedz z listy scian
            a = rand[0]
            b = rand[1]
            # Jezeli tylko jeden wierzcholkow krawedzi byl odwiedzony oznacz nieodwiedzony wierzcholek jak odwiedzony 
            # dodaj krawedzie z niego wychodzace do listy scian 
            # i usun sciane miedzy nimi
            if(a in cells and not b in cells):
                self.rem_edge(a, b)
                cells.append(b)
                for i in self.get_edges(b):
                    walls.append(i)
            elif(b in cells and not a in cells):
                self.rem_edge(a, b)
                cells.append(a)
                for i in self.get_edges(a):
                    walls.append(i)
            walls.remove(rand) # Usun wylosowany wierzcholek z listy scian

    def display(self): # funkcja wizualizujca obecny stan labiryntu
        # rysuje gorna krawedz labiryntu
        print('┌─', end='')
        for i in range(self.n-1):
            print('┬─', end='')
        print('┐')

        row = 0
        for temp in range(self.m):
            # Rysuje rzedy
            i = row
            j = row+1
            print('│ ', end='')
            while(j < self.n+row):
                # print(i," ",j)
                if(self.are_connected(i, j)):
                    print('│', end='')
                else:
                    print(' ', end='')
                print(' ', end='')
                i += 1
                j += 1
            print('│')
            i = row
            j = row+self.n

            # Rysuje kolumny
            if(j < self.n*self.m):
                while(i < self.n+row):
                    if (i == row):
                        print('├', end='')
                    else:
                        print('┼', end='')
                    if(self.are_connected(i, j)):
                        print('─', end='')
                    else:
                        print(' ', end='')
                    i += 1
                    j += 1
                print('┤')
            row += self.n

        # Rysuje Dolna krawdz labiryntu
        print('└─', end='')
        for i in range(self.n-1):
            print('┴─', end='')
        print('┘')

# Szerokosc i wysokosc labiryntu sa wprowadzane prze uzytkownika
print("Prosze podac szerokosc labiryntu:/Please input maze width: ", end='')
n = input()
while(not n.isdigit() or n[0] == '0'):
    print("Prosze podac szerokosc labiryntu Wymagana wartosc to liczba naturalna:/Please inpuit prime number:", end='')
    n = input()

print("Prosze podac wysokosc labiryntu:/Please inpuit maze hight: ", end='')
m = input()
while(not m.isdigit() or m[0] == '0'):
    print("Prosze podac wysoksc labiryntu Wymagana wartosc to liczba naturalna:/Please inpuit prime number: ", end='')
    m = input()

g = Graph(int(n), int(m))

g.prim()
g.display()
