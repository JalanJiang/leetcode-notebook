## 栈的压入、弹出序列

[原题链接](https://www.nowcoder.com/practice/d77d11405cc7470d82554cb392585106?tpId=13&tqId=11174&tPage=2&rp=1&ru=%2Fta%2Fcoding-interviews&qru=%2Fta%2Fcoding-interviews%2Fquestion-ranking)

## 思路

借助一个辅助栈模拟该过程即可。

```python
# -*- coding:utf-8 -*-
class Solution:
    def IsPopOrder(self, pushV, popV):
        # write code here
        stack = list()
        
        index = 0
        for n in pushV:
            stack.append(n)
            print stack
            while len(stack) != 0 and stack[len(stack) - 1] == popV[index]:
                stack.pop()
                index += 1
                
        if len(stack) == 0:
            return True
        else:
            return False
```