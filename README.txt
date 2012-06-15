A backup set is made up of one *.4BK file, one *.4BR and 0 or more *.4BS files.

The 4BR files are backup resource files for a particular backup.

The 4BK file is the initial backup data file.

The 4BS file is a segment file for when a 4BK file overflows

The file name after the site prefix ends in a backup sequence number
and an optional dash and a segment number.

touch -t 8001031305 oldfile  #sets the modification time of oldfile to 13:05 on January 3, 1980.

[109] pry(main)> Time.now.to_i - 60 * 60 * 24
=> 1339147552
[110] pry(main)> Time.at(Time.now.to_i - 60 * 60 * 24)
=> 2012-06-08 02:26:49 -0700
[111] pry(main)> Time.at(Time.now.to_i - (2 * 60 * 60 * 24))
=> 2012-06-07 02:27:03 -0700
[112] pry(main)> Time.at(Time.now.to_i - (10 * 60 * 60 * 24))
=> 2012-05-30 02:27:11 -0700
[113] pry(main)>

