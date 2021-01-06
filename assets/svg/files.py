import os
import json
data = os.listdir()
with open('data.json', 'w') as outfile:
    json.dump(data, outfile)