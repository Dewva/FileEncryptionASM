.data
formatReadBin DB "rb", 0
formatWriteBin DB "wb", 0
formatCharWrite DB "%c",0
formatDecimalWrite DB "%d",13,10,0
formatDecimalRead DB "%d", 0
formatString DB "%s",13,10,0
commandRead DB "%s",0
DEBUG DB "%s %s %d %s %s",13,10,0
menu1 DB "[Encrypt]", 13,10,0
menu2 DB "[Decrypt]", 13,10,0
menu3 DB "[Help]", 13,10,0
menu4 DB "[Exit]", 13,10,0
comanda1 DB "Introduceti o comanda: ",0
help1 DB "Comenzi valabile:",13,10,0
help2 DB "encrypt -xor <key> <src-file> <dest-file>",13,10,0
help3 DB "encrypt -atbash <src-file> <dest-file>",13,10,0
help4 DB "encrypt -affine -a <a> -b <b> <src-file> <dest-file>",13,10,0
help5 DB "encrypt -permutation -n <n> p1...pn <src-file> <dst-file>",13,10,0
help6 DB "encrypt -caesar -key <key> <src-file> <dst-file>",13,10,0
help7 DB "decrypt -xor <key> <src-file> <dest-file>",13,10,0
help8 DB "decrypt -atbash <src-file> <dest-file>",13,10,0
help9 DB "decrypt -affine -a <a> -b <b> <src-file> <dest-file>",13,10,0
help10 DB "decrypt -permutation -n <n> p1...pn <src-file> <dst-file>",13,10,0
help11 DB "decrypt -caesar -key <key> <src-file> <dst-file>",13,10,0

