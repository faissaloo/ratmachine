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

In order to use the mod tools you will need to add a user to the database manually, replace `<YOUR PASSWORD>` in the crystal code below with the password you want to use for your admin user, then compile and run it to generate the command you will need to run in your shell to add the user.
```
require "crypto/bcrypt/password"
puts "psql --dbname=\"ratmachine\" -c \"INSERT INTO users VALUES (1, 'admin', '#{Crypto::Bcrypt::Password.new("<YOUR PASSWORD>")}');\""
```
For your test server replace `ratmachine` with `ratmachine_development`.
