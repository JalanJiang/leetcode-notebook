## 数组中重复的数字

[原题链接](https://www.nowcoder.com/practice/623a5ac0ea5b4e5f95552655361ae0a8?tpId=13&tqId=11203&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

### 思路

要求 O(n) 复杂度和 O(1) 空间。

这种数组元素在 `[0, n-1]` 范围内的问题，可以将值为 i 的元素调整到第 i 个位置上。

```python
# -*- coding:utf-8 -*-
class Solution:
    # 这里要特别注意~找到任意重复的一个值并赋值到duplication[0]
    # 函数返回True/False
    def duplicate(self, numbers, duplication):
        # write code here
        n = len(numbers)
        for i in range(0, n):
            a = numbers[i]
            if a == i:
                i = i + 1
            else:
                b = numbers[a]
                if b == a:
                    duplication[0] = a
                    return True
                else:
                    numbers[i] = b
                    numbers[a] = a
        return False
```

如果没有考虑空间情况，可以哈希一下：

```python
# -*- coding:utf-8 -*-
class Solution:
    # 这里要特别注意~找到任意重复的一个值并赋值到duplication[0]
    # 函数返回True/False
    def duplicate(self, numbers, duplication):
        # write code here
        tmp_dict = dict()
        for num in numbers:
            if num in tmp_dict:
                duplication[0] = num
                return True
            else:
                tmp_dict[num] = 1
        return False
```