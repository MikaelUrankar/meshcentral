# these npm modules may be needed, just add them for now
modules="ws@5.2.3
cbor@5.2.0
@yetzt/nedb
https
yauzl
ipcheck
express
archiver@4.0.2
multiparty
node-forge
express-ws@4.0.0
compression
body-parser
cookie-session@1.4.0
express-handlebars
node-windows@0.1.4
loadavg-windows
node-sspi
ldapauth-fork
node-rdpjs-2
ssh2
image-size
acme-client
aedes@0.39.0
mysql
@mysql/xdevapi
mongodb@4.1.0
saslprep
pg@8.7.1
pgtools@0.3.2
mariadb
node-vault
semver
https-proxy-agent
mongojs
nodemailer
@sendgrid/mail
jsdom
esprima
minify-js
html-minifier
archiver-zip-encrypted
googleapis
webdav
wildleek@2.0.0
yubikeyotp
otplib@10.2.3
image-size
twilio
plivo
telnyx
web-push
node-xcs
modern-syslog
syslog
heapdump"

for mod in ${modules}
do
	npm install ${mod} --save
done

