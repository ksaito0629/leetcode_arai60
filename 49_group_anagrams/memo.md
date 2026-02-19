# 49. Group Anagrams

https://leetcode.com/problems/group-anagrams/

### step1
- anagram の各文字のカウントをキーとして、グルーピングすればできそう。
    - と思ったが、色々とわからない点が多く自力で書けなかった。

## step2
- 他の方の回答を見た。
- sortedを使う方針
- こういう問題を見たときにどういう風にブレイク・ダウンしたよいのかを考えた。
    - 複数のアナグラムをグループにするには？
        - グルーピング -> hash map
    - 2つの単語があったとして、アナグラムか確かめるには？
        - 比較可能な形があればよい
    - 比較可能な形とは？
        - アナグラムだから、各文字のカウント or sort すれば同じ。
    - 比較可能な形にするには？
- 解く前に時間を見積もる（[fugaさん](https://github.com/Fuminiton/LeetCode/pull/12/changes/2f240c1f99ce12916760d9cd202cebc62a9b336c)）

- 時間計算量
    - O(N * k log k)
- 空間計算量
    - O(N * k)
```python
class Solution:
    def groupAnagrams(self, strs: list[str]) -> list[list[str]]:

        """
        複数のアナグラムをグループにするには？
        ↓
        2つの単語があったとして、アナグラムか確かめるには？
        ↓
        比較可能な形とは？
        ↓
        比較可能なかたちにするには？
        ー＞　sort, -> key of dict
        """
        key_word_to_anagram = {}

        def make_key_word(word):
            key_word = "".join(sorted(word))
            return key_word

        for word in strs:
            key_word = make_key_word(word)
            if key_word not in key_word_to_anagram:
                key_word_to_anagram[key_word] = []
            key_word_to_anagram[key_word].append(word)

        return list(key_word_to_anagram.values())
```
### step3 alphabetのカウントで比較する方針
- 今回は、lowercase English letters だから使える最適化かなと思う。
- あらゆる文字に対応するとなったら、辞書 ー＞ tuple をキーにするとかかな。こちらは、sorted しないとキーとして使えないが、、
- 時間計算量
    - O(N * k)
- 空間計算量
    - O(N * k)
```python
class Solution:
    def groupAnagrams(self, strs: list[str]) -> list[list[str]]:
        char_freq_to_anagram = {}

        def count_char_freq(word):
            char_freq = [0] * 26
            for char in word:
                char_freq[ord(char) - ord("a")] += 1
            char_freq_key = tuple(char_freq)
            return char_freq_key

        for word in strs:
            char_freq_key = count_char_freq(word)
            if char_freq_key not in char_freq_to_anagram:
                char_freq_to_anagram[char_freq_key] = []
            char_freq_to_anagram[char_freq_key].append(word)

        return list(char_freq_to_anagram.values())
```
