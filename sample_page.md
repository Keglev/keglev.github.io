## Rent prices in Germany - How expensive to rent an apartment can be?

**Project description:** The project is an analysis of the apartments value rent in diferent states in Germany. Some big main cities are included. 
The data was collected in 2019 through API Scrapping techniques from Immowelt website and was stored in Kaggle website.
Despite the fact this data was old, (it was before the pandemic of 2020-2021) it is still relevant today, since the trends did not change after the end of the pandemic.
This project is to answer important business questions, and despite the values are outdated, are still relevant today. The complexity of the dataset and also the size of it make the dataset relevant for a good Data analysis project.
The Data passed through the following techniques:
 - Accessment the Data
 - Cleaning the missing and irrelevant values
 - wrangling data
 - analysis using the Python libraries: Matplotlib, Seaborn
 - drawing conclusions and making a Tableau presentation

## Business questions

- The size of the apartment impacts the value?
- The numnber of rooms can impact a rent value?
- new constructions can be higher in value for the same apartment type or not?
- the heat type can have a impact in rent?
- How much the rent in a certain city can impact the total rent value?

### 1. Creating correlation map in Seaborn library:

Some of the business questions needs to analyse if some variables have correlations. One of them is as follows: 

```# Create a subplot with matplotlib
f,ax = plt.subplots(figsize=(10,10))

# Create the correlation heatmap in seaborn by applying a heatmap onto the correlation matrix and the subplots defined above.
corr = sns.heatmap(sub.corr(), annot = True, ax = ax) # The `annot` argument allows the plot to 
#place the correlation coefficients onto the heatmap.
```

<img src="/images/correlationheatmap.png?raw=true"/>

### 2. There is also a option of a category map to see if an apartment from a certain number of rooms is cheaper or expensive compared to the average market:

```# Create a categorical plot in seaborn using the price categories created above

sns.set(style="ticks")
df_immo_clean = df_immo_clean.sort_values(by=['noRooms'])

g = sns.catplot(x="noRooms", y="livingSpace", hue='Price category', data=df_immo_clean)
```

### 3. Here is the Categorical plot map in Seaborn:

<img src="/images/categoricalplot.png?raw=true"/>


For more details see [GitHub Flavored Markdown](https://guides.github.com/features/mastering-markdown/).
