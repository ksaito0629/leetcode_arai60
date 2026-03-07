# 127. Word Ladder

https://leetcode.com/problems/word-ladder/
### step1
- 自力で解いてみた。BFSを書いたが、distance の記録仕方がわからず、他の方のコードを見た。
- 以下は、単語数が多いと Time Limit Exceed
    - 隣接リスト構築が O（N^2 * k）
- 時間計算量
    - O(N^2 * k)
- 空間計算量
    - O(N^2 + N*k)
```python
from collections import defaultdict
from collections import deque



class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: list[str]) -> int:
        """
        wordlistの中から、直前の単語と一文字違いの単語を許容し選択できる。
        beginwordから始まり、endword になる最短のルートを求めたい

        これは絶対に、endwordにできるのか？
        全ての単語は同じ文字数なのか？
        英語の小文字限定？

        最短だから、BFSっぽいなあ。
        一文字違い（現時点の単語から選べる単語）はどうやって選ぶんだろう？？
        辞書で管理するのか？
        """
        word_to_next_words = defaultdict(list)
        visited = set()
        n = len(beginWord)

        for word1 in wordList + [beginWord]:
            for word2 in wordList:
                if word1 == word2:
                    continue
                num_common_chars = 0
                for i in range(n):
                    if word1[i] == word2[i]:
                        num_common_chars += 1
                if num_common_chars == n - 1:
                    word_to_next_words[word1].append(word2)

        def find_shortest_path(start) -> int:
            distance = 1
            frontier = deque([(start, distance)])

            while frontier:
                word, distance = frontier.popleft()
                if word == endWord:
                    return distance
                for next_word in word_to_next_words[word]:
                    if next_word in visited:
                        continue
                    frontier.append((next_word, distance + 1))
                    visited.add((next_word))

            return 0

        return find_shortest_path(beginWord)
```
-　ハマったエラー。list.append()を代入するとNoneが返ってくる

### step2
#### step2.1 BFS + wild card
- ワイルドカードで一文字違いのキーを表現
- 時間計算量
    - O(N * k^2)
- 空間計算量
    - O(N * k^2)

```python
from collections import defaultdict
from collections import deque



class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: list[str]) -> int:
        pattern_to_words = defaultdict(list)
        n = len(beginWord)

        for word in wordList + [beginWord]:
            for i in range(n):
                pattern = f"{word[:i]}*{word[i + 1:]}"
                pattern_to_words[pattern].append(word)

        def find_shortest_path(start) -> int:
            distance = 1
            frontier = deque([(start, distance)])
            visited = {start}

            while frontier:
                word, distance = frontier.popleft()
                for i in range(n):
                    pattern = f"{word[:i]}*{word[i + 1:]}"
                    for next_word in pattern_to_words[pattern]:
                        if next_word in visited:
                            continue
                        if next_word == endWord:
                            return distance + 1
                        frontier.append((next_word, distance + 1))
                        visited.add(next_word)
            return 0

        return find_shortest_path(beginWord)
```
#### step2.2 manage distance by level
- level ごとに、distance を更新
- 時間計算量
    - O(N * k^2)
- 空間計算量
    - O(N * k^2)
```python
        def find_shortest_path_distance(start):
            distance = 1
            frontier = deque([start])
            visited.add(start)

            while frontier:
                level_size = len(frontier)
                for _ in range(level_size):
                    word = frontier.popleft()
                    if word == endWord:
                        return distance
                    for i in range(n):
                        pattern = f"{word[:i]}*{word[i + 1:]}"
                        for next_word in pattern_to_words[pattern]:
                            if next_word in visited:
                                continue
                            visited.add(next_word)
                            frontier.append(next_word)
                distance += 1
            return 0
        return find_shortest_path_distance(beginWord)
```
### 2.3 Bidirectional BFS
-　双方向BFS
- メインアイデア
    - begin and end Word から進める範囲（フロンティア）を1レベルずつ広げ、フロンティアが交わる（＝パスが繋がる）まで。
    - BFS なので、最初に見つかったところが最短。
- begin, end のどちらかの進められる範囲がすべて探索済みまで調べる。
- 探索範囲は最小にしたいので、常にフロンティアは小さい方を。
    - -> swap
- もう片方のフロンティアに、next_word が入れば、パスが繋がったことを表す。
- 時間計算量
    - O(N * k^2)
- 空間計算量
    - O(N * k^2)
```python
frontier_begin = {beginWord}
frontier_end = {endWord}
visited = {beginWord, endWord}
distance = 1

while frontier_begin and frontier_end:
    if len(frontier_begin) > len(frontier_end):
        frontier_begin, frontier_end = frontier_end, frontier_begin

    next_frontier = set()
    for word in frontier_begin:
        for i in range(n):
            pattern = f"{word[:i]}*{word[i + 1:]}"
            for next_word in pattern_to_words[pattern]:
                if next_word in frontier_end:
                    return distance + 1
                if next_word in visited:
                    continue
                visited.add(next_word)
                next_frontier.add(next_word)

    frontier_begin = next_frontier
    distance += 1

return 0
```
- ↑で詰まったバグ
- early return のつもりで以下のように書くと、frontier_begin が進んでよい方向か？のチェックだけでなく、frontier_endではもうチェック済みか？まで弾いてしまう。
    - -> 前者だけチェックしたい。
