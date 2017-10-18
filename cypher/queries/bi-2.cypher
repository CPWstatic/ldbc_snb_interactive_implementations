// Q2. Top tags for country, age, gender, time
// :param date1
// :param date2
// :param country1
// :param country2
MATCH
    (country:Country)<-[:isPartOf]-(:City)<-[:isLocatedIn]-(person:Person)
    <-[:hasCreator]-(message:Message)-[:hasTag]->(tag:Tag)
WHERE message.date >= $date1
  AND message.date <= $date2
  AND (country.name = $country1 OR country.name = $country2)
WITH
  country.name AS countryName,
  toInteger(substring(message.creationDate, 5, 2)) AS month,
  person.gender AS gender,
  floor(toFloat(2013-toInteger(substring(person.birthday, 0, 4)))/5) AS ageGroup,
  tag.name AS tagName,
  message
WITH
  countryName, month, gender, ageGroup, tagName, count(message) AS messageCount
WHERE messageCount > 100
RETURN
  countryName,
  month,
  gender,
  ageGroup,
  tagName,
  messageCount
ORDER BY
  messageCount DESC,
  tagName ASC,
  ageGroup ASC,
  gender ASC,
  month ASC,
  countryName ASC
LIMIT 100
