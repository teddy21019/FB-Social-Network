from operator import imod
import networkx as nx
from networkx.algorithms import bipartite as bp
import numpy as np
import pandas as pd

class Centrality:
    def __init__(self, A, nodes_1 = None, nodes_2=None):

        from scipy.sparse import csc_matrix, bmat
        self.__A_matrix = csc_matrix(A)
        self.__Social_matrix = bmat([[None, self.__A_matrix],[self.__A_matrix.transpose(), None]])
        self.__G = bp.from_biadjacency_matrix(self.__A_matrix)
        self.__Social_G = bp.from_biadjacency_matrix(self.__Social_matrix)
        self.nodes_1 = nodes_1
        self.nodes_2 = nodes_2
    
    def get_A_matrix(self):
        return self.__A_matrix

    def get_Social_Matrix(self):
        return self.__Social_matrix
    
    def set_user_list(self, user_list):
        self.user_list = user_list
        self.user_n = len(user_list)

    def set_page_list(self, page_list):
        self.page_list = page_list
        self.page_n = len(page_list)

    def degree_centrality(self):
        return nx.degree_centrality(self.__G)

    def eigenvector_centrality(self):
        return nx.eigenvector_centrality(self.__Social_G, max_iter = 1000)
