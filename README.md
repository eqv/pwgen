pwgen.rb
=====

A better pwgeneration / file checksuming tool that uses the xkcd algorithm to create highly secure and memorable passwords. 
It can be used to generate random passwords, generate multiple passwords for different accounts/usecases from the same master password, to compare files by means of their fingerprint and to memorize fingerprints of arbitrary files (e.g gpg public keys) by generating passwords from the file. 

Usecases
========

*Generate a new random password and copy it to the clipboard (this requires xclip to be installed)

```bash
ruby pwgen.rb
```

*Generate a new static password from a master password and a usecase/account and print it, note that this takes a while to prevent master password bruteforcing.

```bash
ruby pwgen.rb -ds "some_mail@some_provi.der"
#Please enter your master password:
#Thank you, I will no generate a password for the usecase "some_mail@some_provi.der"
#ReestablishedOurselfMultipliedAlignmentsAleph8
```

*To compare a file (in this case pwgen.rb itself) with someone else, generate a passphrase from it and read it aloud instead of the original hex fingerprint (This should be as secure as a full SHA256 fingerprint comparison).

```bash
ruby pwgen.rb -df pwgen.rb
#InteractivityMobilFlirtsBoondoggleEcologistsLexicographerCastDohertyMaximaTieingAdmiralsInterRoderickBicentennialGrossmanScharfActuary9
```

License
=======
The wordlist.txt is from here: http://www.keithv.com/software/wlist/

This project is released under GPL v2
