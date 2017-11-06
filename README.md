## Mass Shooting and Gun Control
Since the most recent Las Vegas shooting, the issue of gun control is once again thrust into the spotlight of American political debate and public discourse. Have we succumbed to compassion fatigue? Is the media paying continuous attention to gun control? Does the public follow the media? In this project, I combine three datasets to explore the relationship between mass shooting, media attention, and public interest in gun control.

![](https://raw.githubusercontent.com/roxydu/gun/master/R/plots/Rplot1.png)

I plotted three trends from January 2013 to October 2017 on top of each other - number of deaths from mass shooting in the U.S., U.S. media attention to gun control, and public interest in gun control. 

I joined and recoded three datasets, respectively on [mass shooting](http://www.shootingtracker.com/), [media coverage of gun control issues](https://mediacloud.org/), and [google search trend on gun control issues](https://trends.google.com/trends/). Media attention is measured by number of sentences in American media coverage that contain "gun control," rescaled to values between 0 and 100. Public interest is measured by google search on "gun control" in America, also scaled to values between 0 and 100. All the data are aggregated at the weekly level.

I annotated on the plot four prominent incidents of mass shooting in the past five years - Sandy Hook Elementary shooting, San Bernardino attack, Orlando Pulse Nightclub shooting, and the most recent Las Vegas shooting. Since the mass shooting data only goes back to January 2013, Sandy Hook is not reflected by the red line representing mass shooting deaths. However, its aftermath and impacts are captured by the other two trends. 

A few interesting features can be observed from this graph. First, despite the fact that mass shootings are getting increasingly deadly (shown by the higher and higher peaks in the red line), public interest in the issue of gun control, shown by the blue line, seems to have failed to keep up with the death tolls. Within the time frame of this dataset, public interest in gun control was the highest after Sandy Hook, and it continued to decline at each of the major incidents annotated on the plot. This, unfortunately, seems to confirm [observers' concern](https://twitter.com/dpjhodges/status/611943312401002496?lang=en) that Sandy Hook may have marked a turning point in the gun control debate. 

All is not lost, however, given that the media seems to be doing a decent job at keeping up the discourse on gun control. Unlike the blue line, which exhibits a downward trend, the green line representing media attention seems to fluctuate with mass shooting incidents more consistently, and does not show any trend of continuous decline. 


![](https://raw.githubusercontent.com/roxydu/gun/master/R/plots/Rplot2.png)

This graph contains a scatter plot and a regression line putting public interest against media attention to gun control. Since I am interested in whether public interest follows media coverage, the public interest variable is lagged by one week. The grey area around the line represent the 95% confidence interval. The dots are colored based on number of mass shooting deaths in that particular week. 

This preliminary analysis shows that public interest in gun control does follow media coverage of the issue. In a bivariate regression model, the estimated line has a slope of 0.25 and is statistically significant at the 0.99 confidence level. This means that on average, mass media could still play a positive role in influencing public opinion and potential policy change. 

However, when I included time and an interaction term between media attention and time into the regression model, the results suggest that media's positive influence on public interest shrinks over time. These findings offer a mixed bag of hope and worry. 

### Data Sources
1. mass shooting data 2013-2017 http://www.shootingtracker.com/
2. media data https://mediacloud.org/
3. google search data https://trends.google.com/trends/
