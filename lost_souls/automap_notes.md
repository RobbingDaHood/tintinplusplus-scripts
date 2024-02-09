# use cases

The western exit from the LH sewers sends you through a room whose name is only shown if you look during the brief time you're in it
It also drops you in one of five randomly-chosen rooms in the Shrieking Siren, some of which have the same description and exits as each other
Hypospatiality removes one axis of directions
The rivers in Gardagh change name and description based on weather
The Exoma and the Aumbrie use rooms generated on the fly when you take an exit
Gezuun and Wamnock's Lair regenerate (changing their layout) on a timer, with a message if you're inside in Gezuun's case at least (never seen it happen in Wamnock's Lair so can't say)
The Crypt of Key-Atemi has no "obvious exits"
Leaving the Temple of Ganesha is an exit with a variable destination
The gold mirror in Camille's town hall has three possible destinations
Leaving the Windship passes you through a temporary room, and has a variable destination
The mirror in Terrace is a random teleport
The delocalization challenge from Ganesha will randomport you without any action of your own

# neo4j

## Start

```
docker run \
    --publish=7474:7474 --publish=7687:7687 \
    --volume=$HOME/neo4j/data:/data \
    --name=LostSoulNeo4j \
    -d \
    neo4j
```

``` 
docker exec LostSoulNeo4j cypher-shell -h
```

```
docker exec LostSoulNeo4j cypher-shell --format plain 'MATCH (tom:Person {name: "Tom Hanks"}) RETURN tom'
``` 

``` 
match (a) -[r] -> () delete a, r;
match (a) delete a;

CREATE (room_1:Room {roomdesc:'testing1'});
CREATE (room_2:Room {roomdesc:'testing2'});
CREATE (room_3:Room {roomdesc:'testing3'});

CREATE 
(room_1) -[:e]-> (room_2),
(room_2) -[:e]-> (room_3),
(room_3) -[:teleport]-> (room_1);
``` 

``` 
curl -X POST -H Accept:application/json -H Content-Type:application/json -u neo4j:testneo4j http://localhost:7474/db/neo4j/tx/commit -d "{\"statements\":[{\"statement\":\"MATCH (n) RETURN n\"}]}"
``` 

https://www.javacodegeeks.com/2016/07/neo4j-cypher-detecting-duplicates-using-relationships.html


# When merging certain 
Certain way is when area and coordinates match. I can mark a whole area as instanced or maybe chaotic if needed. 

# What if the directions have duplicates? 


# How to represent changing exits

If the description names are changing with them then that is great. 

But lets see if we can handle it without. 

If we are certain where we are and the exits changed then mark the exit as: temporary

# Mark return paths from unexplored rooms as "unconfirmed"

If we go there and it dissapears then it is not marked temporary.

# Deciding non-certain

1. Start with room I am in. 
1. get all roomdesc. 
1. Get all matches on any roomdesc in same area.
1. Check if they match exits: temporary exits are optional. 
1. Do the same check for each confirmed exit in common. 
1. Continue breath first until X nodes are confirmed 
    1. If hitting a certian note then increase probability. 

## Alternative

Find path to common point? 

Shortest path to some point. 

# Roomdescriptions could be edge to self

Saw that somewhere, will make it simple to check the above.

# Cascading merges? 

What are the likelyhood of two large networks being duplicates of each other and then suddenly merging? 



# There are the case where going in one direction could lead to multiple different rooms. So a western exit can lead to 5 different rooms. 

## Naive: Default to same direction is same room
Then one note will represent 5 rooms, they will have their own directions and likely some overlapping ones. That seems to be a mess. 

## Agressive: All moves are to a new room until confirmed same
Confirmed either by certainty or non-certain way. 

We will get a lot of new notes. We will still have a working shortest path; it will just have a risk of missing a shortcut. But it is still fine movement. 

We wont lose any information before merging because everything is considered unique. 

High risk of cascading merges; Because a whole networks are generated everytime we take a exit, except if we have some confirmed state on an edge. 


## Assume same rooms until something is different
If same room same direction then assume same room. 

Online check for:
1. certanty hash:
    1. Area name
    1. coordinate 

Offline check for:
1. multiple same exits to see if they can be merged. 
    1. If room has multiple exits then mark them as `multiple_exits` until they do not
        1. These should be avoided by the shortest path if possible. 
1. If any networks looks similar then merge them
    1. Similar is to be defined
1. 





# Register the paths through each area

If I keep track of all the paths I ever did then i can also split things up later. 

Example:
1. a{certain} -> b{uncertain} -> c{uncertain} 

WIP


# Different cases

# One exit goes to many rooms

## If they always go to the same area 
Offline we check each area to figure out if anything can be merged or split. 

### If the exits does not match
We do not know anything before it deviates. When it deviates (maybe many rooms later) then we mark exits as `temporary`. 

### If the exits does match but different rooms

## If they go to different areas
Then the split is right there. 

# One room changes exits

## If the exits 
Mark the exits as temporary. 










# The strategy: Stop 1

## Certain rooms

Simple: Just merge them. New rooms never have exits. 

If entering a certain known room and exits differ, then mark difference as `temporary`: Then I can manually add notes to it later if need be. 

If using the same exit in a certain room leads to different other certain rooms then mark the exits `confirmed_multiple_exits`: I can manually add notes about why that is the case if I want. I should be able to query these points of interest. 

## Uncertain rooms 

Do not assume they are ever the same. When moving from certainty to uncertainty then start a new path every time. 

If I go back an forth then do not assume it is the same room. Just log all the raw data. 

Then offline later: And I do not need to think of that now, then I can try to merge paths in same area into the same network: Optimizing and connecting. 

# The strategy: Stop 2 

Analyse the data and work out some patterns. 

Use the wiki pages to as a facit in some cases. 

Consider not merging uncertain notes, but creating a `is_likely_the_same_not`-edges. 





Some more reading materials:
https://neo4j.com/docs/graph-data-science/current/algorithms/knn/
