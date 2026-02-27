# 560. Subarray Sum Equals K

https://leetcode.com/problems/subarray-sum-equals-k/
### step1
- 自力で解けなかったので他の方のコードを読んだ。
- prefix_sum (累積和) を使うと逐一、Subarray sum を計算しないでよいみたい。
- 時間計算量
    -  O(n ^ 2)
- 空間計算量
    - O(n)
```python
class Solution:
    def subarraySum(self, nums: list[int], k: int) -> int:
        cnt_subarray_sum_is_k = 0
        prefix_sums = [0]
        for num in nums:
            prefix_sums.append(prefix_sums[-1] + num)

        n = len(prefix_sums)
        for i in range(n):
            for j in range(i + 1, n):
                subarray_sum = prefix_sums[j] - prefix_sums[i]
                if subarray_sum == k:
                    cnt_subarray_sum_is_k += 1

        return cnt_subarray_sum_is_k
```
### step2
- cum_sumとhash map を使った方針（[odaさん](https://discord.com/channels/1084280443945353267/1195700948786491403/1253847901969580082)）
    - subarray_sum = prefix_sums[j] - prefix_sums[i]
    - 上記の累積和の差を、prefix_sums[i] = prefix_sums[j] - subarray_sum (complement = prefix_sum - k)を探す問題に変換
    - hash map で過去の prefix_sum の出現回数を記録して、complement として lookup
- 時間計算量
    - O(n)
- 空間計算量
    - O(n)

```python
class Solution:
    def subarraySum(self, nums: list[int], k: int) -> int:
        prefix_sum = 0
        cnt_subarray_sum_is_k = 0
        prefix_sum_to_cnt = {0: 1}

        for num in nums:
            prefix_sum += num
            complement = prefix_sum - k
            if complement in prefix_sum_to_cnt:
                cnt_subarray_sum_is_k += prefix_sum_to_cnt[complement]
            prefix_sum_to_cnt[prefix_sum] = prefix_sum_to_cnt.get(prefix_sum, 0) + 1

        return cnt_subarray_sum_is_k
```
### step3
- defaultdict を使うとより簡潔に書ける
    - ただ、step2の方が意図が分かりやすいかも？
- 時間計算量
    - O(n)
- 空間計算量
    - O(n)

```python
from collections import defaultdict


class Solution:
    def subarraySum(self, nums: list[int], k: int) -> int:
        prefix_sum = 0
        cnt_subarray_sum_is_k = 0
        prefix_sum_to_cnt = defaultdict(int)
        prefix_sum_to_cnt[0] = 1

        for num in nums:
            prefix_sum += num
            complement = prefix_sum - k
            cnt_subarray_sum_is_k += prefix_sum_to_cnt[complement]
            prefix_sum_to_cnt[prefix_sum] += 1

        return cnt_subarray_sum_is_k
```


