import random


def qsort(nums):
    if not nums:
        return []

    random_pivot_index = random.randrange(len(nums))
    nums[0], nums[random_pivot_index] = nums[random_pivot_index], nums[0]

    pivot = nums[0]
    left = [x for x in nums if x < pivot]
    right = [x for x in nums[1:] if x >= pivot]

    return qsort(left) + [pivot] + qsort(right)

``def qselect(nums, k):
    if k > len(nums):
        return None


    random_pivot_index = random.randrange(len(nums))
    nums[0], nums[random_pivot_index] = nums[random_pivot_index], nums[0]

    pivot = nums[0]
    left = [x for x in nums if x < pivot]
    right = [x for x in nums[1:] if x >= pivot]

    if len(left) == k - 1:
        return pivot
    if len(left) > k - 1:
        return qselect(left, k)

    return qselect(right, k - (len(left) + 1))``
nums = [3, 1, 4, 1]
print(qselect(nums, 1))  # → 1
print(qselect(nums, 4))  # → 3
print(qselect(nums, 8))  # → 9
