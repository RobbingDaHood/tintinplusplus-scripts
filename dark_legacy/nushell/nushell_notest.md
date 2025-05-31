r "'miningportal' contains" -A 20 |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' |
grep -E '\([0-9]+\)' |
grep -v from |
split row -r '\n' |
wrap raw |
insert timestamp {|row| $row.raw | str substring 22..42} |
insert message {|row| $row.raw | str substring 43..-1}


grep -ir "'miningportal' contains" -A 20 |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' |
grep -E '\([0-9]+\)' |
grep -v from |
split row -r '\n' |
wrap raw |
insert timestamp {|row| $row.raw | str substring 23..42} | str trim |
insert message {|row| $row.raw | str substring 43..-1 | str trim} |
reject raw |
insert material {|row| $row.message | split column '(' material_raw amount_raw} |
flatten | flatten |
insert material {|row| $row.material_raw | str trim} |
insert amount_first_paranthese {|row| $row.amount_raw | str indexof }
insert amount {|row| $row.amount_raw | str trimm | str substring 0..$row.amount_first_paranthese | into int}

grep -ir "'miningportal' contains" -A 20 |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' |
grep -E '\([0-9]+\)' |
grep -v from |
split row -r '\n' |
wrap raw |
insert timestamp {|row| $row.raw | str substring 23..42} | str trim |
insert message {|row| $row.raw | str substring 43..-1 | str trim} |
insert material {|row| $row.message | split column '(' material_raw amount_raw} |
flatten | flatten |
insert material {|row| $row.material_raw | str trim} |
insert amount_first_paranthese {|row| $row.amount_raw | str index-of ')' } |
insert amount {|row| $row.amount_raw | str trim | str substring 0..($row.amount_first_paranthese - 1) | into int} |
reject material_raw amount_raw message amount_first_paranthese raw |
group-by --to-table timestamp |
each {|row| $row | reject items.timestamp} |
insert new_columns {|row| $row.items | reduce -f $in {|it, acc| $acc | insert $row.timestamp $it.amount}}


grep -ir "'miningportal' contains" -A 20 |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' |
kk
grep -v you |
grep -v falls |
split row -r '\n' |
wrap raw |
113 lines yanked                                                                                                                                                    1,1           Top
e
ls |                                                                                                                                                                                  get name |                                                                                                                                                                            first |                                                                                                                                                                               each {|file|                                                                                                                                                                                  sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' $file |                                                                                                                                           head |
        split row -r '\n' |
        wrap raw |
        insert timestamp {|row| $row.raw | str substring 0..18} |
        insert message {|row| $row.raw | str substring 19..-1} |
        reject raw
}

