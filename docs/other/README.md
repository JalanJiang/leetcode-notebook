## 2019 力扣杯全国秋季编程大赛

[点击前往](https://leetcode-cn.com/contest/season/2019-fall/)

### 1. 猜数字

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/guess-numbers/)

#### 思路

```python
class Solution:
    def game(self, guess: List[int], answer: List[int]) -> int:
        res = 0
        for i in range(3):
            if guess[i] == answer[i]:
                res += 1
        return res
```

### 2. 分式化简

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/deep-dark-fraction/)

#### 思路

是一个不断“取反、相加”的循环。

```python
class Solution:
    def fraction(self, cont: List[int]) -> List[int]:
        length = len(cont)
        res = [cont[length - 1], 1]
        for i in range(length - 2, -1, -1):
            # 取反
            cur = cont[i]
            left = cur * res[0]
            res = [res[1] + left, res[0]]
        
        return res
```

### 3. 机器人大冒险

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/programmable-robot/)

#### 思路

先记录一波数据：

1. 把执行一次命令能走到的点都记录下来，记为 `path`
2. 把命令中 `R` 的次数记作 `px`，`U` 的次数记作 `py`

那么拿到一个点 `(x, y)` 时，求出需要循环执行命令的次数：

```
r = min(x // px, y // py)
```

循环 `r` 次命令后剩余的步数为：`(x - r * px, y - r * py)`。若 `(x - r * px, y - r * py)` 在 `path` 中，则说明可以走到点 `(x, y)`。

```python
class Solution:
    def robot(self, command: str, obstacles: List[List[int]], x: int, y: int) -> bool:
        path = set()
        path.add((0, 0))
        
        px = 0
        py = 0
        for c in command:
            if c == "R":
                px += 1
            else:
                py += 1
            path.add((px, py))
            
        def can_arrive(x, y):
            x_round = x // px
            y_round = y // py
            r = min(x_round, y_round)
            lx = x - r * px
            ly = y - r * py
            if (lx, ly) in path:
                return True
            else:
                return False
        
        if not can_arrive(x, y):
            return False
        
        for ob in obstacles:
            if ob[0] > x or ob[1] > y:
                continue
            if can_arrive(ob[0], ob[1]):
                return False
        
        return True
```

### 4. 覆盖

[原题链接](https://leetcode-cn.com/contest/season/2019-fall/problems/broken-board-dominoes/)

状态压缩 + 动态规划完成状态转移。

一个格子无非只有如下几种情况：

1. 放骨牌
   1. 横着放
   2. 竖着放
2. 不放骨牌
   1. 不是坏格子，选择不放
   2. 是坏格子，不可以放

来看一个 `n = 3, m = 3` 的栗子：

<img src="_img/questions/4-dp-state.png">

我们从上往下、从左往右对所有格子进行遍历。此时我们遍历到黄色格子 `0`，判断该格子能否放置骨牌：

1. 如果格子 `0` 是一个坏掉的格子：不能放置骨牌
2. 如果格子 `0` 不是一个坏格子：
   1. 如果上侧的格子 `3` 是一个未被占用的好格子：格子 `0` 可以竖放骨牌
   2. 如果左侧的格子 `1` 是一个未被占用的好格子：格子 `0` 可以横放骨牌
   3. 如果上侧格子 `3` 和左侧格子 `1` 都无法放置骨牌：格子 `0` 无法放置骨牌

由此，我们可以发现，对于一个格子来说，**它的前 `m` 个格子的状态决定了该格子放置骨牌的可能性**。

#### 状态表示

由于需要记录 `m` 个格子的状态，而一个格子又只有 2 种状态（放骨牌或不放骨牌），很自然地想到可以用**`m` 位二进制数**来表示这 `m` 个格子的状态。

- `0` 表示格子不放置骨牌
- `1` 表示格子放置骨牌 

`m` 个格子就有 $2^m$ 种状态。

#### 状态转移

我们从始至终都只需要用到**所遍历到格子的前 `m` 个格子的状态**，因此需要不断更新这 `m` 个格子的状态，即进行**状态转移**。上述栗子中，`(3, 2, 1)` 格子的状态就需要转移为 `(2, 1, 0)` 格子的状态。

这个步骤用位运算实现：

1. 坏格子：`砍掉状态最高位 -> 左移 1 位 -> 最低位置 1`
2. 不放骨牌：`砍掉状态最高位 -> 左移 1 位`
3. 横放骨牌：`砍掉状态最高位 -> 左移 1 位 -> 最低两位置 1`
4. 竖放骨牌：`砍掉状态最高位 -> 左移 1 位 -> 最低位置 1`

#### 动态规划

如果一个格子有多种放置骨牌的方法，又该怎么办？答案是用**动态规划**选择能放置最多骨牌数量的最优解。

我们开辟一个 $2^m$ 大小的数组空间 `dp`。数组的标为状态值，数组的值用于表示该状态下能摆放的最多骨牌数，当值为 `-1` 时表示该状态为非法状态。

#### 步骤总结

1. 从左往右、从上往下遍历格子（意图为计算下一个状态 `next_dp`）
2. 在当前格子中遍历所有 $2^m$ 种状态
3. 若状态非法，继续步骤 2
4. 若状态合法，根据状态转移计算出下一个状态 `next_state` 以及该状态下对应的 `dp`

#### 代码

复杂度为 $O(m * n * 2^m)$。

```python
class Solution:
    def domino(self, n: int, m: int, broken: List[List[int]]) -> int:
        # broken 记录
        broken_map = dict()
        for b in broken:
            if b[0] not in broken_map:
                broken_map[b[0]] = dict()
            broken_map[b[0]][b[1]] = True
            
        """
        是坏格子
        """
        def is_broken(a, b):
            if a in broken_map and b in broken_map[a]:
                return True
            else:
                return False
            
        """
        获取下一个状态
        put: 0-不放，1-横放，2-竖放，3-坏格子
        """
        def next_state(state, put):
            # 去除高位
            state = ~(1 << (m - 1)) & state
            
            if put == 0:
                # 不放牌
                return state << 1
            elif put == 1:
                # 横着放
                return ((state | 1) << 1) | 1
            elif put == 2:
                # 竖着放
                return (state << 1) | 1
            else:
                # 坏格子
                return (state << 1) | 1
            
        # 创建 dp
        dp = [-1] * (1 << m)
        dp[(1 << m) - 1] = 0 # 全 1 的置 0
        
        for i in range(n):
            for j in range(m):
                next_dp = [-1] * (1 << m)
                # 遍历所有状态
                for state in range(1 << m):
                    # 非法状态
                    if dp[state] == -1:
                        continue
                    
                    if is_broken(i, j):
                        # 是坏格子
                        next_dp[next_state(state, 3)] = max(next_dp[next_state(state, 3)], dp[state]) # 是从 dp 转义还是保持现状
                        continue
                       
                    # 不放
                    next_dp[next_state(state, 0)] = max(next_dp[next_state(state, 0)], dp[state])
                    
                    # 可以竖放
                    if i != 0 and (1 << (m - 1)) & state == 0:
                        next_dp[next_state(state, 2)] = max(next_dp[next_state(state, 2)], dp[state] + 1)
                    
                    # 可以横放
                    if j != 0 and 1 & state == 0:
                        next_dp[next_state(state, 1)] = max(next_dp[next_state(state, 1)], dp[state] + 1)
                
                dp = next_dp
                        
        return max(dp)
```