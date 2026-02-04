# Add Two Numbers

https://leetcode.com/problems/add-two-numbers/

## Comments

### step1

- 初見で思いついた方針が、
    - Nodeのvalをl1,l2でそれぞれ順にlistに入れていく
    - listの順番をreverseして、和を取る
    - 和をstrにして、逆順にNodeを作成していく。
- のみだったのでそのままコードにして10分ほどでAC。
- -> step2でコードを整えた。

```python
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:

        vals1 = []
        vals2 = []

        while l1:
            vals1.append(str(l1.val))
            l1 = l1.next

        while l2:
            vals2.append(str(l2.val))
            l2 = l2.next

        total = int("".join(reversed(vals1))) + int("".join(reversed(vals2)))

        dummy_node = ListNode()
        node = dummy_node

        for char in reversed(str(total)):
            node.next = ListNode(int(char))
            node = node.next

        return dummy_node.next
```
- 時間計算量
    - O(max(N, M))
- 空間計算量
    - O(max(N, M))

### step2

- step1のコードを整えた
    - 重複する処理を関数化
    - 命名変更（char -> digit）
- 他の解法を調べた
- 他の人のコードを読んでみた
```python
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:

        vals1 = []
        vals2 = []

        def node_to_int(node):
            vals = []
            while node:
                vals.append(str(node.val))
                node = node.next

            return int("".join(reversed(vals)))

        total = node_to_int(l1) + node_to_int(l2)

        dummy_node = ListNode()
        node = dummy_node

        for digit in reversed(str(total)):
            node.next = ListNode(int(digit))
            node = node.next

        return dummy_node.next
```

- 方針2：繰り上がりを用いて筆算のように新しいNodeを作成していく。
```python
class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:

        dummy_node = ListNode()
        node = dummy_node
        carry = 0

        while l1 or l2 or carry:
            val1 = l1.val if l1 else 0
            val2 = l2.val if l2 else 0

            total = val1 + val2 + carry
            carry = total // 10
            val = total % 10

            node.next = ListNode(val)
            node = node.next

            if l1: l1 = l1.next
            if l2: l2 = l2.next

        return dummy_node.next
```
- 時間計算量
    - O(max(N, M))
        - 長い方のリストの長さ分
- 空間計算量
    - O(max(N, M))

- 他の人のコード
    - [Satorienさん](https://github.com/Satorien/LeetCode/pull/3/changes/1d67d893d8dce0d1e80ffb3284266488c7f48e78#diff-65d9d9b271ca6c38874e7f71753f62f010b5757d23c65441ec9b48cd07b2bc85R1-R22)
        - retはreturnの略？
        - なるほど、l1に足していくのか。
        - 繰り上がりは-10をして、.nextに＋1と。
        - 気になったコメント
            - 計算量、コードの可読性も踏まえた上でのメリット、デメリット
            - timeit
    - [Fuminitonさん](https://github.com/Fuminiton/LeetCode/pull/5/changes/5f98fc9003da211730c25597f0a4a35294210d1b)
        - get_next, get_valと関数化してしまう方法もあるんだ
        - 気になったコメント
            - 異常を先にはねる
    - [yus_yusさん](https://github.com/yus-yus/leetcode/blob/91f344d110d2dc8ce7982065314a25afec963cc9/2.Add_Two_Numbers.md)
        - 合計の処理をl1.valの時点でしている
        - また、合計の処理とポインターの移動を同時に
        - dummyを使わない実装
        - 気になったコメント
            - 番兵を使って常に、.valを取れるようにする

### step3

- step2の2つ目のコードのif文をまとめる
 ```python
 class Solution:
    def addTwoNumbers(self, l1: Optional[ListNode], l2: Optional[ListNode]) -> Optional[ListNode]:

        dummy_node = ListNode()
        node = dummy_node
        carry = 0

        while l1 or l2 or carry:
            if not l1:
                val1 = 0
            else:
                val1 = l1.val
                l1 = l1.next

            if not l2:
                val2 = 0
            else:
                val2 = l2.val
                l2 = l2.next

            total = val1 + val2 + carry
            carry = total // 10
            val = total % 10

            node.next = ListNode(val)
            node = node.next

        return dummy_node.next
```

###　その他
- [コメント集](https://docs.google.com/document/d/11HV35ADPo9QxJOpJQ24FcZvtvioli770WWdZZDaLOfg/edit?tab=t.0)、Discord、他の人のコードを漁っていると、気になることがどんどん出てきて、一問（Add two numbers）解いてPRするまでに数日かかってしまった。ただ、ピンとこないことも割とあって（ワーキングメモリを解放するとか）、その辺りはコードを読み書きする量が増えるにつれて分かってくるのかなと思う。
