# GitGet app for iOS

This is a test app that showcases some of the features iOS frameworks provide. It is written in Objective-C, uses UIKit and relies on no external libraries.

### Features

- Search of github users by login, displaying of avatars as well as their logins in list
- A detail view with information on selected user
- List of selected user's repos
- List of selected user's followers
- Adopts to to all rotations and sizes
- Doomy (why have dummy when you can have doomy, right?) default info, for no reason what so ever
- Lists are pulled in chunks of 50
- Repos are limited to 50
- Followers are limited to 50
- Images are cached to disk

### TODO

- IndicatorView so paging actually shows users what's happening
- Persistence of query results to sqlite db
- Unit tests
- Proper image assets for all sizes
- Fonts
- i18n

### License

Released under the Apache 2.0 License.
