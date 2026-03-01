# 200. Number of Islands

https://leetcode.com/problems/number-of-islands/
### step1
- 再帰使いそうだなあと思いつつ、書ける気がしなかったので他の方のコードを見た
- DFS が書きやすそうだったので書いてみた
- grid 変更不可と言われたら、set を使って探索済みの idx を記録すると思う
- 関数名を最初 DFS にしていたがそれはアルゴリズムの話で、目的と関係なかったので変えた。

- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
class Solution:
    def numIslands(self, grid: list[list[str]]) -> int:
        height = len(grid)
        width = len(grid[0])

        def sink_island(row, col):
            if not (0 <= row < height and 0 <= col < width):
                return
            if grid[row][col] == '0':
                return
            grid[row][col] = '0'
            for i in (-1, 1):
                sink_island(row + i, col)
                sink_island(row, col + i)

        num_islands = 0
        for row in range(height):
            for col in range(width):
                if grid[row][col] == '0':
                    continue
                num_islands += 1
                sink_island(row, col)
        return num_islands
```

### step2
#### step2.1
- 次は、BFS
- ちょっとごちゃごちゃしているので関数化したかったが、大して変わるものが書けなかった
- deque の初期化でエラーが出た。
    - どうやら、初期化のときだけ展開されるらしい。
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
from collections import deque


class Solution:
    def numIslands(self, grid: list[list[str]]) -> int:
        height = len(grid)
        width = len(grid[0])

        def sink_island(row, col):
            grid[row][col] = '0'
            q = deque([(row, col)])

            while q:
                row, col = q.popleft()
                for offset_row, offset_col in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    next_row  = row + offset_row
                    next_col = col + offset_col
                    if not (0 <= next_row < height and 0 <= next_col < width):
                        continue
                    if grid[next_row][next_col] == '0':
                        continue
                    grid[next_row][next_col] = '0'
                    q.append((next_row, next_col))

        num_islands = 0
        for row in range(height):
            for col in range(width):
                if grid[row][col] == '0':
                    continue
                num_islands += 1
                sink_island(row, col)
        return num_islands
```

#### step2.2
- UnionFind
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
class UnionFind:
    def __init__(self, grid) -> None:
        height = len(grid)
        width = len(grid[0])
        self.parents = {}
        self.num_island = 0

        for row in range(height):
            for col in range(width):
                if grid[row][col] == '0':
                    continue
                self.parents[(row, col)] = (row, col)
                self.num_island += 1

    def find(self, position):
        while self.parents[position] != position:
            self.parents[position] = self.parents[self.parents[position]]
            position = self.parents[position]
        return position

    def union(self, position1, position2):
        root_1 = self.find(position1)
        root_2 = self.find(position2)
        if root_1 == root_2:
            return
        self.parents[root_2] = root_1
        self.num_island -= 1

class Solution:
    def numIslands(self, grid):
        height = len(grid)
        width = len(grid[0])
        uf = UnionFind(grid)

        def is_land(row, col):
            return grid[row][col] == '1'

        for row in range(height):
            for col in range(width):
                if not is_land(row, col):
                    continue
                if row + 1 < height and is_land(row + 1, col):
                    uf.union((row, col), (row + 1, col))
                if col + 1 < width and is_land(row, col + 1):
                    uf.union((row, col), (row, col + 1))
        return uf.num_island
```
- Union by Size（[shining-aiさん](https://github.com/shining-ai/leetcode/blob/8615f109c56fa5dacdfff743d81f8d27b6ab90e4/arai60/17-20_Graph_BFS_DFS/17_200_Number%20of%20Islands/level_2.py)）
    - 根の size を記録しておき、大きい方を親にすると計算量が O(logN) になる。
```python
def union(self, node1, node2):
    root1 = self.find_root(node1)
    root2 = self.find_root(node2)
    if root1 == root2:
        return
    if self.size[root1] < self.size[root2]:
        self.parent[root1] = root2
        self.size[root2] += self.size[root1]
    else:
        self.parent[root2] = root1
        self.size[root1] += self.size[root2]
```
- これは以下のようにも書ける ([odaさん](https://discord.com/channels/1084280443945353267/1201211204547383386/1213387878734766080))
```python
def union(self, node1, node2):
    bigger = self.find_root(node1)
    smaller = self.find_root(node2)
    if bigger == smaller:
        return
    if self.size[bigger] < self.size[smaller]:
        bigger, smaller = smaller, bigger
    self.parents[smaller] = bigger
    self.size[bigger] += self.size[smaller]
```

### step3
- BFS
- hash set を使って島を沈めずに探索済みを表現
    - Deep copy もあるが、そっちは必ず追加でO(M * N)
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
from collections import deque


class Solution:
    def numIslands(self, grid: list[list[str]]) -> int:
        height = len(grid)
        width = len(grid[0])
        visited = set()

        def mark_island_visited(row, col):
            visited.add((row, col))
            q = deque([(row, col)])

            while q:
                row, col = q.popleft()
                for offset_row, offset_col in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    next_row  = row + offset_row
                    next_col = col + offset_col
                    if not (0 <= next_row < height and 0 <= next_col < width):
                        continue
                    if grid[next_row][next_col] == '0':
                        continue
                    if (next_row, next_col) in visited:
                        continue
                    visited.add((next_row, next_col))
                    q.append((next_row, next_col))

        num_islands = 0
        for row in range(height):
            for col in range(width):
                if grid[row][col] == '0':
                    continue
                if (row, col) in visited:
                    continue
                num_islands += 1
                mark_island_visited(row, col)
        print(grid)
        return num_islands
```


