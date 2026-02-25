# 387. First Unique Character in a String

https://leetcode.com/problems/first-unique-character-in-a-string/
### step1
- Python 3.7 から dict は順序が保存するようになったため通ったみたい
- 時間計算量
    - O(n)
- 空間計算量
    - O(n)
```python
class Solution:
    def firstUniqChar(self, s: str) -> int:
        """
        non-repeating character を見つけ、idx を返す。
        ↓
        how to detcet non-repeating character?
            should check until last char? -> brute force
            heap mapか？char_to_first_idx
        """
        if s == '':
            return -1

        char_to_first_idx = {}

        for i, char in enumerate(s):
            if char in char_to_first_idx:
                char_to_first_idx[char] = -1
                continue
            char_to_first_idx[char] = i

        for candidate in char_to_first_idx.values():
            if candidate != -1:
                return candidate

        return -1
```


### step2
- enumerate を使えば idx を管理しなくてもよかった。
    - https://github.com/shining-ai/leetcode/blob/cdc997c18316f31891084b824f3ea8e2780df5df/arai60/11-16_HashMap/15_387_First%20Unique%20Character%20in%20a%20String/level_3.py
- こちらの方がコードとしては単純だが、s を二回回すことにはなる。
- 時間計算量
    - O(n)
- 空間計算量
    - O(n)
```python
from collections import defaultdict


class Solution:
    def firstUniqChar(self, s: str) -> int:
        char_to_counts = defaultdict(int)

        for char in s:
            char_to_counts[char] += 1

        for i, char in enumerate(s):
            if char_to_counts[char] == 1:
                return i

        return -1

```
### step3
- OrderedDictを使ったワンパス解法（[odaさん](https://discord.com/channels/1084280443945353267/1201211204547383386/1211166072552816680)）
    - seen で既出を管理
    - unique に一度しか出ていない文字を挿入順で保持

- OrderedDict
    - doubly linked list + __map(dict: key -> Node) + 継承したdict（key->value）の三層構造
    - [OrderedDict.popitem(last=True)](https://docs.python.org/3/library/collections.html#collections.OrderedDict.popitem) last=False で先頭から取り出せる（FIFO order）O(1)
    - __mapがあるので、popitem(last=False)（先頭の取り出し）や move_to_end（任意キーの先頭/末尾への移動）が O(1)
- [dict.pop(key, default)](https://docs.python.org/3/library/stdtypes.html#dict.pop) 第二引数でデフォルトを設定することでKeyErrorを投げない


- 時間計算量
    - O(n)
- 空間計算量
    - O(n)
```python
from collections import OrderedDict


class Solution:
    def firstUniqChar(self, s: str) -> int:
        seen = set()
        unique = OrderedDict()

        for i, char in enumerate(s):
            if char in seen:
                unique.pop(char, None)
                continue
            unique[char] = i
            seen.add(char)

        if not unique:
            return -1

        _, first_unique_char_idx = unique.popitem(last=False)
        return first_unique_char_idx
```

### その他
OrderedDict の強い参照、弱い参照、循環参照がよく分からなくて混乱していた。結局あまり理解していない、、
