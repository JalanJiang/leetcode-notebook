# 第 137 场周赛

点击前往 [第 137 场周赛](https://leetcode-cn.com/contest/weekly-contest-137)

**完成情况**

半小时完成前两题。然而后面一小时没有产出了，看了 3、4 两题题目后没有思绪，并且看到第三题很少有人完成后，思绪又在两道题之前飘忽不定……

<img src="_img/weekly-137.png">

在第一题中也发生了审题不清的情况，并且没有好好测试就着急提交了，导致两次出错。

**总结**

- 以后吃饱再参加竞赛吧……

## 1048. 最长字符串链

[原题链接](https://leetcode-cn.com/contest/weekly-contest-137/problems/longest-string-chain/)

### 思路

动态规划。

用 `dp[word]` 表示 word 再词链中时词链可达到的最大长度。

那么可以得出公式：

```
dp[word] = max(dp.get(word, 1), dp.get(word[:i] + word[i + 1:], 0) + 1)
```

```python
class Solution(object):
    def longestStrChain(self, words):
        """
        :type words: List[str]
        :rtype: int
        """
        dp = dict()
        
        words = sorted(words, key=len)
                
        for word in words:
            for i in range(len(word)):
                dp[word] = max(dp.get(word, 1), dp.get(word[:i] + word[i + 1:], 0) + 1)
                
        res = max(dp.values())
        
        if res == 0:
            return 1
        else:
            return res
```

## 5063. 最后一块石头的重量

[原题链接](https://leetcode-cn.com/contest/weekly-contest-137/problems/last-stone-weight/)

### 思路

1. 对 `stones` 降序排序
2. 计算出前两个石头的差值 `diff`
    - 如果 `diff == 0`，那么直接从 `stones` 删除这两个石头
    - 如果 `diff != 0` 那么删除两个石头，并将 `diff` 值放入 `stones` 中合适的位置，使得 `stones` 始终为有序的形态

```python
class Solution(object):
    def lastStoneWeight(self, stones):
        """
        :type stones: List[int]
        :rtype: int
        """
        stones.sort(reverse=True)
        
        length = len(stones)
        while length > 1:
            print stones
            a = stones[0]
            b = stones[1]
            diff = abs(a - b)
            # print diff
            if diff == 0:
                del stones[0]
                del stones[0]
                length -= 2
            else:
                del stones[0]
                length -= 1
                i = 1
                # 后面的值往前移动，找到合适的位置放入 diff
                while i < length and stones[i] > diff:
                    print i
                    stones[i - 1] = stones[i]
                    i = i + 1
                stones[i - 1] = diff
        
        if length == 1:
            return stones[0]
        else:
            return 0
```

## 5064. 删除字符串中的所有相邻重复项

[原题链接](https://leetcode-cn.com/contest/weekly-contest-137/problems/remove-all-adjacent-duplicates-in-string/)

### 思路

用栈实现，类似匹配括号的题目。

如果入栈的字符和栈顶元素相等，则匹配为重复项，弹出栈顶元素；如果不相等则入栈。

### 复杂度

时间复杂度和空间复杂度都是 `O(n)`。

### 编码实现

```python
class Solution(object):
    def removeDuplicates(self, S):
        """
        :type S: str
        :rtype: str
        """
        stack = list()
        for s in S:
            length = len(stack)
            if length == 0:
                stack.append(s)
            else:
                top = stack[-1]
                if top == s:
                    stack.pop()
                else:
                    stack.append(s)
        return "".join(stack)
```