# ratmachine

![Logo](res/logo.png)  
[![Amber Framework](https://img.shields.io/badge/using-amber_framework-orange.svg)](https://amberframework.org)

![Screenie](res/screenie.png)
Ratmachine is an javascriptless anonymous textboard engine with various text effects.  

| markup |   effect    |
|--------|-------------|
|   #    | beveltext   |
|   `    | code        |
|   *    | italic      |
|   **   | bold        |
|   $    | rainbowtext |
|   $$   | shaketext   |
|   %%   | spoiler     |
|   !!   | glowtext    |
|   ==   | redtext     |
|   >    | greentext   |
|   <    | bluetext    |

To start the docker use `make dev`  

To build Ratmachine use `make build`, you will then be able to run ratmachine by executing `bin/ratmachine`.  
On first startup the database will automatically be created and setup, you will then be asked to input a username and password for the mod panel found on `/mod`.
