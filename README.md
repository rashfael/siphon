# Goal
Service to save your favorite bits of internet.
subscribe and scrape stuff.

# Approaches

## Server Side Scraping
Send an url to the server, it figures out the rest
Pros:
- No browser plugin needed
- CLI/IRC possible

Cons:
- can't get secured content
- identifying arbitrary data to a mime type is difficult

## Browser Extension, send data the browser received

Pros:
- Data is already requested, WYGIWYS

Cons:
- Getting image data from the browser sucks balls
- Sending binary to server / over websockets sucks butts

Go with server side first, figure secured content out later