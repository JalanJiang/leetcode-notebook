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

## 973. 最接近原点的 K 个点

[原题链接](https://leetcode-cn.com/problems/k-closest-points-to-origin/)

本质是排序。按照欧几里得距离从小到大对 `points` 进行升序排序，然后取出前 K 个点即可。

其实就是三个步骤：

1. 计算距离
2. 排序
3. 取 K 个

### 解一：偷懒大法

直接用系统提供的排序函数进行排序。

```python
class Solution:
    def kClosest(self, points: List[List[int]], K: int) -> List[List[int]]:
        distance = []
        res = []
        for i in range(len(points)):
            point = points[i]
            dis = point[0]**2 + point[1]**2
            distance.append([i, dis])
            
        distance.sort(key=lambda x:x[1])
        
        for i in range(K):
            res.append(points[distance[i][0]])
        return res
```

上面写的比较啰嗦，可以用列表生成式简化一下：

```python
class Solution:
    def kClosest(self, points: List[List[int]], K: int) -> List[List[int]]:
        points.sort(key=lambda x: x[0]**2 + x[1] ** 2)
        return points[:K]
```

### 解二：快速排序

这里的快速排序无需使整个数组有序，只需要筛选出最小的 K 个值即可。

假设第一次排序后，哨兵值 `pivot` 将原数组分为两个部分：

1. 左侧部分，元素值均小于 `pivot`，假设下标范围是 `[begin, i - 1]`，长度为 `left_length`
2. 右侧部分，元素值均大于或等于 `pivot`，假设下标范围是 `[i + 1, end]`，长度为 `right_length`

此时：

- 如果 `left_length >= K`，最小的 `K` 个值均在左侧，因此下轮递归只需对左侧部分进行排序
- 如果 `left_length < K`，我们已经获得了 `left_length` 个最小值，因此下轮递归只需对右侧部分进行排序

该算法的时间复杂度为 O(n), 空间复杂度为 O(1):

1.空间复杂度不用多说， 我们直接在原数组上做操作，所以不用开出多余的空间，故空间复杂度为O(1)

2.时间复杂度为 O(n): 在理想的情况下，我们每次定位到的 `pivot` 都为 end - start 的一半的话。那么下一次查找 `pivot` 的时间就为上一次的 1/2。

那么，最终的时间复杂度就为： O(n + n/2 + n/4 + ... + 1) ， 约等于 O(n)。

<!-- tabs:start -->
#### ** Python **

```python
class Solution:
    def kClosest(self, points: List[List[int]], K: int) -> List[List[int]]:
        # 计算欧几里得距离
        distance = lambda i: points[i][0] ** 2 + points[i][1] ** 2
        
        def work(i, j, K):
            if i > j:
                return
            # 记录初始值
            oi, oj = i, j
            # 取最左边为哨兵值
            pivot = distance(oi)
            while i != j:
                while i < j and distance(j) >= pivot:
                    j -= 1
                while i < j and distance(i) <= pivot:
                    i += 1
                if i < j:
                    # 交换值
                    points[i], points[j] = points[j], points[i] 
                
            # 交换哨兵
            points[i], points[oi] = points[oi], points[i]
            
            # 递归
            if K <= i - oi + 1:
                # 左半边排序
                work(oi, i - 1, K)
            else:
                # 右半边排序
                work(i + 1, oj, K - (i - oi + 1))
                
        work(0, len(points) - 1, K)
        return points[:K]
```

#### ** PHP **

```php
class Solution {

    /**
     * @param Integer[][] $points
     * @param Integer $K
     * @return Integer[][]
     */
    function kClosest($points, $K) {
        $length = count($points);
        $this->quickSelect($points, 0, $length - 1, $K);
        return array_slice($points, 0, $K);
    }
    
    // 快速选择
    function quickSelect(&$points, $i, $j, $k) {
        
        // 递归结束条件
        if ($i > $j) {
            return;
        }
        
        $begin = $i;
        $end = $j;
        // 哨兵
        $pivot = $this->getDistance($points, $begin);
        
        while ($i != $j) {
            while ($i < $j && $this->getDistance($points, $j) >= $pivot) {
                $j--;
            }
            while ($i < $j && $this->getDistance($points, $i) <= $pivot) {
                $i++;
            }
            if ($i < $j) {
                // 交换
                $tmp = $points[$i];
                $points[$i] = $points[$j];
                $points[$j] = $tmp;
            }
        }
        
        // 交换哨兵
        $tmp = $points[$begin];
        $points[$begin] = $points[$i];
        $points[$i] = $tmp;
        
        // 递归
        if ($i - $begin + 1 >= $k) {
            $this->quickSelect($points, $begin, $i - 1, $k);
        } else {
            $this->quickSelect($points, $i + 1, $end, $k - ($i - $begin + 1));
        }
    }
    
    // 计算欧几里得距离
    function getDistance($points, $x) {
        return $points[$x][0]*$points[$x][0] + $points[$x][1] * $points[$x][1];
    }
}
```

#### ** Java **

```java
class Solution {
     public int[][] kClosest(int[][] points, int K) {
        int start = 0;
        int end = points.length - 1;
        while (start < end) {
            # 计算欧几里得距离
            int index = patition(points, start, end);
            if (index == K) {
                break;
            } else if (index < K) {
                start = index + 1;
            } else {
                end = index - 1;
            }
        }

        return Arrays.copyOf(points, K);
    }

    private int patition(int[][] points, int start, int end) {
        int i = start;
        int j = end + 1;
        int mid = distance(points[i][0], points[i][1]);
        while (true) {
            while (distance(points[++i][0], points[i][1]) < mid && i < end);
            while (distance(points[--j][0], points[j][1]) > mid && j > start);
            if (i >= j) {
                break;
            }
            swap(points, i, j);
        }
        swap(points, start, j);
        return j;
    }

    private int distance(int a, int b) {
        return a * a + b * b;
    }

    private void swap(int[][] points, int a, int b) {
        int[] temp = points[a];
        points[a] = points[b];
        points[b] = temp;
    }
}
```

<!-- tabs:end -->

### 解三：堆排序

这个问题的本质其实就是对于点到原点的距离，求 Top K 元素。那么，除了排序的方法，以及快速排序以外，还可以利用 `堆` 来得到 Top K 的元素。

```java
class Solution {
    public int[][] kClosest(int[][] points, int K) {
        // 在 `Java` 里面，可以利用优先队列：PriorityQueue 来处理，其内部实现是堆。
        Queue<int[]> priorityQueue = new PriorityQueue<>(K, (o1, o2) -> o1[0] * o1[0] + o1[1] * o1[1] - o2[0] * o2[0] - o2[1] * o2[1]);
        for (int[] point : points) {
            priorityQueue.add(point);
        }
        int[][] result = new int[K][2];
        for (int i = 0; i < K; i++) {
            result[i] = priorityQueue.poll();
        }
        return result;
    }
}
```