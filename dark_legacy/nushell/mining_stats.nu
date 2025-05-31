let setup_parsed_columns = grep -ir "'miningportal' contains" -A 20 |
sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g' | # remove all ASCII escape codes
grep -E '\([0-9]+\)' |
grep -v from |
grep -v you |
grep -v falls |
grep -v spilled |
split row -r '\n' |
wrap raw |
insert timestamp {|row| $row.raw | str substring 23..42 | str trim} |
insert message {|row| $row.raw | str substring 43..-1 | str trim} |
insert material {|row| $row.message | split column '(' material_raw amount_raw} |
flatten | flatten |
insert material {|row| $row.material_raw | str trim} |
insert amount_first_paranthese {|row| $row.amount_raw | str index-of ')' } |
insert amount {|row| $row.amount_raw | str trim | str substring 0..($row.amount_first_paranthese - 1) | into int} |
reject material_raw amount_raw message amount_first_paranthese |
group-by --to-table timestamp |
each {|row| $row.items | reduce -f $row {|it, acc| $acc | insert $it.material $it.amount}} | # This takes every row in the inner items table and add them as columns in the outer table
reject items |
insert timestamp_raw {|row| $row.timestamp | into datetime} |

let calculate_diff_pr_status = $setup_parsed_columns |
enumerate |
each {|row|
   let prev = (if $row.index == 0 { 0 | into datetime} else { $setup_parsed_columns | get timestamp | get ($row.index - 1)})
   $row.item | insert duration ($row.item.timestamp - $prev)
} |
sort-by timestamp |
reduce -f [[]] {|row, acc| # group with row before if duration is less than 5 seconds, because a mining update could take more than one second to print 
    let last = ($acc | last)
    if $row.duration > 0sec and $row.duration <= 5sec {
        $acc | upsert (($acc | length) - 1) ($last ++ [$row])
    } else {
      $acc ++ [[ $row ]]
    }
  } |
skip |
each {|group| # Merge all updates in each group 
    $group |
    reject timestamp_raw duration |
    math sum |
    flatten |
    insert timestamp_raw ($group | first | get timestamp_raw) |
    insert duration ($group | last | get duration)
} |
flatten |
update timestamp_raw {|row| $row.timestamp_raw | into datetime | into int} | # need to do this to let the timestamp "survive" the "math sum" later :)
window 2 | # Calcualate the diff for each ressource compared.
each {|pair| 
    $pair | first | items {|key, value|
        if $key == "timestamp_raw" or $key == "duration" {
                {$key: $value}
        } else {
                {$key: (($pair.1 | get $key) - $value)}
        }
    } |
    math sum
}


let $calculate_diff_pr_session = $calculate_diff_pr_status |
reduce -f [[]] {|row, acc| # If duration is more than 10 minutes then it would likely be a new session, because we log every 5 minutes
    let last = ($acc | last)
    if $row.duration < 10min {
        $acc | upsert (($acc | length) - 1) ($last ++ [$row])
    } else {
      $acc ++ [[ $row ]]
    }
} |
each {|group| # Merge all updates in each session 
    $group |
    reject timestamp_raw duration |
    math sum |
    flatten |
    insert start ($group | first | get timestamp_raw | into datetime | format date "%Y-%m-%d-%H:%M:%S") |
    insert end ($group | last | get timestamp_raw | into datetime | format date "%Y-%m-%d-%H:%M:%S")
} |
flatten |
each {|row| $row | insert duration (($row.end | into datetime) - ($row.start | into datetime))} | # Calculate new duration
reject end |
sort-by start |
move duration --first |
move start --first

$calculate_diff_pr_session
