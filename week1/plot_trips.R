########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)
library(ggplot2)
library(lubridate)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides
filter(trips, tripduration < quantile(tripduration, .99)) %>% ggplot(aes(x = tripduration/60)) + geom_histogram() +
  scale_y_log10(label = comma) +
  scale_y_continuous(label = comma)

# plot the distribution of trip times by rider type
#ggplot(tmp,aes(x = gender, y= tripduration)) + geom_point()
ggplot(trips) + geom_boxplot(aes(x = usertype, y= tripduration))

# plot the total number of trips over each day

trips %>% group_by(ymd ) %>% summarize(count = n()) %>%
  ggplot(aes(x = ymd, y= count)) + geom_point()

# plot the total number of trips (on the y axis) by age (on the x axis) and age (indicated with color)

trips %>% mutate(age = 2014-birth_year) %>% group_by(gender,age) %>% summarize(count = n()) %>%
   ggplot(aes(x = age, y=count, color = gender)) + geom_point(na.rm = TRUE) 

# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread() function to reshape things to make it easier to compute this ratio

trips %>% mutate(age = 2014 - birth_year) %>% 
  group_by(age,gender)%>% summarize(count=n()) %>% 
  spread(gender, count) %>%
mutate(ratio = Male/Female)%>%
  ggplot(aes(x = age, y = ratio)) + geom_point(na.rm = TRUE)
########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
ggplot(weather,aes(x = ymd, y = tmin)) + geom_point()

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting
weather %>% gather(key = "Type" , value = "Temperature", tmax, tmin) %>% 
  ggplot(aes(x = ymd, y = Temperature, color = Type )) + geom_point()

########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather %>% group_by(ymd, tmin) %>% summarize(count = n()) %>% 
  ggplot(aes(x = tmin, y= count)) + geom_point()


# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
trips_with_weather %>% mutate(check_T_F = prcp>1.3) %>% 
  group_by(ymd, tmin, check_T_F) %>% 
  summarize(count = n()) %>% 
  ggplot(aes(x = tmin, y= count)) + geom_point() + facet_wrap(facets  = ~check_T_F )

# add a smoothed fit on top of the previous plot, using geom_smooth
trips_with_weather %>% mutate(check_T_F = prcp>1.3) %>% 
  group_by(ymd, tmin, check_T_F) %>% 
  summarize(count = n()) %>% 
  ggplot(aes(x = tmin, y= count)) + geom_point() + facet_wrap(facets  = ~check_T_F ) + geom_smooth()

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
trips_with_weather %>% mutate(hour = hour(stoptime)) %>% group_by(hour, ymd)%>% 
  summarize(count = n()) %>% group_by(hour) %>%
  summarise(average = mean(x = count), sd = sd(x = count)) %>% View()
  
  
# plot the above
trips_with_weather %>% mutate(hour = hour(stoptime)) %>% group_by(hour, ymd)%>% 
  summarize(count = n()) %>% group_by(hour) %>%
  summarise(average = mean(count), sd = sd(x = count)) %>% ggplot() + 
  geom_point(aes(x = average, y = sd))
 

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
trips %>% mutate(day = wday(starttime,label = TRUE),hour = hour(starttime)) %>%
  group_by(ymd, day, hour) %>% summarize(count = n()) %>% group_by(hour, day) %>%
  summarize(avg =  mean(count),sd= sd(count)) %>% ggplot(aes(x = hour, y = avg)) + geom_line()+
  geom_ribbon(aes(ymin = avg - sd , ymax = avg + sd), alpha = 0.2) +facet_wrap(~day)
