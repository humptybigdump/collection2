from population import Population
from problem_environment import ProblemEnvironment
from summary_writer import SummaryWriter


class SimpleGeneticAlgorithm:
    def __init__(self, environment: ProblemEnvironment, cross_rate: float, mutation_rate: float):
        self.environment = environment
        self.cross_rate = cross_rate
        self.mutation_rate = mutation_rate

    def run(self, n_generations, population_size):
        summary_writer = SummaryWriter()

        population = Population(alphabet=["0", "1"], size=population_size, gene_length=self.environment.gene_length)
        population.evaluate(self.environment)
        summary_writer.print_current_performance(population.fitness)

        for _ in range(n_generations):
            population.evaluate(self.environment)
            summary_writer.print_current_performance(population.fitness)
            population = population.replicate(self.cross_rate, self.mutation_rate)

        summary_writer.plot_mean_performance_history()
        self._print_best_final_solution(population)

    def evaluate_population(self, population):
        return [self.environment.evaluate(gene) for gene in population]

    def _print_best_final_solution(self, population):
        population.evaluate(self.environment)
        max_idx = max(enumerate(population.fitness), key=lambda x: x[1])[0]
        best_params = self.environment.decode_params(population[max_idx])
        print(f"Best solution in final generation: {best_params}")
