/* 1. What is the most common source that meme entries originate from? */
SELECT ORIGIN,
	SUM(COUNT) AS COUNT
FROM fact_table
LEFT JOIN origin_dimension ON fact_table.ORIGIN_ID = origin_dimension.ORIGIN_ID
GROUP BY ORIGIN
ORDER BY COUNT DESC LIMIT 1;
/* Answer: YouTube */

/* 2. What sub-category (type) of memes was the most popular in the period from 2016 to 2018? */
SELECT type_dimension.MEME_TYPE,
	COUNT(*)
FROM fact_table
LEFT JOIN date_dimension ON fact_table.DATE_ID = date_dimension.DATE_ID
LEFT JOIN type_dimension ON fact_table.TYPE_ID = type_dimension.TYPE_ID
WHERE date_dimension.YEAR BETWEEN 2016 AND 2018
GROUP BY MEME_TYPE
ORDER BY COUNT DESC;
/* Answer: 'No type', followed by 'catchphrase' */

/* 3. What year produced the largest number of memes featuring any catchphrase? */
SELECT date_dimension.YEAR,
	COUNT(*)
FROM fact_table
LEFT JOIN date_dimension ON fact_table.DATE_ID = date_dimension.DATE_ID
LEFT JOIN type_dimension ON fact_table.TYPE_ID = type_dimension.TYPE_ID
WHERE type_dimension.MEME_TYPE = 'catchphrase'
GROUP BY date_dimension.YEAR
ORDER BY COUNT DESC;
/* ANSWER: 2009 */

/* 4. What year has seen the highest number of submissions to the KYM database? */
SELECT COUNT(*),
LEFT(ADDED_TO_KYM, 4) AS YEAR
FROM additional_analysis_table
GROUP BY YEAR
ORDER BY COUNT DESC;
/* ANSWER: 2009 */

/* 5. What are the most common tags among different memes types? */
SELECT type_dimension.MEME_TYPE,
	MODE() WITHIN GROUP (
		ORDER BY tag_dimension.TAG
	) AS MOST_FREQUENT_TAG
FROM fact_table
LEFT JOIN tag_dimension ON fact_table.TAG_ID = tag_dimension.TAG_ID
LEFT JOIN type_dimension ON fact_table.TYPE_ID = type_dimension.TYPE_ID
GROUP BY MEME_TYPE;
/* ANSWER: See output */

/* 6. How many tags on average are assigned to meme entries? */
SELECT (AVG(LENGTH(tags) - LENGTH(REPLACE(tags, ',', '')))) AS avg_tags 
FROM additional_analysis;
/* ANSWER: 7.3976293103448276 */

/* 7. What meme had the most long-lasting search interest? */
SELECT TITLE,
	(SPREAD_YEAR_MAX - SPREAD_YEAR_MIN) AS SPREAD_DURATION
FROM additional_analysis_table
WHERE SPREAD_YEAR_MIN <> 'NaN'
ORDER BY SPREAD_DURATION DESC;
/* ANSWER: "Super S Stussy" */

/* 8. What are the top 5 external sources that meme entries get spread over most frequently? */
SELECT UNNEST(STRING_TO_ARRAY(SPREAD_REFERENCES, ',', '')) AS SPREAD_REF,
	COUNT(*) AS COUNT
FROM additional_analysis_table
WHERE SPREAD_REFERENCES IS NOT NULL
GROUP BY SPREAD_REF
ORDER BY COUNT DESC
LIMIT 5;
/* ANSWER: Reddit, Tumblr, Facebook, Urban Dictionary, Twitter */

/* 9. What objects are commonly present in meme entries having high unsafe search likelihood? */
/* 10. What tags are associated with a decrease in the meme image's safety property in various categories (e.g. adult, spoof, medical, violence, racy)? */
SELECT TITLE,
	(SAFESEARCH_ADULT + SAFESEARCH_MEDICAL + SAFESEARCH_RACY + SAFESEARCH_SPOOF + SAFESEARCH_VIOLENCE) / 5 AS UNSAFETY,
	MEME_TYPE,
	TAGS
FROM additional_analysis_table
WHERE SAFESEARCH_ADULT <> 'NaN'
ORDER BY UNSAFETY DESC
/* ANSWER: Among the tags of the first 10 memes, we notice 'kittiestitties4ever', 'rape', 'boobs, boobies, breasts', 'anal sex, horse sex' and 'violent, violence' */

/* 11. Show the number of the memes per year in ascending order. */
SELECT COUNT(*), date_dimension.YEAR
FROM fact_table
LEFT JOIN date_dimension ON fact_table.DATE_ID = date_dimension.DATE_ID
GROUP BY date_dimension.YEAR
ORDER BY count ASC;
/* ANSWER: see result. */

/* 12. What is the percentage of memes with male content vs female content (tags)? */
SELECT
	(SELECT 100 * COUNT(*)::decimal /
			(SELECT COUNT(*)::decimal
				FROM additional_analysis_table
				WHERE NOT TAGS ISNULL) AS FEMALE_PCT
		FROM additional_analysis_table
		WHERE (TAGS SIMILAR TO '(%woman%)|(%female%)|(%girl%)')) 
	AS FEMALE_PCT,

	(SELECT 100 * COUNT(*)::decimal /
			(SELECT COUNT(*)::decimal
				FROM additional_analysis_table
				WHERE NOT TAGS ISNULL) AS MALE_PCT
		FROM additional_analysis_table
		WHERE (TAGS SIMILAR TO '(%man%)|(%male%)|(%boy%)' 
				AND NOT TAGS SIMILAR TO '(%woman%)|(%female%)|(%girl%)')) 
	AS MALE_PCT;
/* ANSWER: 2.4% feature something female and 10.5% feature something male*/

/* 2.2. Find the most frequent DBpedia schema types. */
SELECT DBSCHEMA,
	COUNT
FROM
	(SELECT UNNEST(STRING_TO_ARRAY(TYPES_SCHEMA, ',', '')) AS DBSCHEMA,
			COUNT(*) AS COUNT
		FROM additional_analysis_table
		WHERE TYPES_SCHEMA IS NOT NULL
		GROUP BY DBSCHEMA) AS SUBQUERY1
WHERE DBSCHEMA IS NOT NULL
ORDER BY COUNT DESC;
/* ANSWER: Most frequent are CreativeWork, followed by WebSite and Person*/