let setup_parsed_columns = grep -ir 'you start harvesting' |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' | # remove all ASCII escape codes
split row -r '\n' |
wrap raw |
insert logfile {|row| $row.raw | str substring 0..21 | str trim} |
insert timestamp {|row| $row.raw | str substring 23..41 | str trim} |
reject raw 


let calculate_diff_pr_status = $setup_parsed_columns |
insert timestamp_parsed {|row| $row.timestamp | into datetime} |
window 2 |
each {|pair| 
    let logfile = $pair | last | get logfile
    let timestamp = $pair | last | get timestamp
    let timestamp_start = $pair | first | get timestamp_parsed
    let timestamp_end =  $pair | last | get timestamp_parsed
    let duration = $timestamp_end - $timestamp_start
    { "logfile": $logfile, "timestamp": $timestamp, "duration": $duration}
}

let interesting_logs = $calculate_diff_pr_status | 
where duration > 10min | 
where duration < 28min

$interesting_logs | 
insert logs {|row| $row | grep -B 100 $row.timestamp $row.logfile}
