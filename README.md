# Presentador
Presentador is a website that takes Wikipedia content and converts it into a presenation, all automatically. It uses the [Reveal.js](https://github.com/Hackimel/reveal.js) library to make it look like a presentation, but I created the software that inserts the data into the presentation.

Presentador is the 3<sup>rd</sup> iteration of this idea, the first 2 being Instaslides and Presentr. It is by far the most advanced, with the best UI.

## Self-Hosting
Sometimes, the website may go down. If you want to be safe, you can host it yourself. To do that, just follow these simple instructions:

### Requirements
Before you host the website, you must have the following installed:
- CoffeeScript executor
	- Depends on the Node.js executor
- Git
- Gulp
- NPM, which is installed with Node.js
- PM2 (optional)

### Installation Process

1. Download this repo
```shell
git clone https://github.com/AbhinavMadahar/Presentador.git
```
2. Go to that directory
```
cd Presentador
```
3. Install all the NPM modules needed
```
npm install
```
4. Build using Gulp
```
gulp
```
5. Start the app itself using the Coffeescript executor if you want to **test**
```
coffee server.coffee
```
6. Start the app itself using PM2 if you want to **host**
```
pm2 start server.coffee
```

## Technologies Used
It is set up to use websockets to deliver the raw data as JSON via Socket.io, which is why the data can come in as a continuous stream, not just all-at-once. This is because it takes a while for the Wikipedia servers to respond to requests, so it makes sense to send the pages back to the client without waiting for the other pages to load.

I also used 2 of my own modules, `logarithmic` and `easypedia` for their intended purposes.

### Supported Platforms
The platforms tested for are:
- Chrome 44 (Beta)
- Chrome for Android

Does it work or not work on your platform? Make a new issue on GitHub.
