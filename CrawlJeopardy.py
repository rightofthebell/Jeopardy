from requests import get
from requests.exceptions import RequestException
from contextlib import closing
from bs4 import BeautifulSoup, SoupStrainer

def main():
    url = "http://j-archive.com/showseason.php?season=34"
    output = simple_get(url)
    links = []
    for link in BeautifulSoup(output, parse_only=SoupStrainer('a')):
        if link.has_attr('href'):
            if("game_id" in link['href']):
                links.append(link['href'])
    
    f = open("Jeopardy/season34.csv", 'w')

    for k in links:
        #Get html from website
        url = k
        output = simple_get(url)
        soup = BeautifulSoup(output, features="html.parser")

        info = soup.find('div', attrs={'id':'game_title'})

        strippedInfo = info.text.strip()
        print(strippedInfo)
        season = "34";
        date = strippedInfo[12:].replace(",","")
        show = strippedInfo[:10].replace(",","")

        #Get Tables
        tables = soup.find_all('table', attrs={'class':'round'})

        for j in range(0,2):
            table = tables[j]
            if(j==0):
                roundA = "Jeopardy"
            else:
                roundA = "Double Jeopardy"    
            #Get categories
            categories = table.find_all('td', attrs={'class':'category_name'})
            cats = [ele.text.strip() for ele in categories]
            

            #Get clues and answers
            data = []
            clues = table.find_all('td', attrs={'class':'clue'})
            for clue in clues:
                divClue = clue.find("div")

                try:
                    correctAns = divClue["onmouseover"]
                    correctAns2 = BeautifulSoup(correctAns, features="html.parser")
                    correct = correctAns2.find('em', attrs={'class':'correct_response'})

                    question = divClue["onmouseout"][41:-2]
                    data.append([question, correct.text.strip()])
                except:
                    data.append(["",""])

            for i in range(0,len(data)):
                string = date + "," + show + "," + roundA + "," + cats[i%5].replace(",","") + "," + str(int(i/6)+1) + "," + data[i][0].replace(',', '') + "," + data[i][1].replace(',', '') + '\n'           
                f.write(string)
        
    f.close()

def simple_get(url):
    try:
        with closing(get(url, stream=True)) as resp:
            if is_good_response(resp):
                return resp.content
            else:
                return None

    except RequestException as e:
        log_error('Error during requests to {0} : {1}'.format(url, str(e)))
        return None

def is_good_response(resp):
    content_type = resp.headers['Content-Type'].lower()
    return (resp.status_code == 200 
            and content_type is not None 
            and content_type.find('html') > -1)

def log_error(e):
    print(e)
    
main()
