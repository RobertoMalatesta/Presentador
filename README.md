# Presentador
Presentador is a website that takes Wikipedia content and converts it into a presenation, all automatically. It uses the [Reveal.js](https://github.com/Hackimel/reveal.js) library to make it look like a presentation, but I created the software that inserts the data into the presentation.

Presentador is the 3<sup>rd</sup> iteration of this idea, the first 2 being Instaslides and Presentr. It is by far the most advanced, with the best UI.
## Self-Hosting
If you want to host the website yourself, first install Node.js and then run the following commands:
```bash
sudo npm install gulp -g # used as a build tool
sudo npm install pm2 -g # used to execute the server file
npm run init # installs any packages and builds the webapp
pm2 start server.coffee
```

## Technologies Used
It is set up to use websockets to deliver the raw data as JSON via Socket.io, which is why the data can come in as a continuous stream, not just all-at-once. This is because it takes a while for the Wikipedia servers to respond to requests, so it makes sense to send the pages back to the client without waiting for the other pages to load.

I also used 2 of my own modules, `logarithmic` and `easypedia` for their intended purposes.

### Supported Platforms
The supported platforms come in tiers. All platforms need to have JavaScript available.

It will work for:
- Internet Explorer 8+
- Safari 3+
- Google Chrome 4+
- Firefox 3+
- Opera 10.61+
- iPhone Safari
- iPad Safari
- Android WebKit
- WebOs WebKit

That said, IE8 will only have the slides in 1 long, scrollable page. IE9 and Firefox 3.6 and lower will not have animations.

Does not work on your platform? Make a new issue on GitHub.
