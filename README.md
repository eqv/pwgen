pwgen
=====

A better pwgeneration / file checksuming tool that uses the xkcd algorithm to create higly secure and memorable passwords

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

*Compare a file (in this case pwgen.rb itself) with someone else

```bash
ruby pwgen.rb -df pwgen.rb
#InteractivityMobilFlirtsBoondoggleEcologistsLexicographerCastDohertyMaximaTieingAdmiralsInterRoderickBicentennialGrossmanScharfActuary9
```

License
=======
The wordlist.txt is from here: http://www.keithv.com/software/wlist/

This projekt is released under GPL v2
