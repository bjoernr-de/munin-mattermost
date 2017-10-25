# Munin Mattermost Notify

Simple script to post [Munin](http://munin-monitoring.org/) alerts to a [Mattermost](https://mattermost.com) channel.

![Munin Mattermost Notify](https://github.com/bjoernr-de/munin-mattermost/raw/master/munin_mattermost_notify.jpg)

A working Mattermost server as well as a working Munin instance is required - Just sayin' `¯\_(ツ)_/¯`

## Installation
1. Simply clone the git repo or download as a zip file. <br />
`git clone https://github.com/bjoernr-de/munin-mattermost.git /tmp/munin-mattermost`
2. Move the script to a place of your choice. We use */etc/munin/* in this example. <br />
`mv /tmp/munin-mattermost/munin_mattermost_notify.sh /etc/munin/`
3. Follow the *Mattermost configuration* section below.
4. Edit the `/etc/munin/munin_mattermost_notify.sh` file with your preferred editor and modify the **variables** section to your setup
5. Make it executable <br />
`chmod +x /etc/munin/munin_mattermost_notify.sh`
6. Finally follow the *Munin configration* steps below.

### Mattermost configration
1. You need to have *Incoming Webhooks* enabled on your Mattermost server. <br />
Check **Custom Integration** in your **System Console**. <br />
Optionally you can activate *Enable integrations to override usernames* and *Enable integrations to override profile picture icons* as well.
2. Create an *Incoming Webhook* in your Mattermost server using the **Integrations** page accessible through the menu. <br />
Choose a *Display Name\**, *Description\** as well as the *Channel* in which the notifications should appear.
3. Copy the webhook URL and proceed with installation step 4

*\* Display name and description can be overwritten by the script if you have activated the features in step 1*

### Munin configuration
1. Edit the `/etc/munin/munin.conf` file with your preferred editor.
2. Copy & Paste the munin configuration from inside the comments in `munin_mattermost_notify.sh` into `munin.conf`
3. If you have used another path than the one in installation step 2 for the script, you need to adjust the path in `contact.mattermost.command`
4. Make sure that `contacts.mattermost.text` is a one-liner and you have copied the whole line.
5. Restart munin

