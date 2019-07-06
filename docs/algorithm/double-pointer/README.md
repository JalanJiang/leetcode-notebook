## 392. 判断子序列

[原题链接](https://leetcode-cn.com/problems/is-subsequence/)

### 思路

双指针。

指针 `i` 指向 `s` 第一个字符，指针 `j` 指向 `t` 第一个字符。逐一判断 `i` 所指向的字符是否在 `t` 中存在。

- 如果 `s[i] != t[j]`：`j = j + 1`，继续比对下一个字符
- 如果 `s[i] == t[j]`：`i = i + 1`，`j = j + 1`，继续进行下一个 `s[i]` 的查找

```python
class Solution(object):
    def isSubsequence(self, s, t):
        """
        :type s: str
        :type t: str
        :rtype: bool
        """
        s_length = len(s)
        t_length = len(t)
        
        i = 0
        j = 0
        
        while i < s_length:
            s_c = s[i]
            has = False
            while j < t_length:
                t_c = t[j]
                j += 1
                if s_c == t_c:
                    i += 1
                    has = True
                    break
                
            if has == False:
                return False
            
        return True
```