```python
for next_word in pattern_to_words[pattern]:
    if next_word in visited:
        continue
    if next_word in frontier_end:
        return distance + 1
    visited.add(next_word)
    next_frontier.add(next_word)
```
### 2.4 bucket-splitting with recursion
- 一文字違いの隣接リストを構築する方法
    - https://cs.stackexchange.com/questions/93467/data-structure-or-algorithm-for-quickly-finding-differences-between-strings
- メインアイデア
    - 前半一致でグルーピング -> 後半で再帰、後半一致でグルーピング -> 後半で再帰
    - ベースケース
        - 1文字まで調べる範囲が減ったら、そこまではすべて一致したということ。
        - 最後の1文字が異なれば、一文字違い
    - {前半パート: group}
        -          ↓
        -        {後半パートの前半パート: sub_group}
- 時間計算量
    - O(N * k * logk + N^2)
        - 最悪の場合は各単語が N-1 個の一文字違いを持つ
        - 平均だと、O(N * k * logk)
- 空間計算量
    - O(N^2 * k)
```python
from collections import defaultdict
from collections import deque


def build_one_diff_map(words: list) -> dict[str, set]:
    current_to_next = defaultdict(set)
    def find_pairs_in_range(group, start, end) -> None:
        if len(group) < 2:
            return None

        if end - start == 1:
            for i in range(len(group)):
                for j in range(i + 1, len(group)):
                    if group[i][start] != group[j][start]:
                        current_to_next[group[i]].add(group[j])
                        current_to_next[group[j]].add(group[i])
            return None

        mid = (start + end) // 2

        first_half_to_words = defaultdict(list)
        for word in group:
            first_half_to_words[word[start: mid]].append(word)
        for sub_group in first_half_to_words.values():
            find_pairs_in_range(sub_group, mid, end)

        second_half_to_words = defaultdict(list)
        for word in group:
            second_half_to_words[word[mid: end]].append(word)
        for sub_group in second_half_to_words.values():
            find_pairs_in_range(sub_group, start, mid)

        return None

    find_pairs_in_range(words, 0, len(words[0]))
    return current_to_next

class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: list[str]) -> int:
        if endWord not in wordList:
            return 0

        current_to_next = build_one_diff_map([beginWord] + wordList)
        frontier = deque([beginWord])
        visited = {beginWord}
        distance = 1

        while frontier:
            for _ in range(len(frontier)):
                word = frontier.popleft()
                for next_word in current_to_next[word]:
                    if next_word in visited:
                        continue
                    if next_word == endWord:
                        return distance + 1
                    frontier.append(next_word)
                    visited.add(next_word)
            distance += 1
        return 0
```
- 隣接リスト構築の前半パート・後半パートで同じような処理をしていたため、以下のようにまとめたが,,分かりづらい気もする。そのまま書いておいたほうがいいかも。
```python
for key_range, another_half_range in [
    ((start, mid), (mid, end)),
    ((mid, end), (start, mid))
]:
    half_to_words = defaultdict(list)
    for word in group:
        half_to_words[word[key_range[0]: key_range[1]]].append(word)
    for sub_group in half_to_words.values():
        find_pairs_in_range(sub_group, another_half_range[0], another_half_range[1])
```
- wild cardは1文字違いのときによさそう。
    - C(k, 2) で k^2, C(k, 3) で k^3 と、wild card　が一つ増えると k 倍される。
    - 1文字違い：O(n * k^2) 2文字違い：O(n * k^3) 3文字違い：O(n * k^4)
- bucket-splitting with recursion は複数文字違いのときに有効そうであるが、その実装方法については理解できていない。
    - 1文字違い：O(logn * n * k)　2文字違い：O(logk * n * k^2)　3文字違い：??
### step3
- yieldを使う。Neighbors 構築をクラスとして切り出す
    - yield 初めて書くので書き慣れない感じがすごい。
    - インスタンス名を pattern_to_words としたが、辞書と間違えそう。（ほぼ辞書だけど）
    - https://discord.com/channels/1084280443945353267/1303605021597761649/1306631474065309728
- 時間計算量
    - O(N * k^2)
- 空間計算量
    - O(N * k^2)
```python
from collections import defaultdict


class WordNeighbors:
    """
    make pattern to words using yield
    """
    def __init__(self):
        self.pattern_to_words = defaultdict(list)

    def to_pattern(self, word):
        for i in range(len(word)):
            yield f"{word[:i]}*{word[i + 1:]}"

    def add(self, word):
        for pattern in self.to_pattern(word):
            self.pattern_to_words[pattern].append(word)

    def get_neighbors(self, word):
        for pattern in self.to_pattern(word):
            for w in self.pattern_to_words[pattern]:
                yield w

class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: list[str]) -> int:
        if endWord not in wordList:
            return 0
        pattern_to_words = WordNeighbors()
        for word in wordList:
            pattern_to_words.add(word)

        words = [beginWord]
        seen = {beginWord}
        level = 1
        while words:
            next_words = []
            for word in words:
                if word == endWord:
                    return level
                for next_word in pattern_to_words.get_neighbors(word):
                    if next_word in seen:
                        continue
                    seen.add(next_word)
                    next_words.append(next_word)
            words = next_words
            level += 1
        return 0
```

### その他
コードが複雑になると、計算量がどれぐらいかよく分からなくなる。今は Claude の力を借りつつだが、いつか自力でできるようになりたい。
また、最初の方の問題を復習していると、10行程度で難しいなあと思っていたことを思い出した。今はその時と比べてずいぶん長いコードを何も見ずに書けるようになったなと思う。
