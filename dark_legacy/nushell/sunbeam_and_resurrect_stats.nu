grep -r -e "Vivificus Bestia" -e "Solaris Fortis" |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' | # remove all ASCII escape codes
split row -r '\n' |
wrap raw |
insert logfile {|row| $row.raw | str substring 0..21 | str trim} |
insert timestamp_raw {|row| $row.raw | str substring 23..41 | str trim} |
insert timestamp {|row| $row.timestamp_raw | into datetime} |
insert message {|row| $row.raw | str substring 42..-1 | str trim} |
reject raw |
sort-by timestamp 
