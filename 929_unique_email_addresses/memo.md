# 929. Unique Email Addresses

https://leetcode.com/problems/unique-email-addresses/
### step1
- 時間計算量
    - O(N * k)
- 空間計算量
    - O(N * k)
```python
class Solution:
    def numUniqueEmails(self, emails: list[str]) -> int:
        """
        @で区切る
        local name
            +で区切る [0] のみ採用
            . が来たら無視
        domain name
            len > 4 ならオッケイ
        """
        if not emails:
            return 0

        valid_emails = set()

        for email in emails:
            local_name, domain_name = email.split('@')
            if len(domain_name) < 4:
                continue
            local_name, *_ = local_name.split('+')
            tmp = []
            for char in local_name:
                if char == '.':
                    continue
                tmp.append(char)

            valid_emails.add(''.join(tmp) + '@' + domain_name)

        return len(valid_emails)
```


### step2
### step2.1 step1のコードのリファクタリング
- エッジケース
    - @ が複数 or 0
    - domain_name が .com だけ. .com がない場合もあるか
- 時間計算量
    - O(N * k)
- 空間計算量
    - O(N * k)
```python
class Solution:
    def numUniqueEmails(self, emails: list[str]) -> int:
        if not emails:
            return 0

        valid_emails = set()

        for email in emails:
            local_name, domain_name = email.split('@')
            if len(domain_name) < 4:
                continue

            local_name_before_plus = local_name.split('+')[0]
            normalized_local_name = local_name_before_plus.replace('.', '')
            valid_emails.add(f"{normalized_local_name}@{domain_name}")

        return len(valid_emails)
```

### step2.2 ポインタを使う方針
- 初見でポインタを使う方針を思いつくことがまずないなあ。
- https://github.com/hayashi-ay/leetcode/blob/2e5af6c462dc876cda45f78e071084bcc414d53f/929.%20Unique%20Email%20Addresses.md
- 時間計算量
    - O(N * k)
- 空間計算量
    - O(N * k)
```python
class Solution:
    def numUniqueEmails(self, emails: list[str]) -> int:
        """
        actual_email = []
         + or @ が来るまで追加
            . は追加しない

        @じゃなくなるまで進む
        """
        if not emails:
            return 0
        actual_emails = set()

        for email in emails:
            actual_email = []
            i = 0
            while email[i] not in '+@':
                if email[i] != '.':
                    actual_email.append(email[i])
                i += 1
            while email[i] != '@':
                i += 1
            actual_email.append(email[i:])
            actual_emails.add(''.join(actual_email))

        return len(actual_emails)
```


### step3
- step1のコードを整えた
- 関数名は、canonicalize ([nodchipさん](https://github.com/t0hsumi/leetcode/pull/14/changes/18695cb5c56fead098defab52c79a008ada86b62))
- [rsplit](https://docs.python.org/3/library/stdtypes.html#str.rsplit)
- .com + 1文字は5だった、、、
- 時間計算量
    - O(N * k)
- 空間計算量
    - O(N * k)
```python
class Solution:
    def numUniqueEmails(self, emails: list[str]) -> int:
        """
        unique_email = []
        一番右の@で分離
        domain は 何か1文字以上 + .com
        local
            +で分けて、一番左
            . はreplace

        """
        if not emails:
            return 0
        unique_emails = set()

        def _canonicalize(email: str) -> str | None:
            local, domain = email.rsplit('@', maxsplit = 1)
            if len(domain) < 5 or not domain.endswith('.com'):
                return None

            local_before_plus, *_ = local.split('+')
            normalized_local = local_before_plus.replace('.', '')

            return f"{normalized_local}@{domain}"

        for email in emails:
            result = _canonicalize(email)
            if result is None:
                continue
            unique_emails.add(result)

        return len(unique_emails)
```

