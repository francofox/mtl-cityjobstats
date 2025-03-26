# Once the TSV has been translated, change back to CSV

import csv
with open('dim_jobcode_en.tsv', 'r', newline='') as tsv_in:
    tsv_contents = csv.reader(tsv_in, delimiter='\t')
    with open('dim_jobcode_en.csv', 'w', newline='') as csv_out:
        writer = csv.writer(csv_out, delimiter=",")
        writer.writerows(tsv_contents)