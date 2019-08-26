## 第 3 场双周赛

### 5022. 长度为 K 的无重复字符子串

[原题链接](https://leetcode-cn.com/contest/biweekly-contest-3/problems/find-k-length-substrings-with-no-repeated-characters/)

#### 思路

维护一个长度为 `K` 的滑动窗口。

我是这样考虑的。先初始化一些用来辅助的数据结构：

- `s_map` 用于存储字符出现的次数
- `repeats` 用于标记字符是否为重复字符
- `res` 记录结果

然后：

1. 先判断 `S` 的长度是否大于等于 `K`，否则直接返回 0；
2. 先处理前 `K` 个元素：记录元素出现的次数、是否有重复元素，并计算 `res` 的值；
3. 维护一个长度为 `K` 的滑动窗口，遍历 `S`：
   1. 处理要移除的元素 `first`；
   2. 处理要加入的元素 `cur`；
   3. 判断新产生的字符串是否有重复元素。

附上代码：

```python
class Solution(object):
    def numKLenSubstrNoRepeats(self, S, K):
        """
        :type S: str
        :type K: int
        :rtype: int
        """
        s_length = len(S)
        if K > s_length:
            return 0
        
        s_map = dict()
        repeats = dict()
        res = 0
        
        is_repeat = False
        # 先处理前 K 个元素
        for i in range(K):
            c = S[i]
            if c in s_map:
                if s_map[c] > 0:
                    is_repeat = True
                    repeats[c] = True
                s_map[c] += 1
            else:
                s_map[c] = 1
                        
        if not is_repeat:
            res += 1
        
        for i in range(K, s_length):
            # 取出要排除掉的第一个元素
            first = S[i - K]
            # 将该元素的出现次数减 1
            s_map[first] -= 1
            # 如果该元素的出现次数已经等于 1 或 0，判断该元素是否为重复的元素，如果是则把该元素从重复元素中移除
            if s_map[first] <= 1 and first in repeats:
                repeats.pop(first)
            
            # 取出当前要加入字符串的元素
            cur = S[i]
            # 该元素出现次数加 1
            s_map[cur] = s_map.get(cur, 0) + 1
            # 如果出现次数大于 1，则加入重复出现元素的字典中
            if s_map[cur] > 1:
                repeats[cur] = True
            # 判断是否有重复元素，如果没有则把结果加 1
            if len(repeats) == 0:
                res += 1
            
        return res
```

#### 复杂度

- 时间 `O(n)`
- 空间 `O(n)`

----

## 第 7 场双周赛

[点击前往](https://leetcode-cn.com/contest/biweekly-contest-7)

### 5059. 单行键盘

[原题链接](https://leetcode-cn.com/contest/biweekly-contest-7/problems/single-row-keyboard/)

#### 思路

1. 记录字母在 `keyboard` 中对应的下标
2. 循环 `word`，将相邻字母对应的下标相减结果全部相加

<!-- tabs:start -->
#### ** Python **

```python
class Solution:
    def calculateTime(self, keyboard: str, word: str) -> int:
        d = dict()
        for i in range(len(keyboard)):
            key = keyboard[i]
            d[key] = i
        res = 0
        pre = 0
        for i in range(len(word)):
            w = word[i]
            res += abs(pre - int(d[w]))
            pre = d[w]
        return res
```

#### ** Java **

```java
class Solution {
    public int calculateTime(String keyboard, String word) {
        if (keyboard == null || keyboard.length() != 26) return 0;
        if (word == null || word.length() <= 0) return 0;
        if (word.length() <= 1) return 1;

        int[] chars = new int[26];

        for (int i = 0; i < keyboard.length(); i++) {
            chars[keyboard.charAt(i) - 'a'] = i;
        }

        int result = 0;
        int lastIndex = 0;
        for (int i = 0; i < word.length(); i++) {
            char c = word.charAt(i);
            int index = chars[c - 'a'];
            result += Math.abs(index - lastIndex);
            lastIndex = index;
        }

        return result;
    }
}
```

<!-- tabs:end -->

### 5061. 设计文件系统

[原题链接](https://leetcode-cn.com/contest/biweekly-contest-7/problems/design-file-system/)

#### 思路

- `create` 方法：
    1. 判断传入路径的所有父路径是否存在，若有不存在的父路径：返回 `false`
    2. 判断当前传入路径是否存在
        - 存在：返回 `false`
        - 不存在：设置路径对应的 `value` 值
- `get` 方法：
  - 路径存在：返回 `value`
  - 路径不存在：返回 `-1ß`

<!-- tabs:start -->
#### ** Python **

```python
class FileSystem:

    def __init__(self):
        self.path_val = dict()

    def create(self, path: str, value: int) -> bool:
        path_list = path.split("/")[1:]
        
        if len(path_list) == 0:
            # 非法路径
            return False
        elif len(path_list) == 1:
            # 不存在父路径，直接验证是否存在
            if path in self.path_val:
                return False
            else:
                self.path_val[path] = value
                return True
        else:
            # 验证父路径是否存在
            parent_path = ''
            for i in range(len(path_list) - 1):
                parent_path += '/' + path_list[i]
                # 父路径不存在，返回 False
                if parent_path not in self.path_val:
                    return False
            self.path_val[path] = value
            return True

    def get(self, path: str) -> int:
        if path in self.path_val:
            return self.path_val[path]
        return -1


# Your FileSystem object will be instantiated and called as such:
# obj = FileSystem()
# param_1 = obj.create(path,value)
# param_2 = obj.get(path)
```

#### ** Java **

```java
class FileSystem {

    private Map<String, Integer> map;

    public FileSystem() {
        map = new HashMap<>();
    }

    public boolean create(String path, int value) {
        boolean isChild = path.indexOf('/') != path.lastIndexOf('/');

        if (!isChild) {
            if (map.containsKey(path)) return false;
            map.put(path, value);
            return true;
        }

        String parent = path.substring(0, path.lastIndexOf('/'));
        if (map.containsKey(parent)) {
            if (map.containsKey(path)) return false;
            map.put(path, value);
            return true;
        } else {
            return false;
        }
    }

    public int get(String path) {
        return map.getOrDefault(path, -1);
    }
}
```

<!-- tabs:end -->

### 5062. 连接棒材的最低费用

[原题链接](https://leetcode-cn.com/contest/biweekly-contest-7/problems/minimum-cost-to-connect-sticks/)

根据贪心的思想：每次选择当前数据中最小的两个 `棒材` 进行拼接，那么当前需要支付的费用是最少的。然后, 将拼接完的 `棒材` 放回到数据中, 依次类推操作。则，我们每次拼接 `棒材` 所需要支付的费用都是当前最少的。

由于， 每次我们都需要取最小的两个 `棒材` 进行拼接，拼接完后需要把拼接后的 `棒材` 放回数据中。所以需要每次都进行排序。那么，我们可以考虑用堆来维护这个数据组。

下面来看一个实例：

- 输入：sticks = [1,8,3,5]
- 输出：30

那么排序后的 `棒材` 为： [1, 3, 5, 8]。

1. 第一次，取出 1、 3 两个 `棒材` 拼接，得到长度为 4 的 `棒材`，当前总花费为： 4。放回堆中之后，堆里的数据为：[4, 5, 8]。

2. 第二次，取出 4、5 两个 `棒材` 拼接，得到长度为 9 的 `棒材`， 当前总花费为： 4 + 9 = 13。放回堆中之后，堆里的数据为：[8, 9]。

3. 第三次，取出最后的 8、9 两个 `棒材` 拼接，得到长度为 17 的 `棒材`，当前总花费为： 13 + 17 = 30。得到最终的结果。

<!-- tabs:start -->
#### ** Python **

```python
class Solution:
    def connectSticks(self, sticks: List[int]) -> int:
        length = len(sticks)
        for i in reversed(range(0, length // 2)):
            self.adjustHeap(sticks, i, length)
        
        count = 0
        res = 0
        # for j in reversed(range(0, length)):
        j = length - 1
        while j != 0:
            # print(sticks[0])
            if count == 0:
                # 拿出第一个节点
                # print("first = ", sticks[0])
                first = sticks[0]
                sticks[0], sticks[j] = sticks[j], sticks[0]
                length -= 1
                j -= 1
            elif count == 1:
                # print("second = ", sticks[0])
                tmp = first + sticks[0]
                res += tmp
                # tmp 入队
                sticks[0] = tmp
            else:
                # 取两个点
                f = sticks[0]
                sticks[0], sticks[j] = sticks[j], sticks[0]
                length -= 1
                j -= 1
                self.adjustHeap(sticks, 0, length)
                s = sticks[0]
                tmp = f + s
                res += tmp
                sticks[0] = tmp
            count += 1
            # 调整堆
            self.adjustHeap(sticks, 0, length)
        return res
            
    
    def adjustHeap(self, nums, i, length):
        while True:
            k = i * 2 + 1
            if k >= length:
                return 
            if k + 1 < length and nums[k + 1] < nums[k]:
                k = k + 1
            if nums[k] < nums[i]:
                nums[i], nums[k] = nums[k], nums[i]
                i = k
            else:
                return
```

#### ** Java **

```java
class Solution {
    public int connectSticks(int[] sticks) {
        // 边界值处理
        if (sticks == null || sticks.length <= 0) return 0;
        if (sticks.length <= 1) return sticks[0];

        // 用优先队列作为堆
        Queue<Integer> priority = new PriorityQueue<>();

        // 现将数据存放到堆中
        for (int stick : sticks) {
            priority.add(stick);
        }

        int result = 0;
        while (priority.size() >= 2) {
            // 每次从堆中取出两个最小的数据进行求和
            int sum = priority.poll() + priority.poll();
            // 结果放回堆中
            priority.add(sum);
            result += sum;
        }
        return result;
    }
}
```

<!-- tabs:end -->

### 1168. 水资源分配优化

[原题链接](https://leetcode-cn.com/contest/biweekly-contest-7/problems/optimize-water-distribution-in-a-village/)

使用最小生成树，把**挖水井看作房子和 0 号房子的连线**。

#### 最小生成树基本概念

如果连通图是一个带权图，则其生成树中的边也带权，生成树中**所有边的权值之和称为生成树的代价**。

最小生成树(Minimum Spanning Tree) ：**带权连通图中代价最小的生成树称为最小生成树**。

#### Kruskal 算法主要思想

1. 将图的边按权值大小**从小到大**依次选取
2. 选取权值最小的边 edge，假设构成该边的两个点为 `(point1, point2)`，如果 `point1` 和 `point2` 
已在一个连通图中，则舍弃该边；否则讲该边加入最小生成树中
3. 重复步骤 2，直到构成最小生成树为止

#### 初始化辅助空间

初始化两个字典：

1. 定义字典 `v`，`v[i] = x` 表示第 `i` 号房的**连通分量**为 `x`。若两个房子的连通分量相同，则说明这两个房子在一个图中
2. 定义字典 `r`，`r[j] = y` 表示连通分量 `j` 对应的连通等级为 `y`。**作为连接末端时等级需要 +1**

#### 定义函数

1. `init_set()`：用于初始化辅助空间
  - 房子的初始连通分量等于房号：`v[house_num] = house_num`
  - 房子的初始连通等级等于 0：`r[house_num] = 0`
2. `find(house)`：用于获取房子的连通分量
  - 当 `v[house] != house` 时，即房子的连通分量不等于房号时，说明该房子已连入某连通图内，需要**沿着该连通分量找到该连通图的末端**，因此进行回调 `find(v[house])`，直到找到末端为止
3. `merge(house1, house2)`：用于将两个房子合并到一个连通图中
  - 如果 `v[house1] != v[house2]`，即两个房子的连通分量不同，说明两个房子不在一个连通图里，此时可以合并
  - 若可以合并，记 `v[house1]` 为 `v1`，记 `v[house2]` 为 `v2`，此时需要比较两个房子的连通等级 `r[v1]` 与 `r[v2]`
    - 若 `r[v1] > r[v2]`，即持有连通分量 `v1` 的顶点数量更多，则赋值 `v[v2] = v[v1]`
    - 若 `r[v1] < r[v2]`，即持有连通分量 `v2` 的顶点数量更多，则赋值 `v[v1] = v[v2]`
    - 若 `r[v1] == r[v2]`，`v[v2] = v[v1]` 与 `v[v1] = v[v2]` 皆可，但**需要把被赋值放的连通等级 +1**（`r[v1] += 1` 或 `r[v2] += 1`）

#### 实现

```python
class Solution:
    def minCostToSupplyWater(self, n: int, wells: List[int], pipes: List[List[int]]) -> int:
        
        # 记录节点的连通分量
        v = dict()
        # 记录节点的连通等级
        r = dict()
        
        # 初始化
        def init_set():
            for house in range(n + 1):
                v[house] = house
                r[house] = 0 # 初始连通等级都是0
                
        # 查找节点的连通分量
        def find(house):
            if v[house] != house:
                # 如果连通分量不等于节点本身，表示已被其他连通分量覆盖了，继续寻找整个连通图的连通分量
                v[house] = find(v[house])
            return v[house]
        
        # 合并节点
        def merge(house1, house2):
            v1 = find(house1)
            v2 = find(house2)
            # 连通分量不相等，可以合并
            if v1 != v2:
                if r[v1] > r[v2]: # 2 被合并到 1 中
                    # 等级高的覆盖等级低的
                    v[v2] = v[v1]
                else: # 1 被合并到 2 中
                    v[v1] = v[v2]
                    # 该 else 分支的细分
                    if r[v1] == r[v2]:
                        r[v2] += 1
        
        init_set()
        # 把挖水井当作和 house0 相连
        for i in range(n):
            pipes.append([0, i + 1, wells[i]])
        # 按边长排序
        pipes.sort(key=lambda x: x[2])
        res = 0
        
        for p in pipes:
            house1, house2, edge = p
            if find(house1) != find(house2):
                merge(house1, house2)
                res += edge

        return res
```