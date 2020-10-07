# Usage
INPUT OUTPUT EXAMPLES:

    make run ARGS="encode WHITEHAT PLAYFIREXMBCDGHKNOQSTUVWZ"
    # ZGRUMDPV

    make run ARGS="decode ZGRUMDPV PLAYFIREXMBCDGHKNOQSTUVWZ"
    # WHITEHAT
    
    make run ARGS="encode AGOODFOODBOOKISACOOKBOOK PLAYFIREXMBCDGHKNOQSTUVWZ"
    # YDQEQGASQGDKVTMKLDQEVTDKVT

    make run ARGS="decode YDQEQGASQGDKVTMKLDQEVTDKVT PLAYFIREXMBCDGHKNOQSTUVWZ"
    # AGOXODFOODBOOKISACOXOKBOOK

    # Note: AGO_ODFOODBOOKISACO_OKBOOK < easy to eliminate x's by hand.

    make run ARGS="encode TODAYISAGOODDAYTODIE OZAKDIREXMBCVGHYNPQSTUFWL"
    # UZMENRPDBKIMMENUIMBV

    make run ARGS="decode UZMENRPDBKIMMENUIMBV OZAKDIREXMBCVGHYNPQSTUFWL"
    # TODAYISAGOODDAYTODIE


Program input:

    make run ARGS="encode [ciphertext] [keytext]"

Output:

[encoded Text]


Program input:

    make run ARGS="decode [plaintext] [keytext]"

Output:

[decoded Text]

# Algorithm

ENCODE
    1. If the letters are on the same row, use the letters below them to replace them.
    2. If the letters are on the same column, use the letters to their right to replace them.
    3. If the letters are different, replace them with the letters on the same row, but in the column of the other letter
    4. If the letters are the same, insert an X between them.

DECODE (The key is symmetrical [used to encode/decode], but the algorithm is not!)
Be aware that encoding and decoding have opposite shifts for same column/row letters!
 1. If the letters are on the same row, use the letters ABOVE them to replace them.
 2. If the letters are on the same column, use the letters to their LEFT to replace them.
 3. Same.
4. The double letter problem means that there will be extra X's in your code. A human can deal with this.

___
Playfair key: 25 characters long, each letter used once excluding J. J would turn into I when you decode. 

For the key:
A B C D E
F G H I K
L M N O P
Q R S T U
V W X Y Z
You would use "ABCDEFGHIKLMNOPQRSTUVWXYZ" which can be broken up into 5 letter chunks by your program.
___
Plaintext: Any string of letters from A-Z, no numbers or special characters. You should uppercase everything so we all have the same results. 


You can use this to help you simulate output:
https://www.dcode.fr/playfair-cipher 

# More from class spec

Strategies to break this up:

Modularity is key to writing something like this. Writing a solution in small pieces that can be individually tested means you can make progress and test each step. It also means you have many small victories!


1. Write a method to insert x's between double letters. This is not as easy as just adding x's everywhere. 
Remember when you break up letters into pairs, not all double letters are part of the same pair:
e.g.
book ->  bo  ok
No x's required.

When you do add an x, it shifts the subsequent pairs:
abooksoop -> ab oo ks oo p  
This does NOT require 2 x's because adding X to the first oo means that the letters shift
ab ox ok so op

2. Suggestion for modularity:  After reading in your key and storing it in some data structure write 3 methods to encode letter pairs:
verticalEncode(letterPair)
horizontalEncode(letterPair)
regularEncode(letterPair)
Each method should return the encoded letter pair.

3. Write a function that takes a letter pair and checks your data structure to determine which encode method should be used. It can then call the  vertical / horizontal / regular  encode methods.

4. Once your encode message works you can decide if you want to either:
a) write decode methods for vertical and horizontal because the direction of the shift is reversed. (regular will be perfectly symmetrical)
b) generalize your algorithm to take in the direction of the shift as a parameter:
    e.g. verticalEncode(letterPair,direction)  could encode AND decode if you provide it LEFT/RIGHT as a direction.