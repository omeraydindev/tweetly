# tweetly
A very basic Twitter clone I wrote as my first Flutter project.

Since this project was put together in a very short time and solely for learning purposes, I didn't use fancy state management solutions like [Riverpod](https://riverpod.dev/) or [BLoC](https://bloclibrary.dev/) -- instead, I called `setState` everywhere, passed callbacks and [ValueNotifier](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html)s down the widget tree etc.

## I find a bug
Contact me

## Features
Some features include: Posting a tweet, retweeting, replying to tweets, liking tweets, following other users, editing your profile, searching in all users and a few more. Threads don't exactly work like you'd expect them to, but that was beyond the scope of this project.

## Tech stack
I wrote a Node.js/Express [backend](https://github.com/MikeAndrson/tweetly_backend) and used [MongoDB](https://www.mongodb.com/) as the database there.

## Setting up
Set up the [backend](https://github.com/MikeAndrson/tweetly_backend) first with the instructions in its README, then change the following field in [constants.dart](lib/constants.dart):
```dart
// Host URL
const host = "https://tweetly-backend.herokuapp.com";
```

## Screenshots
Home | Thread | Profile
:-------------------------:|:-------------------------:|:-------------------------:
![home](https://user-images.githubusercontent.com/45513948/187016966-d4c29674-8b9e-4885-a88d-eab7abd87fda.png)  |  ![thread](https://user-images.githubusercontent.com/45513948/187016969-d4bad4cf-ce6f-4de2-8b0e-9ca19f2193e9.png) | ![profile](https://user-images.githubusercontent.com/45513948/187016971-56f91d28-5432-4b71-8a71-d5cd2f12f531.png)

## License
This project is licensed under **GNU General Public License v3.0**, see [LICENSE](LICENSE) for more.
