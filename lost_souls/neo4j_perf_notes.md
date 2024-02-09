# during inserts then it is fine
```
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT     MEM %     NET I/O          BLOCK I/O       PIDS
3o724ef8ed190   LostSoulNeo4j   102.89%   1.245GiB / 31.05GiB   4.01%     30.6MB / 136MB   415MB / 226MB   126
```

It used a lot of CPU but memory were very efficient. 

```
> du -sh neo4j/
529M	neo4j/
```

At `62501`

```
> du -sh neo4j/
536M	neo4j/
```

At `96701` 

```
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS
3724ef8ed190   LostSoulNeo4j   1.91%     1.155GiB / 31.05GiB   3.72%     3.61MB / 46.5MB   591MB / 35.6MB   98
``` 

``` 
[I] [20:55:34] daniel.winther.petersen@subaioadmin-danielwintherpetersen /home/daniel.winther.petersen [1]
> du -sh neo4j/
616M	neo4j/
``` 

Rooms: 370208

So seems like I have plenty of rooms. 

The query time did get reduced quite a lot. I would say 100 inserts (with edges). Took around 7 seconds at the end. 



