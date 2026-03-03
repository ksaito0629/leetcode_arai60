# Number of Connected Components in an Undirected Graph (neetcode)

https://neetcode.io/problems/count-connected-components/question
### step1
- 自力で解いてみた。accept されない
```python
class Solution:
    def countComponents(self, n: int, edges: list[list[int]]) -> int:
        num_components = 0
        visited = set()

        def traverse_component(start):
            if start in visited:
                return
            visited.add(start)

            for end in start_to_end[start]:
                traverse_component(end)

        start_to_end = defaultdict(list)
        for start, end in edges:
            start_to_end[start].append(end)
            start_to_end[end].append(start)

        for start in list(start_to_end):
            if start in visited:
                continue
            num_components += 1
            traverse_component(start)

        return num_components
```
- どうやら、n 個のノードがあって、かつエッジの値が 0 から n-1　の範囲なので、ノードは
    - 0, 1, 2, ..., n-1 の n個らしい。エッジに現れなくても存在することがある。
    - 問題文よんでて、方針が思いつくとすぐに書き始めるのよくないか？
- 途中で出たエラー： 辞書はfor で回せないのか？？
    - ループ中に辞書のサイズを変更するとエラーが出る
        - 対処
        -   list() でコピーしてから渡す
### step2.1 DFS
- step1を修正した
- DFS で探索済みの Node をどんどん visited に入れていく。
- 時間計算量
    - O(V + E)
        - 頂点の数を V , edges の数を E　とすると、頂点を1回、edgesを無向グラフなので2回見る
- 空間計算量
    - O(V + E)
```python
class Solution:
    def countComponents(self, n: int, edges: list[list[int]]) -> int:
        num_components = 0
        visited = set()

        def traverse_component(start):
            if start in visited:
                return
            visited.add(start)

            for end in start_to_end[start]:
                traverse_component(end)

        start_to_end = defaultdict(list)
        for start, end in edges:
            start_to_end[start].append(end)
            start_to_end[end].append(start)

        for start in range(n):
            if start in visited:
                continue
            num_components += 1
            traverse_component(start)

        return num_components
```
### step2.2 BFS
- 時間計算量
    - O(V + E)
- 空間計算量
    - O(V + E)
```python
from collections import defaultdict
from collections import deque


class Solution:
    def countComponents(self, n: int, edges: list[list[int]]) -> int:
        """
        次はBFS
        辞書で無向グラフを作って、
        行ける範囲をすべて、visitedに
        """
        num_components = 0
        visited = set()
        start_to_end = defaultdict(list)

        def traverse_component(i):
            frontier = deque([i])
            visited.add(i)

            while frontier:
                start = frontier.popleft()
                for end in start_to_end[start]:
                    if end in visited:
                        continue
                    visited.add(end)
                    frontier.append(end)

        for start, end in edges:
            start_to_end[start].append(end)
            start_to_end[end].append(start)

        for i in range(n):
            if i in visited:
                continue
            num_components += 1
            traverse_component(i)
        return num_components
```
途中で出たエラー： dequeの初期化で iterable ではないintは、渡してはいけない。[i]としなきゃいけない
### step2.3 UnionFind
- UnionFind
    - 無向グラフなので、両方向から辞書を作る

- 時間計算量
    - O(V + E*α(V))
        - α は逆アッカーマン関数。ほぼ定数みたい。
- 空間計算量
    - O(E + V)
```python
from collections import defaultdict


class UnionFind:
    def __init__(self, n):
        self.parents = list(range(n))
        self.count = n
        self.rank = [1]*n

    def find(self, x):
        if self.parents[x] != x:
            self.parents[x] = self.find(self.parents[x])
        return self.parents[x]

    def union(self, x, y):
        bigger = self.find(x)
        smaller = self.find(y)
        if bigger == smaller:
            return
        if self.rank[bigger] < self.rank[smaller]:
            bigger, smaller = smaller, bigger
        self.parents[smaller] = bigger
        self.rank[bigger] += 1
        self.count -= 1

class Solution:
    def countComponents(self, n: int, edges: list[list[int]]) -> int:
        """
        次はUnionFind
        つながるたびに、count -= 1していけばいいはず
        """
        uf = UnionFind(n)
        start_to_end = defaultdict(list)

        for start, end in edges:
            start_to_end[start].append(end)
            start_to_end[end].append(start)

        for i in range(n):
            for end in start_to_end[i]:
                uf.union(i, end)
        return uf.count
```
### step3 UnionFind
- step2.3のミスを修正
- わざわざ、両方向から union する必要はない
- rank についてよく分かっていなかった
    - 大きい方の根を、小さい方の根の親にする。
        - 大きい方の根から伸びるイメージ。
        - そうすると、高さは最大で 1 だけ大きくなる（rank が一緒のときは、一つ分浮くので）
- 時間計算量
    - O(V + E*α(V))
        - α は逆アッカーマン関数。ほぼ定数みたい。
- 空間計算量
    - O(V)
```python
class UnionFind:
    def __init__(self, n):
        self.parents = list(range(n))
        self.count = n
        self.rank = [0]*n

    def find(self, x):
        while self.parents[x] != x:
            self.parents[x] = self.parents[self.parents[x]]
            x = self.parents[x]
        return x

    def union(self, x, y):
        bigger = self.find(x)
        smaller = self.find(y)
        if bigger == smaller:
            return
        if self.rank[bigger] < self.rank[smaller]:
            bigger, smaller = smaller, bigger
        elif self.rank[bigger] == self.rank[smaller]:
            self.rank[bigger] += 1
        self.parents[smaller] = bigger
        self.count -= 1

class Solution:
    def countComponents(self, n: int, edges: list[list[int]]) -> int:
        uf = UnionFind(n)
        for start, end in edges:
            uf.union(start, end)

        return uf.count
```

### その他
頭の中でデバッガを回すと、大抵チェック漏れがあって、細かいエラーが出る。ロジックエラーももちろんあるし、なかなか難しい、、
```python
def traverse_component(start):
    if start in visited:              # ① チェック
        return
    visited.add(start)                # ② 追加

    for end in start_to_end[start]:   # ③ 隣接頂点を走査
        traverse_component(end)       # 再帰
```

この関数は再帰で何度も呼ばれますが、**全呼び出しを合計して**考えます。

**①と②について：**
`visited.add(start)` を通過するのは、各頂点につき1回だけです。2回目以降は①で `return` するからです。なので②の実行回数は全体で **V回**。

では①のチェックは何回実行されるか？ これは「`traverse_component` が何回呼ばれるか」と同じです。呼ばれるパターンは2つ：

- パート2の外側ループから呼ばれる → **最大V回**
- ③の `for` ループの中から再帰で呼ばれる → **後述**

**③について：**
ある頂点 `start` で②を通過した（= 初めて訪問した）とき、`for end in start_to_end[start]` が回ります。このループの回数は `start_to_end[start]` の長さ、つまりその頂点の隣接辺の数です。

具体例で考えます。V=4, 辺が `[0,1], [1,2], [2,3]` の場合：
```
start_to_end[0] = [1]        → 長さ1
start_to_end[1] = [0, 2]     → 長さ2
start_to_end[2] = [1, 3]     → 長さ2
start_to_end[3] = [2]        → 長さ1
