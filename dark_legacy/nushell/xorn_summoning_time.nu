# Sheathed summon time of xorns are around 5 seconds. 
# 1. How often am I summining at that speed? 
# 1. How much time is used on this? (Could it make sense to use quickened modifiers?) 

let setup_parsed_columns = grep -r "Solaris In Fortis" |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' | # remove all ASCII escape codes
split row -r '\n' |
wrap raw |
insert logfile {|row| $row.raw | str substring 0..21 | str trim} |
insert timestamp {|row| $row.raw | str substring 23..41 | str trim} |
insert message {|row| $row.raw | str substring 43..-1 | str trim} |
reject raw |
sort-by timestamp 

let xorn_summining_too_long = $setup_parsed_columns |
window 2 | # Calcualate the duration
each {|pair| 
    $pair |
    first |
    insert duration {|row| ($pair.1.timestamp | into datetime) - ($pair.0.timestamp | into datetime)}
} | 
where ($it.duration) > 4sec and ($it.duration) < 10sec

$xorn_summining_too_long | 
where timestamp > "2025-05-31-20:44:10" # Here I made the script sheathe before casting everytime
