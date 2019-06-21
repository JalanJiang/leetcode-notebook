# 第 131 场周赛

点击前往 [第 131 场周赛](https://leetcode-cn.com/contest/weekly-contest-131)

**完成情况**

完成三题，第一题由于脑子短路导致超时，耗费了比较长的时间。

<img src="_img/weekly-131.png" />

**总结**

- `if s in list:` 这样的查找一样费时
- 审题要清晰

## 5016. 删除最外层的括号

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/remove-outermost-parentheses/)

### 思路

题目绕来绕去的，所谓原语，其实就是找一个独立的 `(...)` 结构，再将该结构的最外层括号去除。

几个步骤：

1. 找原语
2. 除括号（在原字符串中去除）

这题是经典的括号匹配问题，找原语我通过栈的方式来进行查找。如果入栈元素与栈顶元素可以组成 `()`，则说明匹配成功。

在匹配成功的前提下，若栈内只有一个元素，说明该匹配为原语的最外层括号。

对于除括号的方法一开始用了很智障的方式：先找到括号的下标位置，然后再遍历一次字符串去除。这样造成了额外的耗时，直接导致超时。

其实知道了下标后就可以在字符串进行原地删除了：`s = s[i:] + s[i+1:]`。

```python
class Solution(object):
    def removeOuterParentheses(self, S):
        """
        :type S: str
        :rtype: str
        """
        stack = list()
        stack_index = list()
        mark = list()
        s_list = list(S)
        res = list()
        
        p = 0
        for i in range(len(s_list)):
            length = len(stack)
            c = s_list[i]
            if length != 0:
                # 判断是否匹配
                if c == ")" and stack[length - 1] == "(":
                    stack.pop()
                    index = stack_index.pop()
                    # 判断是否为原语的最外层括号
                    if length - 2 < 0:
                        S = S[:i-p] + S[i-p+1:]
                        S = S[:index-p] + S[index-p+1:]
                        p += 2
                    
                else:
                    stack.append(c)
                    stack_index.append(i)
            else:
                stack.append(c)
                stack_index.append(i)

        return S     
```

## 5017. 从根到叶的二进制数之和

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/sum-of-root-to-leaf-binary-numbers/)

### 思路

考点：二叉树的全路径遍历。

我这边采用递归的写法来做。

ps：题目要求返回值以 `10^9 + 7` 为模，一开始审题不清导致错误。

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def sumRootToLeaf(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        path = ""
        res = list()
        self.treePath(root, path, res)
        s = 0
        for p in res:
            s += int(p, 2)
        return s % (10**9 + 7)
    
    def treePath(self, root, path, res):
        if root is None:
            return
        path += str(root.val)
        if root.left is not None:
            self.treePath(root.left, path, res)
        if root.right is not None:
            self.treePath(root.right, path, res)
        if root.left is None and root.right is None:
            res.append(path)
```

## 5018. 驼峰式匹配

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/camelcase-matching/)

### 思路

双指针问题。

逐个比较 `queries` 单个元素 `q` 是否与 `pattern` 匹配：

- 指针 `i` 指向 `q` 起始位置，指针 `j` 指向 pattern 起始位置
- 如果 `q[i] == pattern[j]`，则表示匹配，往前推进指针 `i += 1` `j += 1`
- 如果 `q[i] != pattern[j]`：
    - 若 `q[i]` 为大写字母，则确定 `q` 与 `pattern` 不匹配
    - 若 `q[i]` 为小写字母，则继续推进 `i` 指针
 
结束循环后，对比两个指针的位置，分为以下几种情况：

- 若指针 `i` 已循环到尾部（表示 `q` 已全部完成匹配）
    - 若指针 `j` 已循环到尾部（表示 `pattern` 中的每一个元素都可以在 `q` 中找到）：匹配结果为 `True`
    - 若指针 `j` 未循环到尾部（表示 `pattern` 中还有元素没有在 `q` 中找到）：匹配结果为 `False`
- 若指针 `i` 未循环到尾部（表示 `q` 未全部完成匹配）
    - 若指针 `j` 已循环到尾部（表示 `pattern` 中的每一个元素都可以在 `q` 中找到），但 `q` 尚未完成所有元素循环，需要判断 `q` 中的剩余元素是否均为小写字母：
        - 都为小写：匹配结果为 `True`
        - 有大写字母存在：匹配结果为 `False`
    - 若指针 `j` 未循环到尾部（表示 `pattern` 中还有元素没有在 `q` 中找到）：匹配结果为 `False`

```python
class Solution(object):
    def camelMatch(self, queries, pattern):
        """
        :type queries: List[str]
        :type pattern: str
        :rtype: List[bool]
        """
        res = []
        p_length = len(pattern)
        p = pattern
        for q in queries:
            q_length = len(q)
            i = 0
            j = 0
            
            while i < q_length and j < p_length:
                if q[i] == p[j]:
                    i = i + 1
                    j = j + 1
                else:
                    if q[i].isupper():
                        break
                    i = i + 1
            print i,j
            if i == q_length: 
                if j == p_length: 
                    res.append(True)
                else:
                    res.append(False)
            else:
                if j == p_length: 
                    tmp = q[i:]
                    if tmp.islower():
                        res.append(True)
                    else:
                        res.append(False)
                else:
                    res.append(False)
            
        return res
```

## 5019. 视频拼接

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/video-stitching/)

### 思路

1. 将原数组排序
2. 判断排序后的相邻元素所在区间是否存在相交情况

```python
class Solution(object):
    def videoStitching(self, clips, T):
        """
        :type clips: List[List[int]]
        :type T: int
        :rtype: int
        """
        c_length = len(clips)
        if c_length == 0:
            return -1
        if T == 0:
            return 0
        
        cs = sorted(clips)
        count = 0
        
        i = 0
        t1 = 0
        t2 = 0
        while i < c_length:
            if cs[i][0] > t1:
                return -1
            while i < c_length and t1 >= cs[i][0]: 
                t2 = max(t2, cs[i][1]) #选取更大的右区间
                i = i + 1
            count = count + 1
            t1 = t2
            #i = i + 1
            if t1 >= T:
                return count
        return -1
```