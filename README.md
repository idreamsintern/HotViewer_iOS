# Ideas Hackathon HotViewer iOS App

## ContentParty
### How to get the ContentParty article list (without content)?
```swift
var contentArticles: [ContentArticle]?
ContentAPI.instance.searchArticleId(["sort": ContentSortType.Click.rawValue, "limit": "10", "page": "1"]) {
(articles: [ContentArticle]?) in
// Here articles is a ContentArticle Array
self.contentArticles = articles
}
```
Note: Before an article is loaded, only 
`article.title` `article.author` `article.siteName` `article.time` properties are available

### How to get a single article (with content)
```swift
// set article to the first ContentParty article
let article = contentArticles[0]

// First check if the content of article has loaded or not
if !article.loaded {
// Not loaded
article.getArticle({
// now all properties of article are available
})
} else {
// Loaded
// article has already been loaded
// all properties are availble
}
```
The following properties are available after an article is loaded `article.url` `article.thumbnailURL` `article.content` `article.rawContent` `article.tag`

## Facebook Checkin
### How to get hot facebook checkins?
```swift
var fbCheckins: [FBCheckin]?

SERAPI.instance.searchFBCheckin(["coordinates": "25.041399,121.554233", "radius": "10", "period": FBCheckinPeriod.Week.rawValue, "sort": FBCheckinSortType.Total.rawValue]) {
(checkins: [FBCheckin]?) in
// Here checkins is FBCheckin Array
self.fbCheckins = checkins
}
```