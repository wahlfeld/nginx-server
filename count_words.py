#!/usr/bin/python3

import requests
import sys, getopt
from lxml import html
from bs4 import BeautifulSoup

def count_words(arg):
    try:
        opts, args = getopt.getopt(arg,"hu:",["url="])
    except getopt.GetoptError:
      print("count_words.py -u <URL>")
      sys.exit(2)

    for opt, arg in opts:
        if opt == '-h':
            print("count_words.py -u <URL>")
            sys.exit()
        elif opt in ("-u", "--url"):
            url = arg

    resp = requests.get(url)
    html = resp.text
    soup = BeautifulSoup(html, "html.parser")
    for script in soup(["title", "script", "style"]):
        script.extract()

    text = soup.get_text()
    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    cleanText = '\n'.join(chunk for chunk in chunks if chunk)
    wordList = cleanText.split()
    wordDict = {}
    for word in wordList: 
        wordDict.update({word:wordList.count(word)})

    sortedWordDict = sorted(wordDict.items(), key=lambda item: item[1], reverse=True)
    wordOfTheDay = sortedWordDict[0][0]
    print(wordOfTheDay)

if __name__ == "__main__":
   count_words(sys.argv[1:])
