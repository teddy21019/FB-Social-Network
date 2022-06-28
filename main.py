import pandas as pd
import numpy as np
from Centrality import *
import pytictoc

import gc


if __name__ == '__main__':
    df = pd.read_pickle('DATA/light_data.pkl')
    network_column_name = ['user_id', 'page_id', 'reaction_time']
    weeks = sorted(df.week_start_date.unique())
    week_1 = df[df['week_start_date'] == min(weeks)][network_column_name]

    CG = Centrality(week_1)

    del df
    del week_1
    gc.collect()

    t = pytictoc.TicToc()

    t.tic()
    print(CG.flow_betweenness_centrality)
    t.toc()


