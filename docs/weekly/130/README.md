# 第 130 场周赛

点击前往：[第 130 场周赛](https://leetcode-cn.com/contest/weekly-contest-130)

## 1028. 负二进制转换

[原题链接](https://leetcode-cn.com/contest/weekly-contest-130/problems/convert-to-base-2/)

### 思路

就是用十进制转二进制的竖除法来写的。

```python
class Solution(object):
    def baseNeg2(self, N):
        """
        :type N: int
        :rtype: str
        """
        if N == 0:
            return '0'
        ans = []
        while N != 0:
            tmp = N % (-2)
            ans.append(str(abs(tmp)))
            N = N / (-2)
            if tmp < 0:
                N += 1
        ans.reverse()
        return ''.join(ans)
```

```python
class Solution:
    def baseNeg2(self, N: int) -> str:
        if N == 0:
            return "0"
        ans = []
        while N != 0:
            x = N % -2
            if x == -1:
                x = 1
                N -= 2
            N = N // -2
            ans.append(str(x))
        return "".join(ans[::-1])
```

## 1029. 可被 5 整除的二进制前缀

[原题链接](https://leetcode-cn.com/contest/weekly-contest-130/problems/binary-prefix-divisible-by-5/)

### 思路

```python
class Solution(object):
    def prefixesDivBy5(self, A):
        """
        :type A: List[int]
        :rtype: List[bool]
        """
        
        five = bin(5)
        res = list()
        tmp_str = ""
        
        for a in A:
            tmp_str = tmp_str + str(a)
            tmp_bin = "0b" + tmp_str
            re = int(tmp_bin, 2) % 5
            if re == 0:
                res.append(True)
            else:
                res.append(False)
        
        return res
```

## 1030. 链表中的下一个更大节点

[原题链接](https://leetcode-cn.com/contest/weekly-contest-130/problems/next-greater-node-in-linked-list/)

### 解法一

疯狂超时版本

```python
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def nextLargerNodes(self, head):
        """
        :type head: ListNode
        :rtype: List[int]
        """
        tmp = head
        list_length = 0
        list_num = list()
        max_num = 0
        max_index = 0
        while tmp:
            list_length += 1
            list_num.append(tmp.val)
            
            if tmp.val > max_num:
                max_num = tmp.val
                max_index = list_length - 1
            
            tmp = tmp.next
            
        
        res = [0 for _ in range(list_length)]
        
        i = 0
        
        while i < list_length:
            j = i + 1
            while j < list_length:
                
                if list_num[i] == max_num:
                    break
                    
                if i == max_index - 1:
                    res[i] = max_num
    
                if list_num[j] > list_num[i]:
                    res[i] = list_num[j]
                    break
    
                j = j + 1
            i = i + 1
        return res
```

### 解法二

创建一个栈 `last`，从尾部开始遍历，判断栈顶元素是否大于当前元素 n：

- 大于 `n`：放入结果队列
- 小于 `n`：从栈顶弹出

```python
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def nextLargerNodes(self, head):
        """
        :type head: ListNode
        :rtype: List[int]
        """
        nums = list()
        while head:
            nums.append(head.val)
            head = head.next
            
        nums.reverse()
        
        res = list()
        last = list()
        
        for n in nums:
            
            while last and n >= last[-1]:
                last.pop()
                
            if last:
                res.append(last[-1])
            else:
                res.append(0)
            
            last.append(n)
            
        res.reverse()
        return res
```