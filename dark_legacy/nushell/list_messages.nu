(
grep -Er 
 -e " ooc" 
 -e " yell" 
 -e " shout" 
 -e " newbiechat" 
 -e " ghosttalk" 
 -e " say" 
 -e " answer" 
 -e " ask" 
 -e " tell" 
 -e "\\([^\\(\\)]+\\)\\:"
 -e "\\([^\\(\\)]+\\:" |
 grep -v "Alexis" |
 grep -v "Zenpin" |
 grep -v " slime " | 
 grep -v "You will die by my hand"
 ) |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' | # remove all ASCII escape codes
split row -r '\n' |
wrap raw |
insert timestamp_raw {|row| $row.raw | str substring 23..41 | str trim} |
insert timestamp {|row| $row.timestamp_raw | try {into datetime} catch {0}} |
insert message {|row| $row.raw | str substring 42..-1 | str trim}  |
reject raw |
sort-by timestamp

