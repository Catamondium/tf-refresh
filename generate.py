import datetime
import random
from string import ascii_letters

if __name__ == '__main__':
    with open("./lambda.py.template", mode='rt') as file:
        text = file.read()
        rands = ''.join(random.choices(ascii_letters, k=10))
        creation_time = datetime.datetime.now().strftime("%c")
        output = text\
            .replace("RANDOM_CODE", rands)\
            .replace("CREATION_TIME", creation_time)

        with open("./lambda.py", "wt") as outfile:
            print(output, file=outfile)
