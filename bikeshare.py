import pandas as pd
import datetime
import calendar

print('Hello! Let\'s explore some US bikeshare data!')

def get_city():
    """
    Asks user to specify a city to analyze.
    Returns:
        (str) city - name of the city to analyze or demeaning response if city isn't found
    """
    city = ''
    city_dict = {'new york city', 'washington', 'chicago'}
#while loop to populate city variable as long as it's in the list provided
    while city.lower() not in city_dict:
        city = input('\nPlease input in which city you would like to see data from the following list: Chicago, New York City, or Washington?\n')
#criteria to run through various user inputs to return the correct csv files if the input exists
        if city.lower() == 'new york city':
            return 'new_york_city.csv'
        elif city.lower() == 'chicago':
            return 'chicago.csv'
        elif city.lower() == 'washington':
            return 'washington.csv'
#if input does not exist, prints mean comment and asks for the correct input again
        else:
            print('It looks like directions are too hard for your tiny brain to comprehend :).')
            return get_city()
    # TO DO: get user input for month (all, january, february, ... , june)
def get_time_period():
    '''Requests user input for time period.
    Arguments: None
    Returns:(str) Filter for time in bikeshare dataset
    '''
    time_period = input('\nWould you like to filter the data by month, day, or all? Type "all" for no time filter.\n')
    if time_period.lower() == 'month':
        return ['month', get_month()]
    elif time_period.lower() == 'day':
            return ['day', get_dow()]
    elif time_period.lower() == 'all':
        return ['all', 'all']
    else:
        print('\nThe input you selected is outside the optional variables, please try again.\n')
        return get_time_period()

def get_month():
    '''Requests user input for which month they would like to see data
    Arguments: None
    Returns:(str) Filter for month in bikeshare dataset
    '''
    month = input ('\nWhat month between January and June would you like to filter by?\n').lower()
    if month == 'january':
        return '01'
    elif month == 'february':
        return '02'
    elif month == 'march':
        return '03'
    elif month == 'april':
        return '04'
    elif month == 'may':
        return '05'
    elif month == 'june':
        return '06'
    else:
        print ('Seriously, please follow directions.')
        return get_month()

    # TO DO: get user input for day of week (all, monday, tuesday, ... sunday)
def get_dow():
    '''Requests user input for which day of the week they would like to see data. Day of week abbreviated as 'dow'
    Arguments: None
    Returns:(str) Filter for day in bikeshare dataset
    '''
    dow = input ('\nWhat day from Monday through Sunday would you like to filter by?\n').lower()
    if dow == 'monday':
        return 0
    elif dow == 'tuesday':
        return 1
    elif dow == 'wednesday':
        return 2
    elif dow == 'thursday':
        return 3
    elif dow == 'friday':
        return 4
    elif dow == 'saturday':
        return 5
    elif dow == 'sunday':
        return 6
    else:
        print ('Can you just be cool for once and please follow directions?')
        return get_dow()

    # TO DO: display the most common month
def common_month(df):
    '''Groups count of months from 'Start Time' column
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Most popular month for this city by returning the 0 index of the month ordered by count descending
    '''
    monthly_trips = df.groupby('month')['Start Time'].count()
    print('\nTime Parameters:')
    return 'Most popular month for this city: ' + calendar.month_name[int(monthly_trips.sort_values(ascending=False).index[0])]

    # TO DO: display the most common day of week
def common_dow(df):
    '''Groups count of day from 'Start Time' column
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Most popular day for this city by returning the 0 index of the day of the week ordered by count descending
    '''
    daily_trips = df.groupby('dow')['Start Time'].count()
    return 'Most popular day of week for this city: ' + calendar.day_name[int(daily_trips.sort_values(ascending=False).index[0])]
    
    # TO DO: display the most common start hour
