### Cleansing

1. remove non-meme entries
Memes are classified by 6 categories: 'Meme', 'Subculture', 'Culture', 'Event', 'Person', 'Site'. Entries labeled anything other than 'Meme' are not necessarily considered a meme, rather they might describe some different Internet phenomena. Thus keep entries falling in 'Meme' category only.

2. remove duplicate entries
Out of all entries included in the dataset, ~58% are distinguished by title and URL. Keep the latest modified one among its duplicates. 'last_update_source' tells the date of the last update made to KYM site.

3. remove entries with unconfirmed submission status
Status attribute refers to the meme's submission status to KYM site:
    * 'confirmed': submission is reviewed and approved
	* 'submission': submission is currently being researched and evaluated
	* 'deadpool': submission has been rejected due to incompleteness or lack of notability
	* 'unlisted': (no description)

4. remove entries having sensitive content
Meme entries come from 111 various types - subgroups under 6 bigger categories. There are quite a few types implying sensitive content behind the meme entry such as `crime`, `disaster`, `exploitable`, `fetish`, `religion`.

5. mark the year of creation with NaN for entries having unrealistic values
Some memes are coming ahead of time (one goes as far as 2916) and others date back to medieval times (as early as 11th century), although the concept of Internet meme was introduced back in 1993. Consider entries with the year outside of 1993-2021 range to have unknown year of creation.

6. change 'last_update_source' and 'added' attributes from timestamp to more human-readable format

7. from 'meta' attribute keep only 'og:site_name' and 'og:description' fields. Other fields have no valuable information.

8. add one extra attribute for data source
All meme entries are hosted by 'Know Your Meme' website. Introduce to the schema a field for data source.

9. remove 'ld' attribute
since it doesn't provide any practical information

10. in 'content' attribute keep only the most frequent low-level attributes such as 'about', 'origin', 'external references', 'spread''.
	- in 'about' and 'origin' attributes keep 'text' field only
	- in 'spread' and 'external references' attributes keep 'text' and 'links' field only

11. normalize tags
	- lemmatize tags
	- remove redundant tags
	- remove tags featuring swearing and cursing
	- group together similar tags (optional)

---
### Enrichment

1. from 'origin' section find names of references if present

2. from 'spread' section extract
    - number of external references appeared in the description
    - names of external references like social media platforms, web-sites, newspapers, magazines, organizations, etc.
    - dates mentioning meme's spread
        * the earliest reference year
        * the latest reference year

3. perform sentiment analysis on joint 'description' and 'about' sections

