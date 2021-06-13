# Optimum-Router
This repository has R script for a Shiny app for optimum route finder

The app uses Genetic Algorithm for searching for optimal path stochasitcally. The app is currently hosted on shinyapps.io: https://ashwinijha.shinyapps.io/Optimum_Router/

On the grid in the app, the user can mark points and execute the search for optimal path that connects the different points.

Genetic Algorithm is an optimization algorithm that mimics the evolution process for optimization. The algorithm starts with an initial population (each individual of the population is a w-i-p solution), checks the fitness of the population in terms of the accuracy or efficiency as defined by the user of the algo. The population undergoes mutation, crossover and elitism for arriving at the next generation/iteration of population. This process continues till the user-specified iterations run out or the solution efficiency stagnates for a user-defined number of iterations. The algorithm returns the individual solution from the population over all the generations that maximizes the efficiency. Pretty cool stuff! There are other nature-inspired algorithms that can be used in similar cases like Simulated Annealing, Ant-colony optimization, et-al.
