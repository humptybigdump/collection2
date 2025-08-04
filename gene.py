import random


class Gene:
    def __init__(self, alphabet, genetic_code=None, length=None):
        self.genetic_code = genetic_code if genetic_code else ''.join(random.choices(alphabet, k=length))
        self.alphabet = alphabet
        self.fitness = None

    def mutate(self, mutation_rate):
        self.genetic_code = ''.join([self._mutate_char(char, mutation_rate) for char in self.genetic_code])

    def _mutate_char(self, char, mutation_rate):
        other_chars = self.alphabet.copy()
        other_chars.remove(char)

        return random.choice(other_chars) if random.random() < mutation_rate else char

    def evaluate(self, environment):
        self.fitness = environment.evaluate(self)

    def __len__(self):
        return len(self.genetic_code)
