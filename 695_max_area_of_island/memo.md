# 695. Max Area of Island

https://leetcode.com/problems/max-area-of-island/
### step1
- 自力で解いてみた。DFS。
- mutable, recursion についてよく分かっていなかった
- 以下は、int ,ローカル変数の使い方を間違えているので Accept されません。
```python
class Solution:
    def maxAreaOfIsland(self, grid: list[list[int]]) -> int:
        max_area = 0
        visited = set()
        num_rows = len(grid)
        num_cols = len(grid[0])

        def traverse_island(row, col, area) -> int:
            if not (0 <= row < num_rows and 0 <= col < num_cols):
                return
            if grid[row][col] == 0:
                return
            if (row, col) in visited:
                return
            visited.add((row, col))
            area += 1
            traverse_island(row - 1, col, area)
            traverse_island(row + 1, col, area)
            traverse_island(row, col - 1, area)
            traverse_island(row, col + 1, area)
            return area

        for row in range(num_rows):
            for col in range(num_cols):
                if grid[row][col] == 0:
                    continue
                if (row, col) in visited:
                    continue
                area = 0
                area = traverse_island(row, col, area)
                max_area = max(max_area, area)
        return max_area
```
- ↑
- 再帰で関数を呼び出したとき、area (label)のコピーが渡されること。
- int は immutable なので、一番上の関数が持っている area が指しているものは変化しない（+ 1すると、新しいオブジェクトを指す）

- 修正。
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
class Solution:
    def maxAreaOfIsland(self, grid: list[list[int]]) -> int:
        max_area = 0
        visited = set()
        num_rows = len(grid)
        num_cols = len(grid[0])

        def measure_island_area(row, col) -> int:
            if not (0 <= row < num_rows and 0 <= col < num_cols):
                return 0
            if grid[row][col] == 0:
                return 0
            if (row, col) in visited:
                return 0
            visited.add((row, col))
            return 1 + measure_island_area(row - 1, col) + measure_island_area(row + 1, col) + measure_island_area(row, col - 1) + measure_island_area(row, col + 1)


        for row in range(num_rows):
            for col in range(num_cols):
                max_area = max(max_area, measure_island_area(row, col))
        return max_area
```
### step2
#### step 2.1 BFS
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
from collections import deque


class Solution:
    def maxAreaOfIsland(self, grid: list[list[int]]) -> int:
        max_area = 0
        visited = set()
        num_rows = len(grid)
        num_cols = len(grid[0])

        def measure_island_area(row, col) -> int:
            if grid[row][col] == 0:
                return 0
            if (row, col) in visited:
                return 0

            area = 0
            frontier = deque([(row, col)])
            visited.add((row, col))
            while frontier:
                row, col = frontier.popleft()
                area += 1
                for row_offset, col_offset in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    next_row = row + row_offset
                    next_col = col + col_offset
                    if not (0 <= next_row < num_rows and 0 <= next_col < num_cols):
                        continue
                    if grid[next_row][next_col] == 0:
                        continue
                    if (next_row, next_col) in visited:
                        continue
                    frontier.append((next_row, next_col))
                    visited.add((next_row, next_col))
            return area

        for row in range(num_rows):
            for col in range(num_cols):
                area = measure_island_area(row, col)
                max_area = max(max_area, area)

        return max_area
```
#### step2.2 UnionFind
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
- UnionFindで右・下の2方向だけを見る理由
    - 左上から右下へ順にイテレートするため、各セルが右と下を担当すれば、グリッド上の全隣接ペアが漏れなくカバーされる。
    - 上・左は既に処理済みのセルから結合済み。
    - DFS/BFSは1点から連結成分を探索するため全4方向が必要
```python
class UnionFind:
    def __init__(self, n):
        self.parents = list(range(n))
        self.size = [1] * n

    def find(self, x):
        if self.parents[x] != x:
            self.parents[x] = self.find(self.parents[x])
        return self.parents[x]

    def union(self, x, y):
        bigger = self.find(x)
        smaller = self.find(y)
        if bigger == smaller:
            return
        if self.size[bigger] < self.size[smaller]:
            bigger, smaller = smaller, bigger
        self.parents[smaller] = bigger
        self.size[bigger] += self.size[smaller]

class Solution:
    def maxAreaOfIsland(self, grid: list[list[int]]) -> int:
        num_rows = len(grid)
        num_cols = len(grid[0])
        uf = UnionFind(num_rows * num_cols)

        def is_land(row, col):
            return grid[row][col] == 1

        for row in range(num_rows):
            for col in range(num_cols):
                if not is_land(row, col):
                    continue
                idx = row*num_cols + col
                if row + 1 < num_rows and is_land(row + 1, col):
                    uf.union(idx, idx + num_cols)
                if col + 1 < num_cols and is_land(row, col + 1):
                    uf.union(idx, idx + 1)

        max_area = 0
        for row in range(num_rows):
            for col in range(num_cols):
                if not is_land(row, col):
                    continue
                root = uf.find(row*num_cols + col)
                max_area = max(max_area, uf.size[root])

        return max_area
```
### step3
- DFS は再帰に入る前にチェックしてもよい（[odaさん](https://github.com/colorbox/leetcode/pull/32#discussion_r1898178545)）
- 時間計算量
    - O(M * N)
- 空間計算量
    - O(M * N)
```python
class Solution:
    def maxAreaOfIsland(self, grid: list[list[int]]) -> int:
        max_area = 0
        num_rows = len(grid)
        num_cols = len(grid[0])
        visited = set()

        def measure_island_area(row, col) -> int:
            visited.add((row, col))
            def recurse_if_adequate(row, col):
                if not (0 <= row < num_rows and 0 <=col < num_cols):
                    return 0
                if grid[row][col] == 0:
                    return 0
                if (row, col) in visited:
                    return 0
                return measure_island_area(row, col)

            return 1 + (recurse_if_adequate(row - 1, col)
                     + recurse_if_adequate(row + 1, col)
                     + recurse_if_adequate(row, col - 1)
                     + recurse_if_adequate(row, col + 1)
                     )

        for row in range(num_rows):
            for col in range(num_cols):
                if grid[row][col] == 0:
                    continue
                if (row, col) in visited:
                    continue
                max_area = max(max_area, measure_island_area(row, col))
        return max_area
```

#### その他
- 同じコードを何度も書いていると色々と発見がある。 early return　の順番だったり、繰り返しの処理は一番最初と、最後の処理を意識するとか。
