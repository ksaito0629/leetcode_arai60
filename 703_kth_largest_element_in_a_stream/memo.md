# 703. Kth Largest Element in a Stream

https://leetcode.com/problems/kth-largest-element-in-a-stream/

## Comments

### step1
- sortedを使う方針のみ思いついた。
- __init__()
    - 時間計算量
        - O(1)
    - 空間計算量
        - O(N)
- add()
    - 時間計算量
        - O(NlogN)
    - 空間計算量
        - O(N)
```python
class KthLargest:

    def __init__(self, k: int, nums: List[int]):
        self.k = k
        self.nums = nums

    def add(self, val: int) -> int:
        """kthの値を効率よく取り出す方法がわからない。"""
        self.nums.append(val)
        nums_sorted = sorted(self.nums, reverse=True)
        return nums_sorted[self.k - 1]
```
- numsを破壊的変更してしまっているので、.copy()か、__init__でsorted()
- 毎回ソートするのは効率が悪そう
- 整列済みソートに値を追加する方法で、[bisect.insort](https://docs.python.org/3/library/bisect.html#bisect.insort_right)がある
- あと, nums全てを持つ必要はない。

```python
class KthLargest:
    def __init__(self, k: int, nums: List[int]):
        self.k = k
        self.nums = sorted(nums, reverse=True)[:k]

    def add(self, val: int) -> int:
        bisect.insort(self.nums, val, key=lambda x: -x)
        if len(self.nums) > self.k:
            self.nums.pop()
        return self.nums[-1]
```
- __init__()
    - 時間計算量
        - O(NlogN)
    - 空間計算量
        - O(N)
- add()
    - 時間計算量
        - O(k)
    - 空間計算量
        - O(1)
### step2
- [heapq](https://docs.python.org/3/library/heapq.html)は、heapify, heappop, heappush, heappushpopが今回使えそう。
- heappushpopはheappush + heappopより速い([Cpython](https://github.com/python/cpython/blob/main/Modules/_heapqmodule.c))
    - 1, 根の値とvalを比べ、根の値より以下ならそのままvalを返す O(1)
    - 2, そうでないなら、valを根に配置。そして、siftup O(log n)
- こっちの方針はkが大きいとき？（step3と比べて）

```python
import heapq
class KthLargest:
    def __init__(self, k: int, nums: List[int]):
        self.k = k
        self.nums_top_k = nums.copy()
        heapq.heapify(self.nums_top_k)
        for _ in range(len(nums) - k):
            heapq.heappop(self.nums_top_k)

    def add(self, val: int) -> int:
        if len(self.nums_top_k) == self.k:
            heapq.heappushpop(self.nums_top_k, val)
            return self.nums_top_k[0]

        heapq.heappush(self.nums_top_k, val)
        return self.nums_top_k[0]
```
- __init__()
    - 時間計算量
        - O(N + (N-k)logN)
    - 空間計算量
        - O(N)
- add()
    - 時間計算量
        - O(logk)
    - 空間計算量
        - O(1)

### step3
- addを__init__で呼ぶ書き方もある（[katatakuさん](https://github.com/katataku/leetcode/blob/7c8c51d9b82aa240bd4a4b5ed8bb657ba137baf5/703.%20Kth%20Largest%20Element%20in%20a%20Stream.md)）
    - 処理にDRY原則を適用させたということ？
- heappushpopはvalがheap[0]よりも小さい場合は、valをそのまま返す。
- しかし、関数を呼び出さないに越したことはないので、elifで弾く
- こっちはkが小さいときに良さそう

```python
import heapq
class KthLargest:
    def __init__(self, k: int, nums: List[int]):
        self.k = k
        self.nums_top_k = []
        for num in nums:
            self.add(num)

    def add(self, val: int) -> int:
        if len(self.nums_top_k) < self.k:
            heapq.heappush(self.nums_top_k, val)
        elif val > self.nums_top_k[0]:
            heapq.heappushpop(self.nums_top_k, val)

        return self.nums_top_k[0]
```
- __init__()
    - 時間計算量
        - O(Nlogk)
    - 空間計算量
        - O(k)
- add()
    - 時間計算量
        - O(logk)
    - 空間計算量
        - O(1)

### その他
直接答えを見るよりも、ドキュメントを見て、使えそうな関数に当たりをつけた後や、他の人のコードを読み良かった点・改善点・学びになる点をヒント程度にメモしておき、後でそのメモを元にコード書くほうが楽しい。
