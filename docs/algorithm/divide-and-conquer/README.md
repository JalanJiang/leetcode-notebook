## 241. 为运算表达式设计优先级

[原题链接](https://leetcode-cn.com/problems/different-ways-to-add-parentheses/)

### 思路

分治 + 递归。

遇到运算符时：

1. 计算运算符左边的结果集
2. 计算运算符右边的结果集

```python
class Solution:
    def diffWaysToCompute(self, input: str) -> List[int]:
        # 如果只有数字，直接返回
        if input.isdigit():
            return [int(input)]
        
        res = []
        for i, char in enumerate(input):
            if char in ['+', '-', '*']:
                # 遇到运算符，计算左右两侧的结果集
                left = self.diffWaysToCompute(input[:i])
                right = self.diffWaysToCompute(input[i+1:])
                for l in left:
                    for r in right:
                        if char == '+':
                            res.append(l + r)
                        elif char == '-':
                            res.append(l - r)
                        else:
                            res.append(l * r)
                            
        return res
```

## 395. 至少有K个重复字符的最长子串

[原题链接](https://leetcode-cn.com/problems/longest-substring-with-at-least-k-repeating-characters/)

### 思路

分治。

核心思想：如果某个字符 `x` 在整个字符串中出现的次数 `<k`，那么 `x` 不可能出现在最终要求的子串中。因此，可以将原字符串截断为：

```
x 左侧字符子串 + x + x 右侧字符子串
```

因此，问题就被拆分为对左子串、右子串求解这两个子问题。

Python，用的是递归。

```python
class Solution(object):
    def longestSubstring(self, s, k):
        """
        :type s: str
        :type k: int
        :rtype: int
        """
        def find(s, k, left, right):
            if left > right:
                return 0
            
            # 用字典存储所有字符出现的情况
            hash_map = dict()
            for i in range(left, right + 1):
                c = s[i]
                if hash_map.get(c, None) == None:
                    hash_map[c] = []
                hash_map[c].append(i)
                
            for key in hash_map.keys():
                # 某个字符出现的次数
                counter = len(hash_map[key])
                # 如果字符出现次数 < k，那么该字符不可能出现在最终要求的子串中，在该字符的位置对原字符串进行截断
                if counter > 0 and counter < k:
                    # 该字符首次出现的位置
                    pos = hash_map[key][0]
                    # 根据该字符的位置对字符串进行截断，判断左右两个截断的字字符哪个更长
                    return max(find(s, k, left, pos - 1), find(s, k, pos + 1, right))
            
            return right - left + 1
        
        return find(s, k, 0, len(s) - 1)
```

## 932. 漂亮数组

[原题链接](https://leetcode-cn.com/problems/beautiful-array/)

### 思路

```python
class Solution:
    def beautifulArray(self, N: int) -> List[int]:
        m = {1: [1]}
        def f(N):
            if N not in m:
                odds = f((N + 1) // 2)
                evens = f(N // 2)
                m[N] = [2 * x - 1 for x in odds] + [2 * x for x in evens]
            return m[N]
        return f(N)
```