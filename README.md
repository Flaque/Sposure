# Sposure
A portable exposure therapy game.

![What we're going for](http://i.imgur.com/KwRhBx2.png)

### Table of Contents
1. A note on concurrency
2. Documentation
3. Vocabulary

---

# A note on concurrency

Understanding concurrency in Swift is a big part of understanding this
project. It took me a bit to get it, but you're probably smarter than me
so you'll probably pick it up fast. Either way, here's an overview of
everything you need to know.

### Grand Central Dispatch
Want something to run on a different process in Swift? You need the GCD.
The GCD provides you will multiple different process queues that handle
everything for you.

> The best way to think about GCD is like a list of jobs that you're adding
to.

We use a cocoapod called [`GCDKit`](https://cocoapods.org/pods/GCDKit). GCDKit
doesn't add any extra functionality, but it makes the entire process easier
via syntactic sugar. It's a cleaner any prettier way to interact with the GCD.

### Serial Queues

In `Serial` queues, processes happen one after the other.

![Serial Queue](http://www.raywenderlich.com/wp-content/uploads/2014/09/Serial-Queue-Swift.png)

### Concurrent Queues
In `Concurrent` queues, processes can happen at the same time.

![Concurrent Queue](http://www.raywenderlich.com/wp-content/uploads/2014/09/Concurrent-Queue-Swift.png)


### `.async` calls
A `.async()` call means **the process returns immediately**.

For example:

    var wasHit = false

    myGCD.async() {
      wasHit = true
    }

    print(wasHit)

Will print out `false`.

### `.sync` calls

A `.sync()` call means **the process returns when it's finished**.

For example:

    var wasHit = false

    myGCD.sync() {
      wasHit = true
    }

    print(wasHit)

Will print out `true`.

---

# Documentation
Good documentation means we know what modules are available and are more likely
to use them. Docs allow us to write less code.

## Gif Buffer

_Behold the great doodle that started it all:_

![Magic Image of drawing](http://i.imgur.com/gwWOLwR.jpg)

### Overview

The Gif Buffer is made up of two pieces, each running on their own processes.
The first one is called the `GiphyManager` and the second one is called the
`ImageManager`.

The basic flow is the following:
-  The `GiphyManager` collects URLs (and other stuff) from Giphy.
-  The `GiphyManager` enqueues those URLs into a queue data structure.
-  The `ImageManager` dequeues from the queue and collects the image data from them.
-  The `ImageManager` then enqueues them into another queue that stores all the gifs on the device.
-  The `Main UI` listens for the end of the current gif in the stream and then pulls from the image queue when it's at the end.

YET these processes are are all happening [AT THE SAME TIME](https://www.youtube.com/watch?v=bW7Op86ox9g).


### `GiphyManager`

The `GiphyManager`'s job is to collect and return `Gif` objects.

Inside, there's a requestQueue of `GiphyRequest`s which gets
populated before anything happens. Each `GiphyRequest` is an
object that contains the `offset` and `limit` to be used in
each Giphy request. [More info on Giphy's request system here.](https://github.com/Giphy/GiphyAPI#search-endpoint)

#### GCDs

- `managerGCD`  | serial | Manages the GiphyManager
- `requestGCD`  | serial | Controls the requestQueue
- `responseGCD` | serial | Controls the responseQueue

### `ImageManager`

The `ImageManager`'s job is to pull `Gif` objects from the
`GiphyManger`'s `responseQueue`. If it succeeds in doing this,
it goes to the url and collects image data. Then it creates a
`GifImage` which is an object that contains a `UIView` and
a `Gif`.

#### GCDs

- `managerGCD` | concurrent | Manages the ImageManager
- `imageGCD`   | serial     | Controls the image Queue

### `Searcher`

Handles the communication with the `search` endpoint in giphy.

`ping` - Gets the pagination data from  the search query.

`search` - Actually performs a real search.

### `Imager`

Handles going to the url and collecting the data there.

`findImage` - Goes to the URL, creates a `GifImage` and returns it.


---

# Vocabulary
I have a bunch of bullshitty words that I've been using to describe parts of the
site. One of the things I've disliked when working on other projects is I never
knew what any of the lingo meant. So this is basically a dictionary.

#### `Gif Stream` or `Stream`

This is the part of the app where the user can hold down and see an endless
stream of gifs.

#### `GifBuffer`

The gif buffer is the part of the project that loads in URL's from Giphy
and then goes to each one of those urls and downloads the image.

#### `GCD`

GCD stands for [Grand Central Dispatch](https://www.raywenderlich.com/79149/grand-central-dispatch-tutorial-swift-part-1) and I hate typing that out all the time.
It's synonymous with `process` and in general usage `thread`.

** In code, it specifically refers to a GCD Queue. ** However, it's super
important you don't actually call it just a queue. We also use a Queue
data structure and it gets _REAL CONFUSING REAL FAST GUYS OKAY_.

#### `Resource Queue`

In our concurrency model, the resource queue is for passing data between
one module and another.
