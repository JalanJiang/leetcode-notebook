## 226. 翻转二叉树

[原题链接](https://leetcode-cn.com/problems/invert-binary-tree/)

### 思路

递归。

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def invertTree(self, root: TreeNode) -> TreeNode:
        if root is None:
            return root
        
        # 翻转左子树
        left = self.invertTree(root.left)
        # 翻转右子树
        right = self.invertTree(root.right)

        root.left, root.right = right, left

        return root
```

## 341. 扁平化嵌套列表迭代器

[原题链接](https://leetcode-cn.com/problems/flatten-nested-list-iterator/)

### 解一：递归法

用一个队列辅助，设计递归函数 `generate(item)`：

- 如果传入的 `item` 为列表，对 `item` 进行遍历，遍历出的元素再进入 `generate()` 进行递归
- 如果传入的 `item` 不为列表（即为 `NestedInteger` 对象），调用 `item.isInteger()` 判断元素是否为整型：
  - 元素为整型：直接加入辅助队列
  - 元素为列表：继续传入 `generate()` 进行递归

```python
# """
# This is the interface that allows for creating nested lists.
# You should not implement it, or speculate about its implementation
# """
#class NestedInteger:
#    def isInteger(self) -> bool:
#        """
#        @return True if this NestedInteger holds a single integer, rather than a nested list.
#        """
#
#    def getInteger(self) -> int:
#        """
#        @return the single integer that this NestedInteger holds, if it holds a single integer
#        Return None if this NestedInteger holds a nested list
#        """
#
#    def getList(self) -> [NestedInteger]:
#        """
#        @return the nested list that this NestedInteger holds, if it holds a nested list
#        Return None if this NestedInteger holds a single integer
#        """

class NestedIterator:
    def __init__(self, nestedList: [NestedInteger]):
        self.data_list = []
        # 构造列表
        self.generate(nestedList)
        # print(self.data_list)

    def generate(self, item):
        """
        构造列表
        """
        # 传入数据，如果是列表，进行递归
        if isinstance(item, list):
            # 如果是列表，循环
            for i in item:
                self.generate(i)
        else:
            if item.isInteger():
                # 是数字，加入队列
                self.data_list.append(item.getInteger())
            else:
                # 是列表，取出列表
                self.generate(item.getList())
    
    def next(self) -> int:
        data = self.data_list[0]
        del self.data_list[0]
        return data
    
    def hasNext(self) -> bool:
         return len(self.data_list) != 0

# Your NestedIterator object will be instantiated and called as such:
# i, v = NestedIterator(nestedList), []
# while i.hasNext(): v.append(i.next())
```

但该方法在构造器中一次性将列表元素全部提取，并不符合「迭代器」的概念。

### 解法二：栈

**用栈模拟递归的过程**。使用一个辅助栈，在 `hasNext()` 时不断处理栈顶的元素。使用 `flag` 标记栈顶是否已处理，并使用 `top` 记录迭代器的下一个数字。

一开始将整个 `nestedList` 压入栈中，每次处理栈时，都将栈顶元素取出：

- 如果栈顶元素是列表：取出列表首个元素，将列表入栈，并将首个元素入栈
- 如果栈顶元素不是列表：
  - 如果栈顶元素是整型：将 `flag` 设置为 `True`，并将该整型赋值给 `top`
  - 如果栈顶元素不是整型：使用 `getList()` 取出列表，并将列表入栈

当栈不为空且 `falg == False` 时，不断循环处理栈顶，直到取出下一个迭代值，将 `flag` 置为 `True`。

```python
# """
# This is the interface that allows for creating nested lists.
# You should not implement it, or speculate about its implementation
# """
#class NestedInteger:
#    def isInteger(self) -> bool:
#        """
#        @return True if this NestedInteger holds a single integer, rather than a nested list.
#        """
#
#    def getInteger(self) -> int:
#        """
#        @return the single integer that this NestedInteger holds, if it holds a single integer
#        Return None if this NestedInteger holds a nested list
#        """
#
#    def getList(self) -> [NestedInteger]:
#        """
#        @return the nested list that this NestedInteger holds, if it holds a nested list
#        Return None if this NestedInteger holds a single integer
#        """

class NestedIterator:
    def __init__(self, nestedList: [NestedInteger]):
        self.stack = []
        # 初始化栈
        self.stack.append(nestedList)
        self.top = 0 # 下一个元素
        self.flag = False # 栈顶是否已处理
    
    def next(self) -> int:
        self.flag = False # 栈顶恢复未处理状态
        return self.top
    
    def hasNext(self) -> bool:
        if len(self.stack) == 0:
            return False

        # 栈顶待处理且栈不为空
        while len(self.stack) > 0 and not self.flag:
            # 取出栈顶
            top = self.stack.pop()
            if isinstance(top, list):
                # 如果是列表，取出首元素，并将两者都压入栈
                if len(top) > 0:
                    first = top[0]
                    del top[0]
                    self.stack.append(top)
                    self.stack.append(first)
            else:
                # 如果不是列表
                if top.isInteger():
                    # 如果是整数，直接取出
                    self.top = top.getInteger()
                    self.flag = True
                else:
                    # 取出 List 压入栈
                    self.stack.append(top.getList())
        return self.flag

# Your NestedIterator object will be instantiated and called as such:
# i, v = NestedIterator(nestedList), []
# while i.hasNext(): v.append(i.next())
```

## 698. 划分为k个相等的子集

[原题链接](https://leetcode-cn.com/problems/partition-to-k-equal-sum-subsets/)

### 思路

递归求解。

拆分的子问题为：凑齐一个和为 `avg` 的子集。

因此，我们先求出真个数组划分为 k 个子集后每个子集的和，即 `avg = sum / k`。

在递归函数中：

- 遍历函数 `nums`（已从大到小排序），逐一**凑**出子集
- 进行下一层递归条件：凑齐一个和为 `avg` 的子集
- 递归函数结束条件：已凑齐 `k` 个子集

```python
class Solution:
    def canPartitionKSubsets(self, nums: List[int], k: int) -> bool:
        length = len(nums)
        if length < k:
            return False
        
        s = sum(nums)
        # 求平均值
        avg, mod = divmod(s, k)
        # 不能整除，返回 False
        if mod:
            return False
        
        # 降序排序
        nums.sort(reverse=True)
        # 存储已经使用的下标
        used = set()
        def dfs(start, value, cnt):
            if value == avg:
                return dfs(0, 0, cnt - 1)
            
            if cnt == 0:
                return True
            
            for i in range(start, length):
                if i not in used and value + nums[i] <= avg:
                    used.add(i)
                    if dfs(i + 1, value + nums[i], cnt):
                        return True
                    used.remove(i)
            
            return False
            
        return dfs(0, 0, k)
```

## 779. 第K个语法符号

[原题链接](https://leetcode-cn.com/problems/k-th-symbol-in-grammar/)

### 思路

通过观察规律可知：**第 N 行第 K 个数是由第 N - 1 行第 (K + 1) / 2 个数得来的**。

并且：

- 当上一行的数字为 0 时，生成的数字是 `1 - (K % 2)`
- 当上一行的数字为 1 时，生成的数字是 `K % 2`

递归函数设计：

- 函数作用：返回第 `N` 行第 `K` 个数
- 当 `N == 1` 时结束递归

#### 具体实现

<!-- tabs:start -->

#### **Python**

```python
class Solution(object):
    def kthGrammar(self, N, K):
        if N == 1:
            return 0
        # 得到第 N 行第 K 位的数字
        return self.kthGrammar(N - 1, (K + 1) // 2) ^ (1 - K % 2)
```

#### **Go**

```go
func kthGrammar(N int, K int) int {
    if N == 1 {
        return 0
    }
    return kthGrammar(N - 1, (K + 1) / 2) ^ (1 - K % 2)
}
```

<!-- tabs:end -->

#### 复杂度

- 时间复杂度：$O(N)$
- 空间复杂度：$O(N)$