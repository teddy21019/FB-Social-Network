import pickle
import pandas as pd
from Centrality import *



df = pd.read_pickle('DATA/light_data.pkl')
network_column_name = ['user_id', 'page_id', 'reaction_time']
weeks = sorted(df.week_start_date.unique())

for week in weeks[1:]:
    week_string = str(week)[:10]

    print(f'Processing {week_string}')
    CG = Centrality(df[df.week_start_date == week ][network_column_name])


    community_detection = CG.community_detection


    with open(f"Result/{week_string}_community_detection.pkl",'wb') as f:
        pickle.dump(community_detection, f)

    print('='*30)



