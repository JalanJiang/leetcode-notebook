## 315. 计算右侧小于当前元素的个数

[原题链接](https://leetcode-cn.com/problems/count-of-smaller-numbers-after-self/)

### 解法一：暴力破解

暴力破解时间复杂度 `O(n^2)` 过高，导致超时。

```python
class Solution(object):
    def countSmaller(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        length = len(nums)
        res = [0 for _ in range(length)]
        
        for i in range(length):
            t = nums[i]
            count = 0
            for j in range(i, length):
                if nums[j] < t:
                    count += 1
            res[i] = count
        
        return res
```

### 解法二：二叉搜索树

利用二叉搜索树的特性：左边节点的值小于等于当前节点值，右边节点的值大于等于当前节点值。

那么实现算法首先要构建一颗二叉搜索树：

1. 定义树的节点结构 `TreeNode`
2. 实现树的节点插入方法 `insertNode`

其中， `insertNode` 方法需要实现几个功能：

1. 构建二叉树
2. 维护每个节点中其左子树节点数量值 `count`：如果新加入的节点需要加入当前节点的左子树，则当前节点的 `count += 1`
3. 计算出新加入节点 `nums[i]` 的 "右侧小于当前元素的个数"，即题目所求值 `res[i]`

附 Python 代码：


```python
# 定义一个树的节点类
class TreeNode(object):
    def __init__(self, val):
        self.left = None
        self.right = None
        self.val = val  # 节点值
        self.count = 0  # 左子树节点数量

class Solution(object):
    def countSmaller(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        length = len(nums)        
        root = None
        # 结果集
        res = [0 for _ in range(length)]
        # nums 反序加入搜索树
        for i in reversed(range(length)):
            root = self.insertNode(root, nums[i], res, i)
        return res
    
    # 往二叉搜索树中插入新的节点
    def insertNode(self, root, val, res, res_index):
        if root == None:
            root = TreeNode(val)
        elif val <= root.val: # 小于当前节点值则放入左子树
            # root 的左侧节点数量值 +1
            root.count += 1
            root.left = self.insertNode(root.left, val, res, res_index)
        elif val > root.val: # 大于当前节点值则放入右子树
            # 计算题目所求的结果
            res[res_index] += root.count + 1
            root.right = self.insertNode(root.right, val, res, res_index)
            
        return root
```

----

这里再解释几个问题：

一、为什么 `nums` 需要反序加入二叉搜索树？

如果反序加入二叉搜索树，对于节点 `nums[i]` 来说，当它加入二叉搜索树时，它右边的元素都已经在树中了，那么它加入时就可以直接确认 "右侧小于当前元素的个数"，也就是说我们可以在构建二叉搜索树的过程中直接求出 `res[i]`。

二、`res[res_index] += root.count + 1` 是为什么？

这句表达式的解释是：

当 `nums[res_index]` 加入 `root` 的右子树时，小于 `nums[res_index]` 的元素个数为：`root` 左子树的所有节点 + `root` 本身。

那个 `+1` 代表的就是 `root` 自己啦。

----

唠唠叨叨的也不知道有没有讲清楚，就这样吧…… `_(┐「ε:)_`

## 324. 摆动排序 II

[原题链接](https://leetcode-cn.com/problems/wiggle-sort-ii/submissions/)

### 思路

1. 将 nums 排序，分为大数列表与小数列表
2. 对列表进行反转
3. 对列表进行穿插求得结果，穿插规则如下：

```
[小数1，大数1，小数2，大数2 ……]
```

```python
class Solution(object):
    def wiggleSort(self, nums):
        """
        :type nums: List[int]
        :rtype: None Do not return anything, modify nums in-place instead.
        """
        nums.sort()
        half = len(nums[::2])
        
        nums[::2], nums[1::2] = nums[:half][::-1], nums[half:][::-1]
```