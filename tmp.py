import heapq
from typing import List

def kSmallestPairs(nums1: List[int], nums2: List[int], k: int) -> List[List[int]]:
    heap = [(nums1[0] + nums2[0], 0, 0)]
    next_i = [0] * len(nums2)
    next_j = [0] * len(nums1)
    result = []

    while len(result) < k and heap:
        _, i, j = heapq.heappop(heap)
        result.append([nums1[i], nums2[j]])

        next_i[j] += 1
        next_j[i] += 1

        if i + 1 < len(nums1) and next_j[i + 1] == j:
            heapq.heappush(heap, (nums1[i+1] + nums2[j], i+1, j))

        if j + 1 < len(nums2) and next_i[j + 1] == i:
            heapq.heappush(heap, (nums1[i] + nums2[j+1], i, j+1))

    return result

if __name__ == "__main__":

        # テストケース
    nums1 = [1, 7, 11]
    nums2 = [2, 4, 6]
    k = 4
    kSmallestPairs(nums1, nums2, k)
    # 期待値: [[1,2], [1,4], [1,6], [7,2]]
