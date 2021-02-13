Statement Component | Explanation
--|--
```SELECT``` | List which columns should be in the result table. Can use functions, do calculationis, create new fields, use conditional logic
```FROM``` | List which database tables are used to create the result table. This is where you will join tables together based on their foreign keys
```WHERE``` | Put condition(s) to determine what rows from the database tables should be included in the result table
```GROUP BY``` | Establish fields used to group/aggregate the data
```HAVING``` | Put condition(s) to determine which groups should be included in the result table
```ORDER BY``` | Sort the result table

## CONVERT() Function Parameter
Converting datetime to character:
```CONVERT(VARCHAR, DateNeeded, 107)``` → Jan 10, 2021

Style | Input/Output
--|--
101 | mm/dd/yyyy
107 | mon dd, yyyy
108 | hh:mi:ss
110 | mm-dd-yyyy
112 | yyyymmdd
114 | hh:mi:ss:mm (24-hr clock)