def common_hour(df):
    '''Groups count of hour of day from 'Start Time' column and counts the number of times it shows up. Sorts trips_by_hour by count of hours descending. Formats the hour in 24 hour format to be used     in the return section.
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Most popular hour for this city by returning the 0 index of the hour ordered by count descending formatted by removing zero padded values with AM or PM
    '''
    trips_by_hour = df.groupby('hour')['Start Time'].count()
    most_pop_hour = trips_by_hour.sort_values(ascending=False).index[0]
    hour_int = datetime.datetime.strptime(most_pop_hour, '%H')
    return 'Most popular hour of the day based on start time for this city: ' + str(hour_int.strftime('%-H'))
    
    # TO DO: display most commonly used start station
def most_used_start_station(df):
    '''Groups count of 'Start Station' names from 'Start Station' column in dataframe then uses descending order to order by the count
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Most popular Start Station for this city by returning the 0 index of the Start Station
    '''
    count_of_start_station = df.groupby('Start Station')['Start Station'].count()
    sorted_start_values = count_of_start_station.sort_values(ascending=False)
    print('\nCommonly Used Station Information: ')
    return 'Most popular start station for this city: ' + sorted_start_values.index[0]

    # TO DO: display most commonly used end station
def most_used_end_station(df):
    '''Groups count of 'End Station' names from 'End Station' column in dataframe then uses descending order to order by the count
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Most popular End Station for this city by returning the 0 index of the End Station
    '''
    count_of_end_station = df.groupby('End Station')['End Station'].count()
    sorted_end_values = count_of_end_station.sort_values(ascending=False)
    return 'Most popular end station for this city: ' + sorted_end_values.index[0]

    # TO DO: display most frequent combination of start station and end station trip
def most_used_route(df):
    '''Groups count of 'Start Station' and 'End Station' fields to yield the most used route
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Most popular 'Start Station' and 'End Station' for this city by returning the 0 indexes of the combination of both stations
    '''
    route_count = df.groupby(['Start Station', 'End Station'])['Start Time'].count()
    sorted_route = route_count.sort_values(ascending=False)
    return 'Most popular route for this city: ' + sorted_route.index[0][0]

    # TO DO: display total travel time
def total_travel_time(df):
    '''Takes sum of Trip Duration and applies to it to a variable
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Total travel time for this city in seconds
    '''
    total_travel_time = df['Trip Duration'].sum()
    print('\nTotal and Average Travel Times:')
    return 'Total travel time for this city: ' + str(total_travel_time) + ' seconds.'

    # TO DO: display mean travel time
def avg_travel_time(df):
    '''Takes mean(average) of Trip Duration and applies to it to a variable
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Average travel time for this city in seconds
    '''
    avg_trip_duration = df['Trip Duration'].mean()
    return 'Average travel time for this city: ' + str(avg_trip_duration) + ' seconds.'

    # TO DO: Display counts of user types
def user_type_count(df):
    '''Applies the value_counts method against the dataframe(df) column 'User Type'
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Count of each value in this column
    '''
    user_types = df['User Type'].value_counts()
    return '\nUser Type Counts for This City: \n' + str(user_types)

    # TO DO: Display counts of gender
def gender_count(df):
    '''Applies the value_counts method against the dataframe(df) column 'Gender'
    Arguments: dataframe(df) of bikeshare data
    Returns:(str) Count of each value in this column
    '''
    gender = df['Gender'].value_counts()
    return '\nGender Counts for This City: \n' + str(gender)

    # TO DO: Display earliest, most recent, and most common year of birth
def birth_year(df):
    '''Applies the min, max, and mode methods against the dataframe(df) column 'Birth Year'
    Arguments: dataframe(df) of bikeshare data
    Returns:(list) Oldest user birth year, youngest user birth year, most common birth year
    '''
    oldest_user = 'The oldest user was born in: ' + str(int(df['Birth Year'].min()))
    youngest_user = 'The youngest user was born in: ' + str(int(df['Birth Year'].max()))
    birth_year_most_common = 'The most common birth year was: ' + str(int(df['Birth Year'].mode()))

    return [oldest_user, youngest_user, birth_year_most_common]

    # TO DO: Display additional 5 lines of data is requested by user via input prompt
