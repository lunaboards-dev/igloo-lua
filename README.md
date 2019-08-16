# igloo-lua
A wrapper around icekey-lua that adds a few features.

## What's ~~tacked~~ added on?
Igloo adds [CBC](https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher-block_chaining_(CBC)) and [ANSI X9.23 padding](https://en.wikipedia.org/wiki/Padding_(cryptography)#ANSI_X9.23) for data. Note that padding does not use a cryptologically secure random, as that can't be done with pure lua, though I'd imagine it'd be better than all zeros.

## Methods:
* `igloo_instance = igloo.create(level:number, key:string)` - Creates an Igloo instance. Key rules are the same as standard ICE.
* `string = igloo_instance:encrypt(data:string)` - Encrypts data.
* `string = igloo_instance:decrypt(data:string)` - Decrypts data.

## TODO:
* Streaming interface
