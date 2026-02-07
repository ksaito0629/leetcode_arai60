# 206. Reverse Linked List

https://leetcode.com/problems/reverse-linked-list/

## Comments

### step1
- 今回も一つだけ方針が立ったので書いてみる。素直に、前から順にポインタを付け替える。
```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        """
        ポインタを付け替える方針で
        ちょっと命名がややこしくなりそう。
        prev, current, next=temp
        """

        current = head
        prev = None

        while current is not None:
            temp = current.next
            current.next = prev
            prev = current
            current = temp

        return prev
```
- 計算量
    - 時間
        - O(N)
    - 空間
        - O(1)

### step2
### 2_1.  他の人のコードを読む
- [再帰の組み立て方](https://discord.com/channels/1084280443945353267/1231966485610758196/1239417493211320382)
    -  上司と部下に何を伝えたら、なにを渡せばよいか
- [tarinaihitoriさん](https://github.com/tarinaihitori/leetcode/blob/7ae6c941f485e4fd52fab64cf17584150ea87d03/206.%20Reverse%20Linked%20List.md)
    - previous必要かな？
        - いるか。previousがあると、ポインタの付替えが楽。どうも毎回、head.next = Noneにするのがしっくりこないので。最初に、head.next = Noneとしておくと、ループによるエラーを防げる。
    - 再帰のrecursionError
    - reversed_headっていう命名分かりやすい
    - 気になったコメント
        - 変数の付け方。上記と同じく、なにを伝えたら作業をすんなり引き継げるか
        - 番兵ノード＋Stack
- [t0hsumiさん](https://github.com/t0hsumi/leetcode/pull/7#discussion_r1875385145)
    - stack = [None]　は初めて見た
    - stack.pop()を変数に入れて渡したらよさそう
    - tailってどうなんだろう？最終的に、reverse_headになるからなあ
    - 気になったコメント
        - 変数名の付け方。作業ではなく、意味の方が今回は分かりやすい
- [TORUS0818さん](https://github.com/TORUS0818/leetcode/blob/c0666cb9fa566ded60bbcebce2d1667f238c5ddf/easy/206/answer.md)
    - reverse_headで.nextを付け替えたものを表現
    - 気になったコメント
        - 冗長でもよいので、node(現在見ているNode)とreverse_nodeを混ぜないようにする。

###　2_2.　再帰で解いてみる。
1，終了条件を考える。
2，自分は何をするのか、後続に何を引き継ぎすればよいかを考える。
3，最後に何を返すのか考える。

```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if head is None or head.next is None:
            return head

        node_next = head.next
        head.next = None

        head_reversed = self.reverseList(node_next)

        node_next.next = head

        return head_reversed
```
- 時間計算量
    - O(N)
- 空間計算量
    - O(N)

### step3
再帰、苦手なので他の書き方でも書いてみる。

```python
class Solution:
    def reverseList(self, head: Optional[ListNode]) -> Optional[ListNode]:
        if head is None or head.next is None:
            return head

        head_reversed = self.reverseList(head.next)

        head.next.next = head
        head.next = None

        return head_reversed
```
### その他：
前々回、PRまで時間がかかった経験から、コメント集のこの問題のセクションのみ読もうと思ったが、コメント集が結構多いな、、という気持ちになった。これを全て読むまでPRしないというよりかは,知らないことを3-5個知れたとか、疑問をいくついくつ解消できたを目標にしたい。知りたいと思ったことを優先で調べていこうかなと思う。
