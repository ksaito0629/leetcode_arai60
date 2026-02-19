# 349. Intersection of Two Arrays

https://leetcode.com/problems/intersection-of-two-arrays/description/
### step1
- set　を使う方針
- [set.intersection](https://docs.python.org/3/library/stdtypes.html#set.intersection) が今回使えそう
- 時間計算量
    - O(n + m)
- 空間計算量
    - O(n + m)
```python
class Solution:
    def intersection(self, nums1: list[int], nums2: list[int]) -> list[int]:
        """
        2つのint arraysからintersectionをリターンする
        ↓
        intersectionを作るには？
        - setを使えば書けそう
            - 積集合を調べるだけか？
            - 計算量はどのぐらいだろう？
        - edge case
            - nums1, nums2のどちらかがNone, []
            - 被りがない
            - リストの length がかなり大きい
        """
        nums1_unique = set(nums1)
        nums2_unique = set(nums2)

        intersection = nums1_unique.intersection(nums2_unique)
        return list(intersection)
```

### step2

- pointerを使う方針（[odaさん](https://discord.com/channels/1084280443945353267/1183683738635346001/1188897668827730010)）
- NaNについて
    - NaN　は、不等号も等号も False
        - print(a == b) # False
        - print(a > b)  # False
        - print(a < b)  # False
        - print(a != b) # True

- 時間計算量
    - O(n log n + m log m)
- 空間計算量
    - O(n + m)
```python
class Solution:
    def intersection(self, nums1: list[int], nums2: list[int]) -> list[int]:
        """
        ポインタを使う。
        まず、昇順にする。
        両 arrays を先頭から順にポインタで見ていく。
        ポインタが範囲内の間
            ポインタが指す2つの値が違う間、小さい方の値のポインタを進める。
            値が一緒なら、intersection にアペンドし、同じ値のうちは進める
        """
        intersection = []
        nums1_sorted = sorted(nums1)
        nums2_sorted = sorted(nums2)
        i = 0
        j = 0
        n = len(nums1_sorted)
        m = len(nums2_sorted)

        while i < n and j < m:
            if nums1_sorted[i] < nums2_sorted[j]:
                i += 1
                continue
            if nums1_sorted[i] > nums2_sorted[j]:
                j += 1
                continue
            common_num = nums1_sorted[i]
            intersection.append(common_num)

            while i < n and nums1_sorted[i] == common_num:
                i += 1

            while j < m and nums2_sorted[j] == common_num:
                j += 1

        return intersection
```
### step3
- set の方針を工夫して空間計算量を O(min(n, m))にする（[tarinaihitoriさん](https://github.com/tarinaihitori/leetcode/pull/13/changes/fae7fb0f54e52aa1eb8ad0e81eea35c1fa4d2a48)）
- 時間計算量
    - O(n + m)
- 空間計算量
    - O(min(n, m))
```python
class Solution:
    def intersection(self, nums1: list[int], nums2: list[int]) -> list[int]:
        if not nums1 or not nums2:
            return []

        if len(nums1) > len(nums2):
            nums1, nums2 = nums2, nums1

        nums1_unique_num = set(nums1)
        intersection = []

        for num in nums2:
            if num in nums1_unique_num:
                intersection.append(num)
                nums1_unique_num.discard(num)

        return intersection
```
