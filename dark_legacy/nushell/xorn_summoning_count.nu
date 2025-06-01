let setup_parsed_columns = ls |
sort-by modified | 
last 2 | 
get name |
each {|name| grep "Party attunement" -B 20 $name} | # This is triggered by every dig_path, so quite often. But that does not take time, it just create logs :) 
str join |
grep "an elder Xorn" |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' | # remove all ASCII escape codes
split row -r '\n' |
wrap raw |
insert timestamp_raw {|row| $row.raw | str substring 0..18 | str trim} |
insert timestamp {|row| $row.timestamp_raw | into datetime} | 
# insert message {|row| $row.raw | str substring 19..-1 | str trim} |
reject raw |
sort-by timestamp |
window 2 | # Calcualate the duration
each {|pair| 
    $pair |
    last |
    insert duration {|row| ($pair.1.timestamp | into datetime) - ($pair.0.timestamp | into datetime)}
} |
reduce -f [[]] {|row, acc| # Group every update that is less than 5 second duration and count up
    if $row.duration < 5sec {
        $acc | upsert (($acc | length) - 1) (($acc | last) ++ [$row])
    } else {
      $acc ++ [[ $row ]]
    }
} |
each {|group| $group.0 | insert count ($group | length)} |
where count < 6

$setup_parsed_columns 
