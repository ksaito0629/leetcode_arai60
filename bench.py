import timeit
from operator import itemgetter

data = [('john', 'A', 15), ('jane', 'B', 12), ('dave', 'B', 10)] * 10000

print(timeit.timeit(
    stmt="sorted(data, key=lambda x: x[2])",
    globals=globals(),
    number=1000
))

print(timeit.timeit(
    stmt="sorted(data, key=itemgetter(2))",
    globals=globals(),
    number=1000
))