def five_lines_of_data(df, data_location):
    '''Displays five lines of data upon the users request. If they would not like to see the data they can respond with 'no'
    Arguments: dataframe(df) of bikeshare data, currentl location of data
    Returns: Five lines of user data from the city input by the user, if the user requests more data by typing yes they will see five more lines until they hit no
    '''
    data = input('\nWould you like to see additional raw data from individual trips in this city? Please type "yes" or "no".\n')
    data = data.lower()
    if data == 'yes':
        print(df.iloc[data_location:data_location+5])
        data_location += 5
        return five_lines_of_data(df, data_location)
    elif data == 'no':
        return
    else:
        print('\nPlease follow the constraints of the question below.\n')
        return five_lines_of_data(df, data_location)

def main_stats():
    '''Populates the variables city and df_city
    Arguments: none
    Returns: none
    '''
    city = get_city()
    df_city = pd.read_csv(city)
    
    def get_day_of_week(str_date):
        '''Changes day of week into integer format
        Arguments: str_date: yyyy-mm-dd date format
        Returns:(int) Day of the week expressed as an integer value
        '''
        date_obj = datetime.date(int(str_date[0:4]), int(str_date[5:7]), int(str_date[8:10]))
        return date_obj.weekday()
    #store dow (day of week using ".apply()" method), month by stripping values from the 'Start Time' using the index, and hour by stripping values from the 'Start Time' using the index values for         #each row in their own columns.
    df_city['dow'] = df_city['Start Time'].apply(get_day_of_week)
    df_city['month'] = df_city['Start Time'].str[5:7]
    df_city['hour'] = df_city['Start Time'].str[11:13]        
    # Filter by user entered time period
    time_period = get_time_period()
    filter_period = time_period[0]
    filter_period_value = time_period[1]
    filter_period_label = 'no filter'

    if filter_period == 'all':
        df_filtered = df_city
    elif filter_period == 'month':
        df_filtered = df_city.loc[df_city['month'] == filter_period_value]
        filter_period_label = calendar.month_name[int(filter_period_value)]
    elif filter_period == 'day':
        df_filtered = df_city.loc[df_city['dow'] == filter_period_value]
        filter_period_label = calendar.day_name[int(filter_period_value)]

    # TO DO: display the most common month
    if filter_period == 'all' or filter_period == 'day':
        print(common_month(df_filtered))

    # TO DO: display the most common day of week
    if filter_period == 'all' or filter_period == 'month':
        print(common_dow(df_filtered))

    # TO DO: display the most common start hour
    print(common_hour(df_filtered))

    # TO DO: display most commonly used start station
    print(most_used_start_station(df_filtered))

    # TO DO: display most commonly used end station
    print(most_used_end_station(df_filtered))

    # TO DO: display most frequent combination of start station and end station trip
    print(most_used_route(df_filtered))

    # TO DO: display total travel time
    print(total_travel_time(df_filtered))

    # TO DO: display mean travel time
    print(avg_travel_time(df_filtered))
        
    # TO DO: Display counts of user types
    print(user_type_count(df_filtered))
    
    #Washington has no gender/birth_year information provided so it has been removed from this part of the script
    if city == 'chicago.csv' or city == 'new_york_city.csv': 
    # TO DO: Display counts of gender
        print(gender_count(df_filtered))

    # TO DO: Display earliest, most recent, and most common year of birth
        print('\nOldest, Youngest, and Most Common Birth Years for this city: ')
        print(birth_year(df_filtered)[0])
        print(birth_year(df_filtered)[1])
        print(birth_year(df_filtered)[2])

    # TO DO: Display additional 5 lines of data is requested by user via input prompt
    five_lines_of_data(df_filtered, 0)

    # Would you like to restart the program?
    def restart_question():
        '''Restarts the program if prompted so by the user input
        Args:
            none.
        Returns:
        '''
        restart = input('\nWould you like to restart this program? Type \'yes\' or \'no\'. The program will end if \'no\' is entered.\n')
        if restart.lower() == 'yes':
            main_stats()
        elif restart.lower() == 'no':
            return
        else:
            print("\nThis is a simple yes or no question. Please follow the instructions.")
            return restart_question()

    restart_question()


if __name__ == "__main__":
    main_stats()