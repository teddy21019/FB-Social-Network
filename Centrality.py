from functools import cached_property
from itertools import islice
import networkx as nx
import pandas
import scipy
import numpy as np
from scipy.sparse import bmat
from scipy.sparse.linalg import eigsh

class Centrality:
    def __init__(self, df:pandas.DataFrame) :
        print('Graph created')
        self.G = nx.Graph()

        self.G.add_nodes_from(df.user_id.unique(), bipartite = 0)
        self.G.add_nodes_from(df.page_id.unique(), bipartite = 1)

        print('Creating edges...')
        self.G.add_weighted_edges_from(zip(df.user_id, df.page_id, df.reaction_time))
        print('Graph creation completed successfully')

        self.user_node = {n for n, d in self.G.nodes(data=True) if d["bipartite"] == 0}
        self.page_node = {n for n, d in self.G.nodes(data=True) if d["bipartite"] == 1}


    @cached_property
    def degree_centrality(self):
        """
        Returns the degree_centrality of the graph.
        """
        return nx.bipartite.degree_centrality(self.G, self.user_node)
        
    def user_centrality(self, centrality_dict:dict, reverse:bool=True) -> dict:
        """
        Returns the users' centrality given the centrality dictionary.
        """
        user_c_unsorted = {x:centrality_dict[x] for x in self.user_node}
        return dict(
            sorted( user_c_unsorted.items(), key=lambda item:item[1], reverse = reverse)
            )

    def page_centrality(self, centrality_dict:dict, reverse:bool=True) -> dict:

        page_c_unsorted = {x:centrality_dict[x] for x in self.page_node}
        return dict(
            sorted( page_c_unsorted.items(), key=lambda item:item[1], reverse = reverse)
            )
            
    @cached_property
    def A_matrix(self):
        """
        The biadjacency matrix of the graph. It is n_u * n_p, where n_u is the number of user_nodes and n_p is the number of page_nodes.

        The value of the elements are the weight of the graph.
        """
        return nx.bipartite.biadjacency_matrix(
                self.G, row_order=self.user_node, column_order=self.page_node)

    @cached_property
    def Social_matrix(self):
        """
        Build a social matrix from the A_matrix.

        The A_matrix is n_u * n_p, where n_u is the number of users and n_p is the number of pages.

        The Social_matrix is [[0, A],[A', 0]], and therefore the columns(and rows) represent [users, pages]
        """
        return bmat([[None, self.A_matrix],[self.A_matrix.transpose(), None]])

    @cached_property
    def eigenvector_centrality(self):
        """
        Returns the eigenvector centrality of the graph for users and pages, respectively.

        The calculation might be time consuming.

        However, we only have to calculate ones. Because of the property
        Ac^U = \lambda c^P
        A'c^P = \lambda c^U

        Once we get the eigenvector and eigenvalue of pages, which is only 1000*1000, we can calculate the eigenvectors of the users directly from it.
        """
        print("Calculating pages' eigenvector centrality")
        evalue_page, evector_page = eigsh((self.A_matrix.transpose() @ self.A_matrix).asfptype(), k=1, which='LA') 
        
        evalue_page = evalue_page[0]

        print("Calulating user's eigenvector centrality")
        evector_user = (self.A_matrix @ evector_page) / np.sqrt(evalue_page)

        evector_page = dict(zip(self.page_node,[r[0] for r in evector_page]))
        evector_user = dict(zip(self.user_node,[r[0] for r in evector_user]))

        return evector_user, evector_page

    @cached_property
    def closeness_centrality(self):
        # return nx.bipartite.closeness_centrality(self.G, self.user_node)
        normalized = True
        closeness = {}
        path_length = nx.single_source_shortest_path_length
        top = set(self.page_node)
        bottom = set(self.user_node)
        n = len(top)
        m = len(bottom)

        print('Processing closeness centrality')
        for i, node in enumerate(top):
            print(f'Processing {i}/{n}', end = "\x1b\r")
            sp = path_length(self.G, node)
            totsp = sum(sp.values())
            if totsp > 0.0:
                s = (len(sp) - 1) / (len(self.G) - 1)
                closeness[node] = (m + 2 * (n - 1)) * s / totsp
            else:
                #closeness[n] = 0.0
                closeness[node] = 0.0
        # for node in bottom:
        #     sp = dict(path_length(G, node))
        #     totsp = sum(sp.values())
        #     if totsp > 0.0 and len(G) > 1:
        #         closeness[node] = (n + 2 * (m - 1)) / totsp
        #         if normalized:
        #             s = (len(sp) - 1) / (len(G) - 1)
        #             closeness[node] *= s
        #     else:
        #         #closeness[n] = 0.0
        #         closeness[node] = 0.0
        print()
        return closeness

    @cached_property
    def flow_betweenness_centrality(self):
        print('Note! Approimating flow betweenness centrality.')
        return nx.algorithms.centrality.approximate_current_flow_betweenness_centrality(
            self.G, weight='weight')


def top10(d:dict) ->dict:
    """
    Get the top 10 elements of the dictionary from the given dictionary.
    """
    return dict(islice(d.items(), 0, 10))