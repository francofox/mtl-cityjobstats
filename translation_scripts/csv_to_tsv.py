# initial conversion from csv to tsv of queried table

import csv
with open('dim_jobcode.csv', 'r', newline='') as csv_in:
    csv_contents = csv.reader(csv_in)
    with open('dim_jobcode.tsv', 'w', newline='') as tsv_out:
        writer = csv.writer(tsv_out, delimiter="\t")
        writer.writerows(csv_contents)