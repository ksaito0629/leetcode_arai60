# 1. Two Sum

https://leetcode.com/problems/two-sum/

### step1
- 時間計算量
    - O(N^2)
- 空間計算量
    - O(1)
```python
class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        """
        1，for を二回回すぐらいしか思いつかないな。
        2，
        """
        for i in range(len(nums)):
            if target - nums[i] not in nums:
                    continue
            for j in range(len(nums)):
                if i == j:
                    continue
                if target - nums[i] == nums[j]:
                    return [i, j]

        return []

```
### Step2
- Step 1. のコードを整えた
- ペアが見つからない場合、errorを投げる([takumiharaさん](https://github.com/takumihara/leetcode/blob/3f122c2d68019f3f302f8681cf7db31de4a24b44/two-sum.md))
    - [組み込み例外](https://docs.python.org/3/library/exceptions.html)
        - tryでエラーが起きる -> 例外インスタンスを投げる
        - exceptで isinstanceチェック -> Trueなら処理
        - その他
            - raiseでPythonが検知しないエラーを捕まえる
            - 主なエラー
            - TypeError, ValueError, KeyError / IndexError, AttributeError, NameError, UnboundLocalError
- 時間計算量
    - O(N^2)
- 空間計算量
    - O(1)

```python
class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        for i in range(len(nums) - 1):
            for j in range(i + 1, len(nums)):
                complement = target - nums[i]
                if complement == nums[j]:
                    return [i, j]

        raise ValueError("There isn't a pair of values that add up to target. ")
```
- 手作業でやるならどうするか？考える（[odaさん](https://discord.com/channels/1084280443945353267/1183683738635346001/1187326805015810089)）
    - コーディングは、手作業でもできるが、自動化したいときにするもの
    - そのため、手作業ではやらないやり方なら、コーディングでもやらないほうがよいかも。
- ifの中のほうに異常なもの。特にreturnでは。（[odaさん](https://discord.com/channels/1084280443945353267/1201211204547383386/1207251531041210408)）
    - ガード節で異常系を先に弾く書き方もあるな。
- 以下の方針は、元のインデックスを参照する処理が必要みたい。
```python
class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        """
        ソートして、一番左と一番右を見る。
        targetと比べ、
        小さいなら大きく（左のidxを内側に）
        大きいなら小さく（右のidxを内側に）
        idx の大小関係が同じうちはずっと。
        """
        nums_sorted = sorted(nums)

        left = 0
        right = len(nums_sorted) - 1

        while left < right:
            candidate = nums_sorted[left] + nums_sorted[right]
            if target < candidate:
                right -= 1
                continue
            if target > candidate:
                left += 1
                continue

            return [left, right]

        return []
```
### Step3
- 時間計算量
    - O(N)
- 空間計算量
    - O(N)
```python
class Solution:
    def twoSum(self, nums: list[int], target: int) -> list[int]:
        """
        use hash map.
        """
        seen = {}

        for i, num in enumerate(nums):
            complement = target - num
            if complement in seen:
                return [seen[complement], i]
            seen[num] = i

        return []
```
- 辞書の命名は、a_to_bがいいかも（[shining-aiさん](https://github.com/shining-ai/leetcode/blob/a289438eed4c8f5ea5af4cb40cb88706b7bd7415/arai60/11-16_HashMap/11_01_TwoSum/level_3.py)）

## その他
あんまり復習していないが、コードレビューでメンションされたときに解き直しをしようかな。それか、週一で解き直しの日を作るか。
