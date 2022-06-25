import pandas as pd
import numpy as np
from Centrality import Centrality
import pytictoc

if __name__ == '__main__':
    t = pytictoc.TicToc()

    # read data from DATA/light_data.pkl using pandas  
    file_position = 'DATA/light_data.pkl'

    df = pd.read_pickle(file_position)
    user_list = pd.read_csv('DATA/user_list.csv')
    page_list = pd.read_csv('DATA/page_list.csv')

    user_num = len(user_list)
    page_num = len(page_list)

    # get smallest week
    weeks = sorted(df.week_start_date.unique())

    # get week 1 from df
    week_1 = df[df['week_start_date']== min(weeks)]

    # turn data into matrix
    A_matrix = np.zeros((user_num, page_num))
    A_matrix[week_1.u_i, week_1.p_i] = week_1.reaction_time
    AC = Centrality(A_matrix)
    
    t.tic()
    print(AC.eigenvector_centrality())
    t.toc()


