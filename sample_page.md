## Rent prices in Germany - How expensive to rent an apartment can be?

**Project description:** The project is an analysis of the apartments value rent in diferent states in Germany. Some big main cities are included. 
The data was collected in 2019 through API Scrapping techniques from Immowelt website and was stored in Kaggle website.
Despite the fact this data was old, (it was before the pandemic of 2020-2021) it is still relevant today, since the trends did not change after the end of the pandemic.
This project is to answer important business questions, and despite the values are outdated, are still relevant today. The complexity of the dataset and also the size of it make the dataset relevant for a Data analysis project.
The Data passed through the following techniques:
 - Accessment the Data
 - Cleaning the missing and irrelevant values
 - wrangling data
 - analysis using the Python libraries: Matplotlib, Seaborn
 - drawing conclusions and making a Tableau presentation

**Challenges faced**

One of the challenges the project faced was to cleaning the dataset. Since most of the rent descriptions (the data) received the imput from people, that sometimes has no experience in data imput, there were a lot of nonsense values, for example, rents that can be €0 and some of them with the rent of €50.000,00. Adding to this, the scraping technique was not perfect - a lot of data went missing. Cleaning this data was made step by step - and despite removing the empty and null values, the file was still very big. Another situation was to find out what type of visualization will be the best to provide the answers needed.

**Business questions**: Some questions can were proposed by the marketing team, and from products team, working from experts from the industry. They want to develop a report to customers who want to buy properties with the objective of making money from rent. The idea is to advice investors on how to get a good ROI and in case of buying a property that needs repairs, to look at what is the important features they need to looking at. Some of the questions:

- The size of the apartment impacts the value?
- The numnber of rooms can impact a rent value?
- new constructions can be higher in value for the same apartment type or not?
- the heat type can have a impact in rent?
- How much the rent in a certain city can impact the total rent value?

This questions where interpreted from the mentors and experts from the industry, and the first difficulty faced was what they really mean. I translated the initial questions to the ones above, and after that figure out from the dataset how can I answer them.

### 1. Creating correlation map in Seaborn library:

Some of the business questions needs to analyse if some variables have correlations. One of them is as follows: 
<br>
<img src="/images/correlationheatmap.png?raw=true"/>
<br>
Based in this graph, certain features have a strong correlaction with the price, and others not. this can be of importance of the vizualizations later on, and not spending lines of code in variables that have no correlation at all.

### 2. There is also a option of a category map to see if an apartment from a certain number of rooms is cheaper or expensive compared to the average market:
<br>
<img src="/images/categoricalplot.png?raw=true"/>
<br>
This can be helpful to see why these apartments rent are more expensive than others. based on this, it is possible to seee that even before of the pandemic of 2020-2021 there wasa trend in more expensive rent price in apartments through Germany.  

### 3. Conclusions

The conclusions were presented in the github repo, along with the links to the Tableau repository. Some mistakes were made, for example, certain variables proved to be important in the conclusion, and cannot be removed from the analysis. Another situation were to find out another scrap technique to get more accurate results, since about 40% of the data went missing. Another situation needed was to find out the data about property values - and to compare with the rent in the region. This will complete the analysis. However, since there was no way to scrap data from selling properties in the area, it was not possible to calculate the ROI for every region in Germany.  


For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).
