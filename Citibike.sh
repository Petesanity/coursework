
#

# add your solution after each of the 10 comments below

#



# count the number of unique stations
# cut -d, -f4,8 201401-citibike-tripdata.csv|tr ,
'\n' | tail -n +2| sort |uniq|wc -l


# count the number of unique bikes
 cut -d, -f12 201401-citibike-tripdata.csv|tr , '
\n' | tail -n +2| sort |uniq|wc -l


# count the number of trips per day

 cut -d, -f3 201401-citibike-tripdata.csv|tr , '\n' | tail -n +2 | cut -d' ' -f1|sort |uniq -c

# find the day with the most rides

 cut -d, -f3 201401-citibike-tripdata.csv|tr , '\n' | tail -n +2 | cut -d' ' -f1|sort |uniq -c |sort -nr

# find the day with the fewest rides

cut -d, -f3 201401-citibike-tripdata.csv|tr , '\n' | tail -n +2 | cut -d' ' -f1|sort |uniq -c |sort -n

# find the id of the bike with the most rides


cut -d, -f12 201401-citibike-tripdata.csv|tr , '\n' | tail -n +2 | cut -d' ' -f1|sort |uniq -c |sort -n| grep "21076"

# count the number of rides by gender and birth year

 cut -d, -f14,15 201402-citibike-tripdata.csv|tail -n+2 | sort |uniq -c| head -n -1

# count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)



# compute the average trip duration