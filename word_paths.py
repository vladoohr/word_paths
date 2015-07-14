import heapq


class PriorityQueue(object):
    """
    Basic priority queue. Calculates priority based on the provided function.
    Does not let change the priority of an existing item, simply adds another one.
    """

    def __init__(self, priority_function):
        self.heap = []
        self.priority_function = priority_function

    def push(self, item):
        heapq.heappush(self.heap, (self.priority_function(item), item))

    def pop(self):
        priority, item = heapq.heappop(self.heap)
        return item

    def is_empty(self):
        return len(self.heap) == 0


class Node(object):
    def __init__(self, state, parent=None, path_cost=0):
        self.state = state
        self.parent = parent
        self.path_cost = path_cost

    def expand(self, dictionary):
        return (Node(s, self, self.path_cost+1) for s in generate_words(self.state) if s in dictionary)

    def chain(self):
        node, trail = self, []
        while node:
            trail.append(node.state)
            node = node.parent
        return reversed(trail)


def load_words(length):
    return frozenset(line.strip() for line in open("/usr/share/dict/words") if len(line) == length+1 and line.islower())


LOWER_LETTERS = [chr(i) for i in xrange(97, 123)]


def generate_words(word):
    new_words = []
    for i in xrange(len(word)):
        new_words.extend([word[:i] + c + word[i+1:] for c in LOWER_LETTERS if c != word[i]])
    return new_words


def heuristic(item, goal):
    return sum([c == d for c, d in zip(item.state, goal)])


def search(start_word, goal_word, dictionary):
    assert(len(start_word) == len(goal_word))
    frontier = PriorityQueue(lambda n: n.path_cost + heuristic(n, goal_word))
    frontier.push(Node(start_word))
    explored = set()
    while not frontier.is_empty():
        node = frontier.pop()
        if node.state in explored:
            continue
        if node.state == goal_word:
            return node.chain()
        explored.add(node.state)
        for child in node.expand(dictionary):
            if child.state not in explored:
                frontier.push(child)
    return []


if __name__ == '__main__':
    for word in search("head", "tail", load_words(len("head"))):
        print word
    print
    for word in search("white", "black", load_words(len("white"))):
        print word