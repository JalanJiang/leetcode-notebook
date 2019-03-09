## 替换空格

[原题链接](https://www.nowcoder.com/practice/4060ac7e3e404ad1a894ef3e17650423?tpId=13&tqId=11155&tPage=1&rp=1&ru=/ta/coding-interviews&qru=/ta/coding-interviews/question-ranking)

### 思路

- 扩展原字符串
    - 字符串每有一个空格，就在末尾增加两个空格
- 设定指针 p1 和 p2
    - p1 指向原字符串末尾
    - p2 指向扩展后字符串末尾
- 循环遍历：
    - 当 p1 为空格时，p2 处依次填入 `0` `2` `%`
    - 当 p1 不为空格时，p2 处填入 p1 值
    
```python
# -*- coding:utf-8 -*-
class Solution:
    # s 源字符串
    def replaceSpace(self, s):
        # write code here
        s_list = list(s)
        s_length = len(s_list)
        
        for i in range(0, s_length):
            c = s_list[i]
            if c == " ":
                s_list.append(" ")
                s_list.append(" ")
                
        now_s_length = len(s_list)
        
        p1 = s_length - 1
        p2 = now_s_length - 1
        
        while p1 >= 0 and p2 > p1:
            if s_list[p1] == " ":
                s_list[p2] = "0"
                p2 = p2 - 1
                s_list[p2] = "2"
                p2 = p2 - 1
                s_list[p2] = "%"
            else:
                s_list[p2] = s_list[p1]
            p2 = p2 - 1
            p1 = p1 - 1
        
        s = "".join(s_list)
        return s

```