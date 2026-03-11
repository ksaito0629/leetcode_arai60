# 98. Validate Binary Search

https://leetcode.com/problems/validate-binary-search-tree/
### step1
- 自力で解いたみたが、親だけでなく自分より左にある node.val はすべて制限を満たすことを知らなかったため解けなかった。
- 他の方の解答を見た
    - https://github.com/fhiyo/leetcode/blob/052994b11f3e92a38b3636466d3eb4c5fe04a77b/98_validate-binary-search-tree.md
- 時間計算量
    - O(N)
- 空間計算量
    - O(H)
        - 木の高さ。最悪ケースでO(N)
- For the base cases,
    - if the node is null, return True
    - if the node's val is out of range, return False
- Otherwise, recurse on the left child with the upper bound updated to the current val, and vice versa.
```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        def fall_within_range(node, lower, upper):
            if not node:
                return True
            if not (lower < node.val < upper):
                return False
            return (fall_within_range(node.left, lower, node.val) and
                    fall_within_range(node.right, node.val, upper))
        return fall_within_range(root, float('-inf'), float('inf'))
```
### step2
### step2.1
- Key insight is that an in-order traversal of a BST produces values in strictly increasing order
- in-order
    - 親が真ん中に来る
    - 左の子ー＞親ー＞右の子
    - BST だと小さい順に並ぶ
- 時間計算量
    - O(N)
- 空間計算量
    - O(H)
```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        self.prev_val = float('-inf')
        def traverse_tree(node) -> bool:
            if not node:
                return True
            if not traverse_tree(node.left):
                return False
            if node.val <= self.prev_val:
                return False
            self.prev_val = node.val
            return traverse_tree(node.right)
        return traverse_tree(root)
```
### step2.2
- yieldを使った方針
    - https://discord.com/channels/1084280443945353267/1192736784354918470/1235116690661179465
    - https://github.com/YukiMichishita/LeetCode/pull/8/changes#diff-4715b26790b92230b162cee20ac77591864a09b081158d7e9d0def2dc4ce5dc7R40-R81
- yield from inorder_sort(node.left) ==
```python
for node in inorder_sort(node.left):
    yield node
```
- 時間計算量
    - O(N)
- 空間計算量
    - O(H)
```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        def inorder_sort(node):
            if not node:
                return
            yield from inorder_sort(node.left)
            yield node
            yield from inorder_sort(node.right)

        prev_val = float('-inf')
        for node in inorder_sort(root):
            if node.val <= prev_val:
                return False
            prev_val = node.val
        return True
```
### step3
- iterative DFS
    - queue にするとBFS
- recursion -> iterative　は、call stack で積んでいたものを、明示的にスタックに入れるイメージ
- 時間計算量
    - O(N)
- 空間計算量
    - O(H)
```python
class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        node_range_pairs = [(root, float('-inf'), float('inf'))]
        while node_range_pairs:
            node, lower, upper = node_range_pairs.pop()
            if not node:
                continue
            if not (lower < node.val < upper):
                return False
            node_range_pairs.append((node.left, lower, node.val))
            node_range_pairs.append((node.right, node.val, upper))
        return True
```

###　その他
- 急に英語を勉強したい気分になったのでちょっとずつ英語の割合を増やしたい。まずは、方針を英語にしてみようと思う
