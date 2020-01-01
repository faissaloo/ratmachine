# ratmachine

![Logo](res/logo.png)  
[![Amber Framework](https://img.shields.io/badge/using-amber_framework-orange.svg)](https://amberframework.org)

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

You can delete posts from `/mod` with the password you've configured with `make config` (for production) under `secrets: root_password:`.
