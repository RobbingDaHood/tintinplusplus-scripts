
> echo "a ----a- -- --e -a---a- ---a--e--" | tr " " "\n" | sed 's/-/./g' | xargs -t -I {} grep -iE '^{}$' /usr/share/dict/words > /dev/null
grep -iE '^a$' /usr/share/dict/words
grep -iE '^....a.$' /usr/share/dict/words
grep -iE '^..$' /usr/share/dict/words
grep -iE '^..e$' /usr/share/dict/words
grep -iE '^.a...a.$' /usr/share/dict/words
grep -iE '^...a..e..$' /usr/share/dict/words
