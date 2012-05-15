# pw

Pw is a simple command line tool to keep track of your passwords.

All passwords will be stored with aes-256-cbc symmetric encryption. (I hope this is a good one!)

It creates the dotfile `.pw` in your home directory which points to the password file. To keep your passwords synced via Dropbox, just point the password file to your Dropbox folder.

To initialize a new password file, type in `pw create`.

    $ pw -h

    pw help
    ===========================

    pw list - List all the passwords
    pw add SERVICE NAME PASSWORD - Add a new password
    pw create - Create the pw-file

