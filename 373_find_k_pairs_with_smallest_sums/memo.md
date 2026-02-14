# 373. Find K Pairs with Smallest Sums

https://leetcode.com/problems/find-k-pairs-with-smallest-sums/

### step1
- sorted を使う方針と nsmallest を使う方針を思いついた
- nsmallest の方が時間計算量は少ないと思ったが、ボトルネックは全然そこではなかった。
```python
import heapq


class Solution:
    def kSmallestPairs(self, nums1: List[int], nums2: List[int], k: int) -> List[List[int]]:
        """
        1，リストの要素の合計、pairを辞書にしてsorted
            -> O(M*N) + O(M*NlogM*N)
        2，nsmallestを使う
            -> O(M*N) + O(M*Nlogk)
        2を選択
        """
        if nums1 is None or nums2 is None:
            return []

        pairs = []

        for num1 in nums1:
            for num2 in nums2:
                pairs.append([num1, num2])

        return heapq.nsmallest(k, pairs, key=itemgetter(0, 1))
```
### step2
- step1を修正
    - keyは要素の合計にする
    - ガード節を追加
```python
import heapq


class Solution:
    def kSmallestPairs(self, nums1: List[int], nums2: List[int], k: int) -> List[List[int]]:
        if not nums1 or not nums2 or k == 0:
            return []

        pairs = []

        for num1 in nums1:
            for num2 in nums2:
                pairs.append([num1, num2])

        return heapq.nsmallest(k, pairs, key=lambda x: x[0] + x[1])
```
- 上はM*Nを入れるのがかなりボトルネック
- heap、setを使って、まだ入れていないもの、入っているもの、出たものを管理
    - https://discord.com/channels/1084280443945353267/1200089668901937312/1222573940610695341

- 時間計算量
    - O(k log k)
- 空間計算量
    - O(k)

```py
import heapq


class Solution:
    def kSmallestPairs(self, nums1: List[int], nums2: List[int], k: int) -> List[List[int]]:
        k_smallest_pairs = []
        heap = []
        seen = set()

        def push_ready_neighbors(x, y):
                if x < len(nums1) and y < len(nums2) and (x, y) not in seen:
                    heapq.heappush(heap, (nums1[x] + nums2[y], x, y))
                    seen.add((x, y))

        push_ready_neighbors(0, 0)

        while len(k_smallest_pairs) < k:
            _, i, j = heapq.heappop(heap)
            k_smallest_pairs.append((nums1[i], nums2[j]))

            push_ready_neighbors(i + 1, j)
            push_ready_neighbors(i, j + 1)

        return k_smallest_pairs
```
### step3
- popで取り出したインデックス (i, j) の右隣 (i, j + 1) or 下隣 (i + 1, j)は push してよいか？を判定するために、next_i/j を用いる。([odaさん](https://github.com/TORUS0818/leetcode/pull/12#discussion_r1703795314))
    - next_i[j]: j列目で pop された行の数を表す縦方向カウンタ。行なので横に伸びている
    - 右隣 (i, j+1) の push 判定に使う。
        - (i, j+1) を push してよいのは、左 (i, j) が pop 済みかつ、上 (i-1, j+1) が pop 済みのとき。
            - next_i[j+1] は (0,j+1),(1,j+1),...と pop されるたびにインクリメントされるので、
            - next_i[j+1] == i は (0,j+1)〜(i-1,j+1) が全て pop 済みであることを意味する。
            - 左 (i, j) は今まさに取り出したので、チェック不要。
- 時間計算量
    - O(k log k)
- 空間計算量
    - O(max(k, M + N))
```py
import heapq


class Solution:
    def kSmallestPairs(self, nums1: list[int], nums2: list[int], k: int) -> list[list[int]]:
        if not nums1 or not nums2 or k <= 0:
            return []

        k_smallest_pairs = []
        heap = []

        next_i = [0] * len(nums2)
        next_j = [0] * len(nums1)

        def push_ready_neighbors(i, j):
            if j + 1 < len(nums2) and next_i[j + 1] == i:
                heapq.heappush(heap, (nums1[i] + nums2[j + 1], i, j + 1))
            if i + 1 < len(nums1) and next_j[i + 1] == j:
                heapq.heappush(heap, (nums1[i + 1] + nums2[j], i + 1, j))

        heapq.heappush(heap, (nums1[0] + nums2[0], 0, 0))

        while heap and len(k_smallest_pairs) < k:
            _, i, j = heapq.heappop(heap)
            k_smallest_pairs.append([nums1[i], nums2[j]])
            next_i[j] += 1
            next_j[i] += 1
            push_ready_neighbors(i, j)

        return k_smallest_pairs
```
### その他
next_i/j を使う方針での push の管理の仕方を理解するのにかなり時間がかかった。
デバッガ動かしてみたり、コメント集を漁ってみたり、claudeに聞いてみたり。そうやって、いろんなことを考え悩んだせいか、理解でき、頭の中でコードを書けるようになったときは本当に嬉しかった。
