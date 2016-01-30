import urllib

with open("source2.txt") as f:
    data = f.read()
    for c in data:
        print(urllib.quote_plus(c))
