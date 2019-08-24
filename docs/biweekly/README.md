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