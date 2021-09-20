#!/usr/local/bin/python3

import requests
from lxml import html
from bs4 import BeautifulSoup

def count_words():
    print("What URL do you want to check?")
    url = input()

    resp = requests.get(url)
    html = resp.text
    soup = BeautifulSoup(html, "html.parser")
    for script in soup(["title", "script", "style"]):
        script.extract()

    text = soup.get_text()
    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    clean_text = '\n'.join(chunk for chunk in chunks if chunk)

    word_list = clean_text.split()
    max = 0
    max_word = None
    for word in word_list:
        if word_list.count(word) > max:
            max = word_list.count(word)
            max_word = word

    print(max_word)

if __name__ == "__main__":
    count_words()
