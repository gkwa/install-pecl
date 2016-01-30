import urllib

with open("in.txt") as f:
    data = f.read()
    print(urllib.quote_plus(data))
