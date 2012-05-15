###
  Awesome pw is awesome.
###

path = require 'path'
fs = require 'fs'
helper = require './helper'

# Shortcut for ~
h = process.env.HOME


# Check if a ~/.pw file exists, if not, create one
unless path.existsSync h + '/.pw'
  fs.writeFileSync h + '/.pw', h + '/pw-file'
  console.log 'Storing passwords at ~/pw-file. Change ~/.pw if you want.'

# Check out where our pw-file is waiting for us :)
pwfile = fs.readFileSync h + '/.pw'
pwfile = pwfile.toString()

what = process.argv[2]
if what? or what is '-h'
 
  # List the password list
  if what is 'list'
    helper.readPassword (password) ->
      fs.readFile pwfile, (err, data) ->
        if err
          console.log 'pw-file does not exist. Use `pw create` first.'
        else
          contents = data.toString()
          contents = helper.decrypt contents, password
          if contents is ''
            console.log '-- Wrong password'
          else if contents is 'pw-file\n'
            console.log '-- File is empty'
          else
            console.log contents.replace 'pw-file\n', ''

  # Add a new password to the list 
  else if what is 'add'

    serv = process.argv[3]
    name = process.argv[4]
    pass = process.argv[5]

    if pass is ''
      console.log 'Wrong data, see `pw -h`'
    else
      helper.readPassword (password) ->
        fs.readFile pwfile, (err, data) ->
          if err
            console.log 'pw-file does not exist. Use `pw create` first.'
          else
            contents = data.toString()
            contents = helper.decrypt contents, password
            if contents is ''
              console.log '-- Wrong password'
            else
              contents += serv + ' ' + name + ' ' + pass + '\n'
              crypted = helper.encrypt contents, password
              fs.writeFileSync pwfile, crypted
              console.log 'Password for ' + serv + ' added.'

  # Create the password file
  else if what is 'create'
    console.log 'To create a new password file, we need a password first.'
    console.log 'Please be sure that the file doesn´t already exist. I´m to lazy to check.'
    helper.readPassword (pw1) ->
      console.log 'Once more, to be sure!'
      helper.readPassword (pw2) ->
        unless pw1 is pw2
          console.log 'Whops, try again.'
        else
          console.log 'Cool. I´ll create that file for you.'

          crypted = helper.encrypt 'pw-file\n', pw1
          fs.writeFileSync pwfile, crypted

  # Command not found ):
  else
    console.log 'Command not found. Try `pw -h'

# Help, bitches love help
else
  console.log 'pw help'
  console.log '===========================\n'
  console.log 'pw list - List all the passwords'
  console.log 'pw add SERVICE NAME PASSWORD - Add a new password'
  console.log 'pw create - Create the pw-file'