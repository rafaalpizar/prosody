local domain = os.getenv("DOMAIN")
local domain_http_upload = os.getenv("DOMAIN_HTTP_UPLOAD")
local domain_muc = os.getenv("DOMAIN_MUC")
local domain_proxy = os.getenv("DOMAIN_PROXY")
local domain_pubsub = os.getenv("DOMAIN_PUBSUB")

-- XEP-0368: SRV records for XMPP over TLS
-- https://compliance.conversations.im/test/xep0368/
legacy_ssl_ssl = {
	certificate = "certs/" .. domain .. "/fullchain.pem";
	key = "certs/" .. domain .. "/privkey.pem";
}
legacy_ssl_ports = { 5223 }

-- https://prosody.im/doc/certificates#service_certificates
-- https://prosody.im/doc/ports#ssl_configuration
https_ssl = {
	certificate = "certs/" .. domain_http_upload .. "/fullchain.pem";
	key = "certs/" .. domain_http_upload .. "/privkey.pem";
}

VirtualHost (domain)

-- Set up a http file upload because proxy65 is not working in muc
Component (domain_http_upload) "http_file_share"
	  http_file_share_expires_after = 60 * 60 * 24 * 7 -- a week in seconds
	  http_file_share_size_limit = 350*1024*1024 -- 350 MiB
	  http_file_share_daily_quota = 500*1024*1024 -- 500 MiB per day per user
	  http_file_share_global_quota = 10*1024*1024*1024 -- 10 GiB total
	  http_file_share_allowed_file_types = {"image/*","video/*","audio/*","text/*","application/*","*/*"}

Component (domain_muc) "muc"
	name = "Prosody Chatrooms"
	restrict_room_creation = false
	max_history_messages = 20
	modules_enabled = {
		"muc_mam",
		"vcard_muc"
	}

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers
Component (domain_proxy) "proxy65"
	proxy65_address = domain_proxy
	proxy65_acl = { domain }

-- Implements a XEP-0060 pubsub service.
Component (domain_pubsub) "pubsub"
