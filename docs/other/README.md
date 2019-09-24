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