tty = require 'tty'
crypto = require 'crypto'


# http://stackoverflow.com/questions/4708787/get-password-from-input-using-node-js
#
# @Todo i need a bugfree variant :O
module.exports.readPassword = (fn) ->
  process.stdin.resume()
  process.stdin.setEncoding 'utf-8'
  tty.setRawMode true

  process.stdout.write 'Password:'

  password = ''
  process.stdin.on 'data', (char) ->
    char = char + ''
    switch char
      when '\n', '\r', '\u0004'
        tty.setRawMode false
        process.stdin.pause()
        process.stdout.write '\n'
        fn? password
      when '\u0003'
        process.exit()
      else
        password += char

# Encrypt that shit!
module.exports.encrypt = (message, password) ->
  cipher = crypto.createCipher 'aes-256-cbc', password
  crypted = cipher.update message, 'utf8', 'hex'
  crypted += cipher.final 'hex'

# And decrypt it back. Yay!
module.exports.decrypt = (crypted, password) ->
  decipher = crypto.createDecipher 'aes-256-cbc', password
  message = decipher.update crypted, 'hex', 'utf8'
  message += decipher.final 'utf8'
