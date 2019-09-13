## 第 121 场周赛

### 984. 不含 AAA 或 BBB 的字符串

[原题链接](https://leetcode-cn.com/contest/weekly-contest-121/problems/string-without-aaa-or-bbb/)

#### 思路

考虑 a 在前的情况：

- 当 A == 0 时：插入 b
- 当 B == 0 时：插入 a
- 当 A > B 时：插入 aab
- 当 B > A 时：插入 abb

注：如果 B > A，则先将 bb 入队列。

```python
class Solution(object):
    def strWithout3a3b(self, A, B):
        """
        :type A: int
        :type B: int
        :rtype: str
        """
        
        res_list = []
        
        if A == 0 and B == 0:
            return ""
        
        if B > A and A != 0:
            res_list.append("bb")
            B = B - 2
        
        while A != 0 or B != 0:
            
            if A == 0:
                res_list.append("b")
                B = B - 1
                continue
                
            if B == 0:
                res_list.append("a")
                A = A - 1
                continue
                
            if A > B:
                res_list.append("aa")
                A = A - 2
                res_list.append("b")
                B = B - 1
            elif B > A:
                res_list.append("a")
                A = A - 1
                res_list.append("bb")
                B = B - 2
            else:
                res_list.append("a")
                A = A - 1
                res_list.append("b")
                B = B - 1 
            
        return "".join(res_list)  
```

----

## 第 122 场周赛

点击前往：[第 122 场周赛](https://leetcode-cn.com/contest/weekly-contest-122)

第一次参加，紧张的一批。

<img src="_img/weekly-122.png"/>

结果还可以吧，太躁了，感觉应该可以做三题。期待下次更 🐂🍺 一点~

### 985. 查询后的偶数和

[原题链接](https://leetcode-cn.com/contest/weekly-contest-122/problems/sum-of-even-numbers-after-queries/)

#### 思路

挺简单的，最终的结果不需要每次依次相加，在原来的基础上加上或减去就好。

<!-- tabs:start -->
#### ** Python **

```python
class Solution(object):
    def sumEvenAfterQueries(self, A, queries):
        """
        :type A: List[int]
        :type queries: List[List[int]]
        :rtype: List[int]
        """
        answer = []
        s = 0
        for num in A:
            if num % 2 == 0:
                s = s + num        
        
        for i in range(len(A)):
            val = queries[i][0]
            index = queries[i][1]
            pre = A[index]
            if pre % 2 == 0 and val % 2 == 0:
                s = s + val
            if pre % 2 == 0 and val % 2 == 1:
                s = s - pre    
            if pre % 2 == 1 and val % 2 == 1:
                s = s + val + pre
            A[index] = pre + val            
            answer.append(s)
        
        return answer
```

#### ** Java **

```java
class Solution {
    public int[] sumEvenAfterQueries(int[] A, int[][] queries) {
        int[] result = new int[queries.length];
        int init = 0;
        for (int value: A) {
            if ((value & 1) == 0) {
                init += value;
            }
        }
        for (int i = 0; i < queries.length; i++) {
            int val = queries[i][0];
            int index = queries[i][1];
            int pre = A[index];
            A[index] = pre + val;
            if ((pre & 1) == 0) {
                if ((A[index] & 1) == 0) {
                    init = init - pre + A[index];
                } else {
                    init -= pre;
                }
            } else {
                if ((A[index] & 1) == 0) {
                    init += A[index];
                }
            }
            result[i] = init;
        }
        return result;
    }
}
```

<!-- tabs:end -->

### 986. 区间列表的交集

[原题链接](https://leetcode-cn.com/contest/weekly-contest-122/problems/interval-list-intersections/)

#### 思路

简单题，考虑好所有情况就好了，包括 `[25, 25]` 这种也算一个区间的情况……

这题 debug 了两三次，漏了一些情况导致答案错误。

<!-- tabs:start -->
#### ** Python **

```python
# Definition for an interval.
# class Interval(object):
#     def __init__(self, s=0, e=0):
#         self.start = s
#         self.end = e

class Solution(object):
    def intervalIntersection(self, A, B):
        """
        :type A: List[Interval]
        :type B: List[Interval]
        :rtype: List[Interval]
        """
        res = []
        b_i = 0
        for a in A:
            a_start = a.start
            a_end = a.end
            tmp = []
            for j in range(b_i, len(B)):
                b_start = B[j].start
                b_end = B[j].end
                
                if a_end < b_start:
                    #b_i = b_i + 1
                    break
                    
                if a_end == b_start:
                    i = Interval(a_end, a_end)
                    res.append(i)
                    break
                    
                if b_end == a_start:
                    i = Interval(a_start, a_start)
                    res.append(i)
                    continue
                
                if b_start > a_start and b_start < a_end and b_end > a_end:
                    i = Interval(b_start, a_end)
                    print "a"
                    res.append(i)
                
                if a_start > b_start and a_start < b_end and a_end > b_end:
                    i = Interval(a_start, b_end)
                    print "b"
                    res.append(i)
                    
                if b_start >= a_start and b_end <= a_end:
                    i = Interval(b_start, b_end)
                    print "c"
                    res.append(i)
                elif a_start >= b_start and a_end <= b_end:
                    i = Interval(a_start, a_end)
                    print "d"
                    res.append(i)
        return res
```

#### ** Java **

```java
class Solution {
    public Interval[] intervalIntersection(Interval[] A, Interval[] B) {
        List<Interval> result = new ArrayList<Interval>();
        for (Interval a: A) {
            for (Interval b: B) {
                if (a.start > b.end || a.end < b.start) {
                    continue;
                }
                if (a.start >= b.start && a.end <= b.end) {
                    Interval value = new Interval(a.start, a.end);
                    result.add(value);
                    continue;
                } 
                
                if (a.start <= b.start && a.end >= b.end) {
                    Interval value = new Interval(b.start, b.end);
                    result.add(value);
                    continue;
                }
                
                if (a.start >= b.start) {
                    Interval value = new Interval(a.start, b.end);
                    result.add(value);
                    continue;
                }
                
                if (a.start <= b.start) {
                    Interval value = new Interval(b.start, a.end);
                    result.add(value);
                }
            }
        }
        Interval[] res = new Interval[result.size()];
        return result.toArray(res);
    }
}
```

<!-- tabs:end -->

### 988. 从叶结点开始的最小字符串

[原题链接](https://leetcode-cn.com/contest/weekly-contest-122/problems/smallest-string-starting-from-leaf/)

### 思路

这题规定时间内没做出来，后来想想挺简单的。

- 递归，求得所有路径
- 在所有路径中返回最小路径

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def smallestFromLeaf(self, root):
        strs = []
        def dfs(t, s):
            s = chr(ord('a') + t.val) + s
            if t.left == None and t.right == None:
                strs.append(s)
            else:
                if t.left != None:
                    dfs(t.left, s)
                if t.right != None:
                    dfs(t.right, s)
        dfs(root, '')
        return min(strs)
```

----

## 第 124 场周赛

点击前往：[第 124 场周赛](https://leetcode-cn.com/contest/weekly-contest-124)

### 993. 二叉树的堂兄弟节点

[原题链接](https://leetcode-cn.com/contest/weekly-contest-124/problems/cousins-in-binary-tree/)

#### 解法一

- 递归求出对应节点的深度
- 递归判断两个节点是否属于同个父节点

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def isCousins(self, root, x, y):
        """
        :type root: TreeNode
        :type x: int
        :type y: int
        :rtype: bool
        """
        # get depth
        x_depth = self.getDepth(root, x, 0)
        y_depth = self.getDepth(root, y, 0)
        
        #print x_depth
        #print y_depth
        
        if x_depth != y_depth or x_depth == 0 or y_depth == 0:
            return False
        
        # get parent
        parent = self.isParent(root, x, y)
        print(parent)
        if parent == False:
            return True
        else:
            return False
        
    
    def getDepth(self, root, target, depth):
        if root is None:
            return 0
        else:
            #print root.val
            if root.val == target:
                return depth
            else:
                return max(self.getDepth(root.left, target, depth + 1), self.getDepth(root.right, target, depth + 1))
            
    def isParent(self, root, x, y):
        if root is None:
            return False
        else:
            if root.left is not None and root.right is not None:
                if (root.left.val == x and root.right.val == y) or (root.left.val == y and root.right.val == x):
                    return True
                else:
                    return self.isParent(root.left, x, y) or self.isParent(root.right, x, y)
            else:
                return self.isParent(root.left, x, y) or self.isParent(root.right, x, y)
```

#### 解法二

参照：[从上往下打印二叉树](/offer/tree-bfs.html)

借助队列，一层一层遍历。

```python
# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def isCousins(self, root, x, y):
        """
        :type root: TreeNode
        :type x: int
        :type y: int
        :rtype: bool
        """
        def find(x):
            q=collections.deque()
            q.append((root, None, 0))
            while q:
                node, p, d = q.popleft()
                if node.val == x:
                    return p, d
                else:
                    if node.left is not None:
                        q.append((node.left, node, d+1))
                    if node.right is not None:
                        q.append((node.right, node, d+1))
        px, dx = find(x)
        py, dy = find(y)
        return dx == dy and px != py
```

### 994. 腐烂的橘子

[原题链接](https://leetcode-cn.com/contest/weekly-contest-124/problems/rotting-oranges/)

### 思路

基本思路：从 `1` 出发搜索，返回找到 `2` 需要走的步数（即分钟数），求得该步数的最大值。

解决方法借助**队列**，如果走到的下一个点还是 `1` 则入队列，作为下次搜索的起点。

```python
class Solution(object):
    minute = 0
    def orangesRotting(self, grid):
        """
        :type grid: List[List[int]]
        :rtype: int
        """
        row = len(grid)
        col = len(grid[0])
        
        ans = 0
        for i in range(row):
            for j in range(col):
                if grid[i][j] == 1:
                    ans = max(ans, self.bfs(i, j, grid))
        
        if ans < float('inf'):
            return ans
        
        return -1
        

    def bfs(self, x, y, grid):
        row = len(grid)
        col = len(grid[0])
        
        ds = ((0, 1), (0, -1), (1, 0), (-1, 0))
        q = list()
        visit = [[0] * col for _ in range(row)]
        q.append((x, y, 0))
        
        while q:
            i, j, s = q[0]
            del q[0]
            if visit[i][j] == 1:
                continue
            visit[i][j] = 1
            for di, dj in ds:
                ni, nj = i + di, j + dj
                if 0 <= ni < row and 0 <= nj < col:
                    if grid[ni][nj] == 1:
                        q.append((ni, nj, s + 1))
                    if grid[ni][nj] == 2:
                        return s + 1
        return float('inf')
```

----

## 第 129 场周赛

点击前往：[第 129 场周赛](https://leetcode-cn.com/contest/weekly-contest-129)

### 1020. 将数组分成和相等的三个部分

[原题链接](https://leetcode-cn.com/contest/weekly-contest-129/problems/partition-array-into-three-parts-with-equal-sum/)

#### 思路

一开始想错了方法，想要暴力解决，二次循环导致超时。后面改成用数组存储数字和，也是需要嵌套循环，陷入思维误区了。

其实判断是否 `%3 == 0` 再找出三组 `s == sum // 3` 即可。

```python
class Solution(object):
    def canThreePartsEqualSum(self, A):
        """
        :type A: List[int]
        :rtype: bool
        """
        s = 0
        length = len(A)
        for n in A:
            s = s + n
        if s % 3 == 0:
            div = s / 3
        else:
            return False
        
        g = 0
        tmp = 0


        for i in range(length):
            tmp = A[i] + tmp
            if tmp == div:
                g = g + 1
                tmp = 0
        if g == 3:
            return True
        else:
            return False
```

### 1022. 可被 K 整除的最小整数

[原题链接](https://leetcode-cn.com/contest/weekly-contest-129/problems/smallest-integer-divisible-by-k/)

#### 思路

暴力叠加求解。

```python
class Solution(object):
    def smallestRepunitDivByK(self, K):
        """
        :type K: int
        :rtype: int
        """
        num = 0
        for i in range(2 * K):
            num = num * 10 + 1
            num %= K
            if num == 0:
                return i + 1
        return -1
```

----

## 第 130 场周赛

点击前往：[第 130 场周赛](https://leetcode-cn.com/contest/weekly-contest-130)

### 1028. 负二进制转换

[原题链接](https://leetcode-cn.com/contest/weekly-contest-130/problems/convert-to-base-2/)

#### 思路

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

### 1029. 可被 5 整除的二进制前缀

[原题链接](https://leetcode-cn.com/contest/weekly-contest-130/problems/binary-prefix-divisible-by-5/)

#### 思路

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

### 1030. 链表中的下一个更大节点

[原题链接](https://leetcode-cn.com/contest/weekly-contest-130/problems/next-greater-node-in-linked-list/)

#### 解法一

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

#### 解法二

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

----

## 第 131 场周赛

点击前往 [第 131 场周赛](https://leetcode-cn.com/contest/weekly-contest-131)

**完成情况**

完成三题，第一题由于脑子短路导致超时，耗费了比较长的时间。

<img src="_img/weekly-131.png" />

**总结**

- `if s in list:` 这样的查找一样费时
- 审题要清晰

### 5016. 删除最外层的括号

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/remove-outermost-parentheses/)

#### 思路

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

### 5017. 从根到叶的二进制数之和

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/sum-of-root-to-leaf-binary-numbers/)

#### 思路

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

### 5018. 驼峰式匹配

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/camelcase-matching/)

#### 思路

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

### 5019. 视频拼接

[原题链接](https://leetcode-cn.com/contest/weekly-contest-131/problems/video-stitching/)

#### 思路

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

----

## 第 133 场周赛

点击前往 [第 133 场周赛](https://leetcode-cn.com/contest/weekly-contest-133)

**完成情况**

完成两题。

<img src="_img/weekly-133.png" />

第一题其实挺简单的，结果一直在乱想是贪心还是动态规划啥的，脑子直接卡机了……其实问题往往没有那么复杂。

第二题没有想清楚思路就开始写了，结果导致改了很多遍，浪费了很多时间。

**总结**

- 构思后再码

### 1029. 两地调度

[原题链接](https://leetcode-cn.com/contest/weekly-contest-133/problems/two-city-scheduling/)

#### 思路

核心思想：看某个人前往 A 还是前往 B 的成本更大。

计算去 A 和去 B 的成本差值，假设记为 `d`，如果 `d` 值很大，表示去 A 的成本更高，则去 A 的优先级降低。

```python
class Solution(object):
    def twoCitySchedCost(self, costs):
        """
        :type costs: List[List[int]]
        :rtype: int
        """
        N = len(costs) / 2
        count = 0
        dif = []
        for i in range(len(costs)):
            c = costs[i]
            dif.append([c[0] - c[1], i])
        dif.sort()
        for d in dif:
            index = d[1]
            if N > 0:
                count += costs[index][0]
            else:
                count += costs[index][1]
            N -= 1
        return count
```

### 1030. 距离顺序排列矩阵单元格

[原题链接](https://leetcode-cn.com/contest/weekly-contest-133/problems/matrix-cells-in-distance-order/)

#### 思路

从 `(r0, c0)` 往上下左右出发，能打到的单元格距离为 `1`，将这组单元格放入列表，遍历该列表，继续往上下左右出发……

我这里用一个二维数组 `mark` 来记录单元格是否遍历过了。

```python
class Solution(object):
    def allCellsDistOrder(self, R, C, r0, c0):
        """
        :type R: int
        :type C: int
        :type r0: int
        :type c0: int
        :rtype: List[List[int]]
        """
        max_r = R - 1
        max_c = C - 1
        
        res = []
        tmp = []
        mark = [[0 for _ in range(C)] for _ in range(R)]
        mark[r0][c0] = 1
        res.append([r0, c0])
        tmp.append([r0, c0])
        
        while tmp:
            for i in range(len(tmp)):
                t = tmp[0]
                r = t[0]
                c = t[1]
                del tmp[0]
                print[r, c]
                if r + 1 < R:
                    if mark[r+1][c] == 0:
                        tmp.append([r+1, c])
                        mark[r+1][c] = 1
                if r - 1 >= 0:
                    if mark[r-1][c] == 0:
                        tmp.append([r-1, c])
                        mark[r-1][c] = 1
                if c + 1 < C:
                    if mark[r][c+1] == 0:
                        tmp.append([r, c+1])
                        mark[r][c+1] = 1
                if c - 1 >= 0:
                    if mark[r][c-1] == 0:
                        tmp.append([r, c-1])
                        mark[r][c-1] = 1
            res += tmp
        return res
```

### 1031. 两个非重叠子数组的最大和

[原题链接](https://leetcode-cn.com/contest/weekly-contest-133/problems/maximum-sum-of-two-non-overlapping-subarrays/)

#### 思路

- 记前 i 项的和为 `s[i + 1]`
- 则区间长度可以表示为：`s[i+L] - s[i] + s[j+M] - s[j]`，求这个长度的最大值即可

```python
class Solution(object):
    def maxSumTwoNoOverlap(self, A, L, M):
        """
        :type A: List[int]
        :type L: int
        :type M: int
        :rtype: int
        """
        s = [0]
        length = len(A)
        for i in range(length):
            s.append(s[i] + A[i])
            
        res = 0
        for i in range(length):
            for j in range(length):
                if self.checkij(i, j, L, M, length) == True:
                    res = max(res, s[i+L] - s[i] + s[j+M] - s[j])
        return res
           
    # 判断 i j 取值是否可行
    def checkij(self, i, j, L, M, length):
        if i + L <= length and j + M <= length and (i + L <= j or j + M <= i):
            return True
        else:
            return False
```

----

## 第 134 场周赛

点击前往 [第 133 场周赛](https://leetcode-cn.com/contest/weekly-contest-134)

**完成情况**

没有做满 1 小时 30 分，大概用 1 小时的时间完成了两题。

<img src="_img/weekly-134.png" />

第一题简单题，但一开始题意理解错了，导致解答的时候漏了一种情况。

第二题和上周竞赛某题挺像的，依旧没有用递归来写，怕写错了，递归的写法还是要加强。

**总结**

- 递归练习

### 5039. 移动石子直到连续

[原题链接](https://leetcode-cn.com/contest/weekly-contest-134/problems/moving-stones-until-consecutive/)

#### 思路

- 先对输入的 a b c 进行排序，得到 x y z
- 计算 x 与 y 的距离 `y - x`，记为 `left`；y 与 z 的距离 `z - y`，记为 `right`

分成以下几种情况：

- `left == 1` 时，即 x 与 y 相邻：
    - `right == 1`，z 与 y 也相邻：那么无需任何移动
    - `right != 1`，z 与 y 不相邻：可移动的最小次数为 1，最大次数为 `right - 1`
- `left != 1` 时，即 x 与 y 不相邻：
    - `right == 1`，z 与 y 相邻：可移动的最小次数为 1，最大次数为 `left - 1`
    - `right != 1`，z 与 y 不相邻：若 `left == 2` 或 `right == 2`，那么最小次数为 1，否则最小次数为 2；最大次数为 `right - 1 + left - 1`
        
代码写的太丑了。。。

```python
class Solution(object):
    def numMovesStones(self, a, b, c):
        """
        :type a: int
        :type b: int
        :type c: int
        :rtype: List[int]
        """
        t = [0 for _ in range(3)]
        t[0] = a
        t[1] = b
        t[2] = c
        t.sort()
        res = [0, 0]
        x = t[0]
        y = t[1]
        z = t[2]
        
        left = y - x
        right = z - y
        
        if left == 1:
            if right == 1:
                return res
            else:
                min_n = 1
                max_n = right - 1
        else:
            if right == 1:
                min_n = 1
                max_n = left - 1
            else:
                if left == 2 or right == 2:
                    min_n = 1
                else:
                    min_n = 2
                max_n = right - 1 + left - 1
        
        res[0] = min_n
        res[1] = max_n
        
        return res
```

### 5040. 边框着色

[原题链接](https://leetcode-cn.com/contest/weekly-contest-134/problems/coloring-a-border/)

#### 思路

从 `(r0, c0)` 开始往四个方向走，如果发现走到的下一个格子是界外或是连通分量外，则将上一个格子标记为 `color`。

这里用 `mark` 二维数组存储是否已经走过了某个格子。

和上周竞赛的 [距离顺序排列矩阵单元格](/weekly/133/1030.md) 问题很像，但我感觉应该还有更好的方法吧。待复盘补充。

```python
class Solution(object):
    def colorBorder(self, grid, r0, c0, color):
        """
        :type grid: List[List[int]]
        :type r0: int
        :type c0: int
        :type color: int
        :rtype: List[List[int]]
        """
        R = len(grid)
        C = len(grid[0])
        
        tmp = []
        mark = [[0 for _ in range(C)] for _ in range(R)]
        mark[r0][c0] = 1
        co = grid[r0][c0]
        tmp.append([r0, c0])
        
        while tmp:
            for i in range(len(tmp)):
                t = tmp[0]
                r = t[0]
                c = t[1]
                del tmp[0]
                if r + 1 < R:
                    if mark[r+1][c] == 0:
                        if grid[r+1][c] == co:
                            tmp.append([r+1, c])
                            mark[r+1][c] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
                    
                if r - 1 >= 0:
                    if mark[r-1][c] == 0:
                        if grid[r-1][c] == co:
                            tmp.append([r-1, c])
                            mark[r-1][c] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
                    
                if c + 1 < C:
                    if mark[r][c+1] == 0:
                        if grid[r][c+1] == co:
                            tmp.append([r, c+1])
                            mark[r][c+1] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
                    
                if c - 1 >= 0:
                    if mark[r][c-1] == 0:
                        if grid[r][c-1] == co:
                            tmp.append([r, c-1])
                            mark[r][c-1] = 1
                        else:
                            grid[r][c] = color
                else:
                    grid[r][c] = color
            
        return grid
```

### 5041. 不相交的线

[原题链接](https://leetcode-cn.com/contest/weekly-contest-134/problems/uncrossed-lines/)

#### 思路

设 `A[0] ~ A[x]` 与 `B[0] ~ B[y]` 的最大连线数为 `f(x, y)`，那么对于任意位置的 `f(i, j)` 而言：

- 如果 `A[i] == B[j]`，即 `A[i]` 和 `B[j]` 可连线，此时 `f(i, j) = f(i - 1, j - 1) + 1`
- 如果 `A[i] != B[j]`，即 `A[i]` 和 `B[j]` 不可连线，此时最大连线数取决于 `f(i - 1, j)` 和 `f(i, j - 1)` 的较大值


```python
class Solution(object):
    def maxUncrossedLines(self, A, B):
        """
        :type A: List[int]
        :type B: List[int]
        :rtype: int
        """
        a_length = len(A)
        b_length = len(B)
        
        res = [[0 for _ in range(b_length + 1)] for _ in range(a_length + 1)]
        
        for i in range(a_length):
            for j in range(b_length):
                if A[i] == B[j]:
                    res[i + 1][j + 1] = res[i][j] + 1
                else:
                    res[i + 1][j + 1] = max(res[i + 1][j], res[i][j + 1])
        
        return res[a_length][b_length]
```

----

## 第 136 场周赛

点击前往：[第 136 场周赛](https://leetcode-cn.com/contest/weekly-contest-136)

### 5055. 困于环中的机器人

[原题链接](https://leetcode-cn.com/contest/weekly-contest-136/problems/robot-bounded-in-circle/)

#### 思路

模拟机器人走位，重复指令 4 次，如果回到原点就说明在绕圈。

```python
class Solution(object):
    def isRobotBounded(self, instructions):
        """
        :type instructions: str
        :rtype: bool
        """
        instructions *= 4
        
        forward_list = [(0, 1), (-1, 0), (0, -1), (1, 0)]
        forward = 0
        
        x, y = 0, 0
        
        for i in instructions:
            if i == "L":
                forward += 1
            if i == 'R':
                forward += 3
            forward %= 4
            
            if i == "G":
                x, y = x + forward_list[forward][0], y + forward_list[forward][1]
            
        return x == 0 and y ==0
```

### 5056. 不邻接植花

[原题链接](https://leetcode-cn.com/contest/weekly-contest-136/problems/flower-planting-with-no-adjacent/)

#### 思路

填色问题。

一开始的思路错了，想按照连接顺序从小到大直接用 1, 2, 3, 4 ... 填色。正确的思路应该是先找到要填色花园 i 的其他相邻花园的颜色，然后找一个还没用过的颜色给当前花园上色。


```python
class Solution(object):
    def gardenNoAdj(self, N, paths):
        """
        :type N: int
        :type paths: List[List[int]]
        :rtype: List[int]
        """
        info = dict()
        res = [None for _ in range(N)]
        mark = [0 for _ in range(N)]
        
        for p in paths:
            a = p[0] - 1
            b = p[1] - 1
            if a not in info:
                info[a] = set()
            if b not in info:
                info[b] = set()
            info[a].add(b)
            info[b].add(a)
        
        #print info
        
        def dfs(i):
            tmp = set()
            if i in info:
                for other in info[i]:
                    tmp.add(res[other])
            for c in range(4):
                c = c + 1
                if c not in tmp:
                    res[i] = c
                    break
                    

        for i in range(N):
            if res[i] is None:
                dfs(i)
        
        return res
```

----

一开始写的智障代码，思路错误 + 超时。

```python
class Solution(object):
    def gardenNoAdj(self, N, paths):
        """
        :type N: int
        :type paths: List[List[int]]
        :rtype: List[int]
        """
        info = dict()
        res = [1 for _ in range(N)]
        mark = [0 for _ in range(N)]
        
        if len(paths) == 0:
            return res
        
        for p in paths:
            a = p[0]
            b = p[1]
            
            if a not in info:
                info[a] = set()
            if b not in info:
                info[b] = set()
                
            info[a].add(b)
            info[b].add(a)
            
        for i in range(N):
            index = i + 1
            if info.has_key(index):
                for g in info[index]:
                    if index == 5:
                        print "g=", g
                    if g > index and res[g - 1] == res[i]:
                        if res[mark[g - 1]] + 1 != res[i]:
                            res[g - 1] = res[mark[g - 1]] + 1
                        else:
                            res[g - 1] = res[i] + 1
                    mark[g - 1] = index - 1
        
        return res
```

----

## 第 137 场周赛

点击前往 [第 137 场周赛](https://leetcode-cn.com/contest/weekly-contest-137)

**完成情况**

半小时完成前两题。然而后面一小时没有产出了，看了 3、4 两题题目后没有思绪，并且看到第三题很少有人完成后，思绪又在两道题之前飘忽不定……

<img src="_img/weekly-137.png">

在第一题中也发生了审题不清的情况，并且没有好好测试就着急提交了，导致两次出错。

**总结**

- 以后吃饱再参加竞赛吧……

### 1048. 最长字符串链

[原题链接](https://leetcode-cn.com/contest/weekly-contest-137/problems/longest-string-chain/)

#### 思路

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

### 5063. 最后一块石头的重量

[原题链接](https://leetcode-cn.com/contest/weekly-contest-137/problems/last-stone-weight/)

#### 思路

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

### 5064. 删除字符串中的所有相邻重复项

[原题链接](https://leetcode-cn.com/contest/weekly-contest-137/problems/remove-all-adjacent-duplicates-in-string/)

#### 思路

用栈实现，类似匹配括号的题目。

如果入栈的字符和栈顶元素相等，则匹配为重复项，弹出栈顶元素；如果不相等则入栈。

#### 复杂度

时间复杂度和空间复杂度都是 `O(n)`。

#### 编码实现

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

----

## 第 138 场周赛

点击前往 [第 138 场周赛](https://leetcode-cn.com/contest/weekly-contest-138)

**完成情况**

半小时完成前两题。第三题没看懂，第四题最后没有调出来。

<img src="_img/weekly-138.png">

### 1051. 高度检查器

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/height-checker/)

#### 思路

排序 + 对比。

```python
class Solution(object):
    def heightChecker(self, heights):
        """
        :type heights: List[int]
        :rtype: int
        """
        res_heights = sorted(heights)
        cnt = 0
        
        for i in range(len(heights)):
            if heights[i] != res_heights[i]:
                cnt += 1
                
        return cnt
```

### 1052. 爱生气的书店老板

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/grumpy-bookstore-owner/)

#### 思路

求生气的时候 X 段时间内能产生的最大客流量。

结果 = 已经可以获得的客流量 + 生气的时候 X 段时间内能产生的最大客流量

```python
class Solution(object):
    def maxSatisfied(self, customers, grumpy, X):
        """
        :type customers: List[int]
        :type grumpy: List[int]
        :type X: int
        :rtype: int
        """
        happy_cnt = 0
        
        unhappy_list = []
        
        customers_cnt = len(customers)
        
        for i in range(customers_cnt):
            if grumpy[i] == 1:
                unhappy_list.append(customers[i])
            else:
                unhappy_list.append(0)
                happy_cnt += customers[i]
        
        pre = 0
        for i in range(X):
            pre += unhappy_list[i]
        
        max_unhappy_cnt = pre
        for i in range(X, customers_cnt):
            cur = pre - unhappy_list[i - X] + unhappy_list[i]
            max_unhappy_cnt = max(max_unhappy_cnt, cur)
            pre = cur
            
        return happy_cnt + max_unhappy_cnt
```

### 1053. 交换一次的先前排列

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/previous-permutation-with-one-swap/)

#### 思路

1. 从后向前，找到第一个非递减的数（第一个产生递增行为的数），标记下标为 `i`
2. 从后向前遍历到下标 `i`，找到第一个小于 `i` 的数字，标记下标为 `j`
3. 交换 `A[i]` 和 `A[j]`

但其实第三个测试用例是错的。。。比赛的时候看了半天没看懂。。说什么好

```python
class Solution(object):
    def prevPermOpt1(self, A):
        """
        :type A: List[int]
        :rtype: List[int]
        """
        length = len(A)

        for i in range(length - 2, -1, -1):
            if A[i] > A[i + 1]:
                break
        else:
            return A
    
        
        for j in range(length - 1, i, -1):
            if A[j] < A[i]:
                break
        
        A[i], A[j] = A[j], A[i]
        
        return A
```

### 1054. 距离相等的条形码

[原题链接](https://leetcode-cn.com/contest/weekly-contest-138/problems/distant-barcodes/)

#### 思路

1. 按出现次数对数字进行排列
2. 把出现最多的数排在奇数位置
3. 然后剩余数字依次填满剩余奇数位和偶数位

```python
class Solution(object):
    def rearrangeBarcodes(self, barcodes):
        """
        :type barcodes: List[int]
        :rtype: List[int]
        """
        barcode_map = dict()
        
        for barcode in barcodes:
            if barcode not in barcode_map:
                barcode_map[barcode] = 0
            barcode_map[barcode] += 1
            
        barcode_sort = sorted(barcode_map.items(), key=lambda x: x[1], reverse=True)
            
        barcode_length = len(barcodes)
        res = [0 for _ in range(barcode_length)]
        
        index = 0
        while len(barcode_sort):
            cur = barcode_sort[0]
            cur_num = cur[0]
            cur_cnt = cur[1]
            
            while cur_cnt > 0:
                if index % 2 == 0 and index > barcode_length - 1:
                    index = 1
                res[index] = cur_num
                cur_cnt -= 1
                index += 2
                
            del barcode_sort[0]
            
        return res    
```

----

## 第 143 场周赛

### 1103. 二叉树寻路

[原题链接](https://leetcode-cn.com/problems/path-in-zigzag-labelled-binary-tree/)

#### 思路

根据二叉树的特性和给定的 `label` 可以求出 `label` 值所在的层数 `layer`：

```python
layer = int(math.sqrt(label)) + 1
```

知道层数后可以知道该层元素的构成。因为二叉树是按「之」字型打印的，所以偶数行是反序列表，奇数行是正序列表。因此元素构成为：

```python
begin = 2**(layer - 1)
end = 2**layer - 1

if layer % 2 == 1:
    elements = range(begin, end)
else:
    elments = range(begin - 1, end - 1, -1)
```

知道元素构成后可以得知 `label` 的下标 `cur_index`：

```python
if layer % 2 == 0:
    # 偶数行，反序
    cur_index = end - label
else:
    # 奇数行
    cur_index = label - begin
```

既而算出父节点下标：

```python
parent_index = cur // index
```

循环此过程。

总结一下：

1. 算出当前 `label` 所在层，可得知该层元素构成与 `label` 下标；
2. 根据此信息继续推出其父节点所在层、该层元素构成与父节点下标，因此可以知道父节点的值；
3. 重复该过程。

```python
import math

class Solution(object):
    def pathInZigZagTree(self, label):
        """
        :type label: int
        :rtype: List[int]
        """
        layer = int(math.log(label, 2)) + 1
        # print layer
        res = []
        begin = 2**(layer - 1)
        end = 2**layer - 1
        if layer % 2 == 0:
            # 偶数行，反序
            cur_index = end - label
        else:
            # 奇数行
            cur_index = label - begin
            
        while layer > 0:
            
            begin = 2**(layer - 1)
            end = 2**layer
            # print begin, end, layer, cur_index
            if layer % 2 == 1: 
                cur_label = range(begin, end)[cur_index]
            else:
                # print range(end - 1, begin - 1, -1)
                cur_label = range(end - 1, begin - 1, -1)[cur_index]
            res.append(cur_label)
            
            layer -= 1
            cur_index = cur_index // 2
            
        return res[::-1]
```

----

## 第 146 场周赛

### 5130. 等价多米诺骨牌对的数量

[原题链接](https://leetcode-cn.com/contest/weekly-contest-146/problems/number-of-equivalent-domino-pairs/)

#### 思路

用一个二维数组存储多米诺骨牌出现的次数，`mark[i][j]` 代表 `[i, j]` 出现次数。

当我们遇到一张新牌 `[x, y]` 时，可以通过 `mark[x, y]` 和 `mark[y, x]` 得知 `[x, y]` 与 `[y, x]` 牌型出现的次数，从而得出等价骨牌对为 `mark[x, y] + mark[y, x]`。

注：当 `i == j` 时，此时 `[i, j]` 和 `[j, i]` 为同一张牌，无需重复计算 `[j, i]` 出现的情况。

```python
class Solution:
    def numEquivDominoPairs(self, dominoes: List[List[int]]) -> int:
        mark = [[0 for _ in range(10)] for _ in range(10)]
        res = 0
        for dominoe in dominoes:
            i = dominoe[0]
            j = dominoe[1]
            if mark[i][j] > 0:
                res += mark[i][j]
            if i != j:
                if mark[j][i] > 0:
                    res += mark[j][i]
            mark[i][j] += 1
        return res
```

----

## 第 152 场周赛

[点击前往第 152 场周赛](https://leetcode-cn.com/contest/weekly-contest-152)

### 5173. 质数排列

[原题链接](https://leetcode-cn.com/contest/weekly-contest-152/problems/prime-arrangements/)

#### 思路

找到 n 以内的质数个数，假设为 `x`。题目所要求的结果其实就是：**`x` 个质数在 `x` 个位置上的全排列和 `n - x` 个非质数在 `n - x` 个位置上全排列的和**。

```python
class Solution:
    def numPrimeArrangements(self, n: int) -> int:
        def is_prime(n):
            if n == 1:
                return False
            if n == 2:
                return True
            for i in range(2, n):
                if n % i == 0:
                    return False
            return True
        
        def get_multi(n):
            multi = 1
            for i in range(1, n + 1):
                multi *= i
            return multi
        
        prime_count = 0
        for j in range(1, n + 1):
            if is_prime(j):
                prime_count += 1
        
        return (get_multi(prime_count) * get_multi(n - prime_count)) % (10**9 + 7)
```

### 5174. 健身计划评估

[原题链接](https://leetcode-cn.com/contest/weekly-contest-152/problems/diet-plan-performance/)

#### 思路

一开始误解了题目的意思，直接把 `calories` 分成了 `length / k` 份，计算每份的和，再与 `lower` 和 `upper` 进行比较。

然而正确的姿势应该是：`1 ~ k` 天为第一个周期，`2 ~ k + 1` 天为第二个周期……

```python
class Solution:
    def dietPlanPerformance(self, calories: List[int], k: int, lower: int, upper: int) -> int:
        c_length = len(calories)
        n = c_length // k
        score = 0
        s = sum(calories[:k])
        if s > upper:
            score += 1
        if s < lower:
            score -= 1
        
        for i in range(k, c_length):
            s = s + calories[i] - calories[i - k]
            if s > upper:
                score += 1
            if s < lower:
                score -= 1
                
        return score
```

### 5175. 构建回文串检测

[原题链接](https://leetcode-cn.com/contest/weekly-contest-152/problems/can-make-palindrome-from-substring/)

#### 思路

比赛的时候写这道题超时了，因为每次遍历 `queries` 都将截取的字符串所包含的字母进行了计算，这样复杂度到达了 `O(n^2)`，而题目的数据范围是 `1 <= s.length, queries.length <= 10^5`，显然无法通过。

优化方案是：把 26 个字母出现的次数通过遍历一次 `s` 进行计算，用一个辅助二维数组 `c_count` 进行存储。`c_count[i][j]` 代表从字符串开始处到位置 `i` 处第 `j` 个（按字母表顺序）字母出现的次数。

那么如果我们截取一个 `[left, right]` 字符串，我们显然可以得到位置 `j` 的字母出现的次数为：`c_count[right][j] - c_count[left - 1][i]`。

根据一个字符串中字母出现的次数，我们可以判断出这个字符串是否为回文字符串。

- 字符串长度为偶数：出现的字母必须都要是偶数次
- 字符串长度为奇数：允许其中一个字母出现奇数次，其余字母都要出现偶数次

```python
class Solution:
    def canMakePaliQueries(self, s: str, queries: List[List[int]]) -> List[bool]:
        s_length = len(s)
        q_length = len(queries)
        # 预留一个位置放置 0
        c_count = [[0 for _ in range(26)] for _ in range(s_length + 1)]
        
        # 计算字母出现的个数
        for i in range(s_length):
            c = s[i]
            if i != 0:
                # 浅拷贝
                c_count[i + 1] = c_count[i][:]
            tmp = ord(c) - ord('a')
            c_count[i + 1][tmp] += 1
            
        answer = [False for _ in range(q_length)]
        # 遍历 queries
        for i in range(q_length):
            # 要减去的是 left 左移一位的数
            left = queries[i][0]
            right = queries[i][1]
            length = right - left + 1
            k = queries[i][2]
            # 如果只有一个字母，肯定是回文
            if left == right:
                answer[i] = True
                continue
            right += 1
            
            odd = 0 #奇数
            even = 0 #偶数
            for j in range(26):
                tmp = c_count[right][j] - c_count[left][j]
                if tmp == 0:
                    continue
                if tmp % 2 == 0:
                    even += 1
                else:
                    odd += 1
            
            if length % 2 == 0:
                # 长度是偶数
                if odd == 0:
                    answer[i] = True
                else:
                    if odd // 2 + odd % 2 <= k:
                        answer[i] = True
            else:
                # 长度是奇数
                if odd == 1:
                    answer[i] = True
                else:
                    if odd // 2 <= k:
                        answer[i] = True
            
        return answer
```

### 1178. 猜字谜

[原题链接](https://leetcode-cn.com/contest/weekly-contest-152/problems/number-of-valid-words-for-each-puzzle/)

#### 思路

一般会想到的思路：遍历 `puzzles`，在每次遍历中再遍历 `words`，寻找到可行的谜底。但 `1 <= words.length <= 10^5` 且 `1 <= puzzles.length <= 10^4`，这样做的话显然是会超时的。

我们注意到 `puzzles[i].length == 7`，那么 `puzzles[i]` 的谜底不会超过 2^7 = 128 因此我们可以直接枚举出 `puzzles[i]` 对应的谜底，然后遍历所有的谜底，看该谜底是否在 `words` 出现。

```python
class Solution:
    def findNumOfValidWords(self, words: List[str], puzzles: List[str]) -> List[int]:
        # word 统计
        word_dict = dict()
        for word in words:
            tmp = ''.join(sorted(list(set(word))))
            if len(tmp) <= 7:
                word_dict[tmp] = word_dict.get(tmp, 0) + 1
        
        p_length = len(puzzles)
        answer = [0 for _ in range(p_length)]
        p_list = [[] for _ in range(p_length)]
        # 算出 puzzle 对应的谜面集合
        for i in range(p_length):
            puzzle = puzzles[i]
            p_list[i] = [puzzle[0]]
            for c in puzzle[1:]:
                p_list[i] += [''.join(sorted(s + c)) for s in p_list[i]]
        
        for i in range(p_length):
            answers = p_list[i]
            for ans in answers:
                answer[i] += word_dict.get(ans, 0)
                
        return answer      
```