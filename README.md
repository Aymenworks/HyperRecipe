# HyperRecipe for iOS

<p align="center">
	<img src="/README/AppIcon.png" width=500/>
</p>

## Introduction

Hello World. My name is **Aymen** and this is my version of the [Hyper Recipe app](https://github.com/hyperoslo/hyper-recipes) and I hope you'll like it.

For those who doesn't know what this project is, it's an application that presents a collection of recipes fetched from Hyper backend or from my stubs ( I admit that the [Unsplash](https://unsplash.com) pictures used for the stubs are quite cool 📸 ). 

I'm an [student and iOS deveveloper](http://www.aymenworks.com) in apprenticeship, switching between school and company, but I like more and more design and user experience. I'm studying computer science so I don't have any basics learned from school, so it's possible that time to time I design an experience or UI  that is not that relevant for the context. Excuse me for that 🤣.

<p align="center">
<img src="/README/SplashScreen.png" width=250/>
<img src="/README/Explore.png" width=250/>
<img src="/README/Add.png" width=250/>
</p>

### To do and improvments :
- If the backend would provide it, it might be cool to have a "Recipe of the day" and think about how we can present it 🤔.
- Implement a sort feature by creation date and a filter for displaying only the favorite ones.
- If, for any reason, it would be necessary to implement a Pull to refresh ( for example in case of lost of connection or new data in the database ),  I though about implementing the super cool [Pull to soupe](https://github.com/Yalantis/PullToMakeSoup) from Yalantis.
- Your opinion ?

## Some interesting things to explore

A few things I particulary found interesting to develop or put into practice :

* The app icon because I'm very bad at it ( if you don't believe me, you can take a look at http://www.aymenworks.com/a-funny-app-icon-design-iteration/ )
* The design : like usual, I use Sketch for designing all kind of stuff, either it's mobile screens or just icons. What's interesting is that I inspire myself from existing designs, and learn from others. For example, I loved how easy to use was the "Number of person" component on the Airbnb iOS app, that's why I created it by myself for the difficulty view ( recipe difficulty between 1 and 3 ).
* The combo MVVM/RxSwift where all the logics is done on the view model and we don't have a Massive View Controller anymore ( even if it can happen! )
* Swinject because it allows me to switch easily between Stubs and Networks services ( by using schemes )

## Dependencies and resources

I make use of the following projects or ressources, so it can be helpful to be
familiar with them:

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [Decodable](https://github.com/Anviking/Decodable)
* [Alamofire](https://github.com/Alamofire/AlamofireImage)
* [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
* [Swinject](https://github.com/Swinject/Swinject)
* [Expanding collection](https://github.com/Ramotion/expanding-collection)
* [Unsplash](https://unsplash.com)
* [Flat Icon](https://www.flaticon.com)


## Find a bug, something interesting, or something you think is unrelevant ?

Let's discuss by [email](mailto:aymenworks.com) or [twitter](https://twitter.com/aymenworks).

## Copyright & License

Released under the MIT License.

Copyright © Aymen Rebouh 🤡.
