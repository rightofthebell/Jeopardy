import csv
import random
import json

def main():
    f = open("season34.csv")
    data=list(csv.reader(f))

    i = len(data[1])
    j = len(data)
    
    print(i)
    print(j)

    while(True):
        rand = random.randint(1,j)
        print(data[rand][5])
        input()
        print(data[rand][6])

        input()

def main2():
    with open('JEOPARDY_QUESTIONS1.json') as json_file:  
        data = json.load(json_file)

    j = len(data)

    while(True):
        rand = random.randint(1,j)
        if(data[rand]['air_date']>'2010-01-01'):
            
            print(data[rand]['air_date'])
            print(data[rand]['category'])
            print(data[rand]['question'])
            input()
            print(data[rand]['answer'])

            input()
main2()
