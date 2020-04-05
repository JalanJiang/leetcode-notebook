## 460. LFU缓存

[原题链接](https://leetcode-cn.com/problems/lfu-cache/)

### 解一：简单直白法

存储每个页的访问频率 `cnt` 和最近访问标记 `mark`。

```python
class Page:
    def __init__(self, val, cnt, mark):
        self.val = val
        self.cnt = cnt
        self.mark = mark

class LFUCache:

    def __init__(self, capacity: int):
        self.cap = capacity
        self.cache = dict()
        self.mark = 0

    def get(self, key: int) -> int:
        if key not in self.cache:
            return -1
        self.cache[key].cnt += 1
        self.mark += 1
        self.cache[key].mark = self.mark
        return self.cache[key].val

    def put(self, key: int, value: int) -> None:
        if key in self.cache:
            cur_cnt = self.cache[key].cnt + 1
            self.mark += 1
            self.cache[key] = Page(value, cur_cnt, self.mark)
            return

        # 判断是否超过
        if len(self.cache) < self.cap:
            # 直接写入
            self.cache[key] = Page(value, 0, self.mark)
            return
        
        cnt = float('inf')
        mark = float('inf')
        del_key = None
        # 获取最近最少使用的键，cnt 最小，然后 mark 最小
        for k in self.cache:
            page = self.cache[k]
            if page.cnt < cnt:
                cnt = page.cnt
                mark = page.mark
                del_key = k
            if page.cnt == cnt and page.mark < mark:
                mark = page.mark
                del_key = k

        if del_key is not None:
            self.cache.pop(del_key)
            # 写入新的值
            self.mark += 1
            self.cache[key] = Page(value, 0, self.mark)

# Your LFUCache object will be instantiated and called as such:
# obj = LFUCache(capacity)
# param_1 = obj.get(key)
# obj.put(key,value)
```