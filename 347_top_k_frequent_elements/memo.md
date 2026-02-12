# 347. Top K Frequent Elements

https://leetcode.com/problems/top-k-frequent-elements/

### step1
- 最初に思いついた方針がリストのidxに各numのfrequencyを記録する、だった。
- この方針でとりあえずコードを書き始めたからか、辞書は知っていたのに思いつけなかった。
- だいぶよくないことだと思うので、他の選択肢を考えるクセを付けたい。
- ※下のコードは動きません。
```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        '''
        リストの位置で管理する？
        numsのMaxの大きさのリストを作成
        ー＞負の場合はどうしよう
        '''
        num_max = max(nums)
        num_min = min(nums)

        freq_count_list = [0] * max(nums)
        if num_min < 0:
            freq_count_list_negative = [0] * -(min(nums))
            for i in nums:
                if i < 0:
                    freq_count_list_negative[-i] += 1
                else:
                    freq_count_list[i] += 1
        else:
            for i in nums:
                freq_count_list[i] += 1
```
### step2
- 辞書を使って解いた
    - 辞書の命名はnum_to_freqとした（[quinn-sashaさん](https://github.com/fuga-98/arai60/pull/10#discussion_r1967068452)）
- sortedは
    - 辞書に対して行うとキーが並ぶ（[odaさん](https://github.com/fuga-98/arai60/pull/10#discussion_r1967068452)）
- 時間計算量
    - O(NlogN)
- 空間計算量
    - O(N)
```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        num_to_freq = {}

        for i in nums:
            if num_to_freq.get(i) is None:
                num_to_freq[i] = 1
            else:
                num_to_freq[i] += 1

        num_to_freq_sorted = sorted(
            num_to_freq,
            key=num_to_freq.get,
            reverse=True
            )
        return num_to_freq_sorted[:k]
```
- [sorted](https://docs.python.org/3/howto/sorting.html)の挙動を調べた
    - 常にリストを返す
        - dict -> キーでソート
        - Counter -> キーでソート
    - Key Functions
        - a function or other callable
        - .get -> 関数そのもの
        - .get() -> 関数を呼び出した結果
    - sort stability
        - 同じキーの要素は元の順序が保たれる
- 時間計算量
    - O(NlogN)
- 空間計算量
    - O(N)
```python
import collections
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        num_to_freq = defaultdict(int)

        for i in nums:
            num_to_freq[i] += 1

        num_to_freq_sorted = sorted(num_to_freq, key=num_to_freq.get, reverse=True)
        return num_to_freq_sorted[:k]
```

- [Counter](https://docs.python.org/3/library/collections.html#collections.Counter)を使って解いた
    - Counterはdict subclass
        - 存在しないキー -> 0を返す（dictには追加しない）
    - 普通のdictは
        - 存在しないキー -> KeyError
        - 回避策： .get(i, 0)など
    - defaultdict(int)
        - 存在しないキー -> 0を＋dictに追加
- [heapqのnlargest](https://github.com/python/cpython/blob/main/Lib/heapq.py)もこの問題で使える
  - when n>=size -> sortedの方が速い(nlargestの内部でそうなっているので気にしなくてよい？)
  -
- 時間計算量
    - O(Nlogk)
- 空間計算量
    - O(N)
```python
import heapq
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        count = Counter(nums)
        return heapq.nlargest(k, count.keys(), key=count.get)
```

### step3
- bucketsを使った解法。([portrueさん](https://github.com/potrue/leetcode/pull/9/changes/af64ab5ec896e6339c3276b709a6dc6250d59681#diff-dce85bf5bc3acb0f755f06a75043875e90f52eadc5e761421acc856335cfec86R31))
- 時間計算量
    - O(N)
- 空間計算量
    - O(N)

```python
class Solution:
    def topKFrequent(self, nums: List[int], k: int) -> List[int]:
        num_to_freq = {}

        for num in nums:
            num_to_freq[num] = num_to_freq.get(num, 0) + 1

        nums_by_freq = [[] for _ in range(len(nums) + 1)]

        for num, freq in num_to_freq.items():
            nums_by_freq[freq].append(num)

        nums_top_k_freq = []
        for i in range(len(nums_by_freq) - 1, 0, -1):
            for num in nums_by_freq[i]:
                if len(nums_top_k_freq) >= k:
                    return nums_top_k_freq
                nums_top_k_freq.append(num)

        return nums_top_k_freq
```

## その他
一日一問ペースでやっていきたいが、なかなか難しい。
