# 20. Valid Parentheses

https://leetcode.com/problems/valid-parentheses/

## Comments

### step1

- Open bracketが必ず先に来ることは前提？
- flag_（round, curly, square）を立て、それぞれopenが来たら＋1、closeが来たら-1. それぞれの合計が0ならTrue
    - -> open bracketが互い違いのケースに対応できない（例："([)]"）
```python
class Solution:
    def isValid(self, s: str) -> bool:
        flag_round = 0
        flag_curly = 0
        flag_square = 0

        for bracket in s:
            if bracket == '(':
                flag_round += 1
            elif bracket == ')':
                flag_round += -1
            elif bracket == '{':
                flag_curly += 1
            elif bracket == '}':
                flag_curly += -1
            elif bracket == '[':
                flag_square += 1
            else:
                flag_square += -1

        if flag_round == 0 and flag_curly == 0 and flag_square == 0:
            return True
        else:
            return False
```

- わからなかったため[コメント集](https://docs.google.com/document/d/11HV35ADPo9QxJOpJQ24FcZvtvioli770WWdZZDaLOfg/edit?tab=t.0)を確認
    - [bumbuboonさん](https://github.com/bumbuboon/Leetcode/blob/c6cff71506276178127832bc17951365a5ca482a/validParentheses.md)
     - 初見はほぼ同じ方針
        - bracketsと辞書でまとめていた
        - closeが先に来るときの対処もしている
        - allで、すべてTrueの判定
     - [stack data structureを用いた方針](https://leetcode.com/problems/valid-parentheses/solutions/3399077/easy-solutions-in-java-python-and-c-look-at-once-with-exaplanation/)
        - listのappendとpopを使う。（先入れ後出し）
        - pairsとして辞書(close: open)で書くとスッキリ
    - [kandaさん](https://discord.com/channels/1084280443945353267/1201211204547383386/1202748702968782869)
        - pairs(open: close)　こっちのほうが見やすい感じ？
    - [konnyshさん](https://github.com/konnysh/arai60/pull/6/changes/76c6a2ddc45cd661d2f5a41f8326aa0667ae433f)
        - 気になったコメント
            - openが来た時点でcontinue
            - 一文字変数もすぐに忘れて良いものなら採用可
            - open, closeの処理をそれぞれ関数化
    - [yus-yusさん](https://github.com/yus-yus/leetcode/blob/1b3e49a7f5e9ba12caf831de9d2fd958c8e83e66/20.Valid_Parentheses.md)
        - deque()を使ってもかける
            - 今回はlist, dequeでも末尾へのアクセスはO(1)
            - 逆に、先頭のアクセスはそれぞれ、O(n), O(1)
            - Cpythonをちょっとのぞいてみる
                - dequeは双方向リスト（doubly-linked list）だから、Nodeのポインタを変えるだけ
                - Cは基本的に住所を変数にしている？
                - 左端と右端の住所だけ知っているから中間とかへのアクセスは遅い。
        - 気になったコメント
            - 副作用のある式
                - 条件式で同時に、stackの中身が変わること？

### step2
### 2_1.  正解を見てみる
[上記のstack data structureを用いた方針](https://leetcode.com/problems/valid-parentheses/solutions/3399077/easy-solutions-in-java-python-and-c-look-at-once-with-exaplanation/)
```python
class Solution:
    def isValid(self, s: str) -> bool:
        stack = []
        for c in s:
            if c in '({[':
                stack.append(c)
            else:
                if not stack or (c == ')' and stack[-1] != '(') or (c == '}' and stack[-1] != '{') or (c == ']' and stack[-1] != '['):
                    return False
                stack.pop()
        return not stack
```
- 時間計算量
    - O(N)
        - sの長さ
- 空間計算量
    - O(M)
        - open bracketsの長さ

- open_to_closeで辞書を作成してみる。
- 途中でbracket以外の文字が来たときの対応をelifで。open -> othe char -> close
```python
class Solution:
    def isValid(self, s: str) -> bool:
        open_to_close = {'(': ')', '{': '}', '[': ']'}
        close_brackets = set(open_to_close.values())
        stack = []

        for bracket in s:
            if bracket in open_to_close:
                stack.append(bracket)
                continue
            elif not stack:
                return False
            elif bracket not in close_brackets:
                continue
            else:
                if bracket != open_to_close[stack[-1]]:
                    return False
            stack.pop()

        return not stack
```

### step3

- open -> close -> other charの順に
```python
class Solution:
    def isValid(self, s: str) -> bool:
        open_to_close = {'(': ')', '{': '}', '[': ']'}
        close_brackets = set(open_to_close.values())
        stack = []

        for bracket in s:
            if bracket in open_to_close:
                stack.append(bracket)
                continue
            elif not stack:
                return False
            elif bracket in close_brackets:
                if bracket != open_to_close[stack[-1]]:
                    return False
            else:
                continue
            stack.pop()

        return not stack
```
### その他
今回は、コメント集の本問に関する言及のみ目を通した。3時間程度でStep3まで終わったので、Cpython（dequeを見るために）を少しのぞいてみた。大分、長いファイルだったが、LLMに必要な箇所のみを解説してもらったので大して時間はかからなかった。
