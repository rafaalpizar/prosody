-- see example config at https://hg.prosody.im/0.9/file/0.9.10/prosody.cfg.lua.dist
-- easily extendable by putting into different config files within conf.d folder

local stringy = require "stringy" 

admins = stringy.split(os.getenv("PROSODY_ADMINS"), ", ");

pidfile = "/var/run/prosody/prosody.pid"

use_libevent = true; -- improves performance

allow_registration = os.getenv("ALLOW_REGISTRATION");

c2s_require_encryption = os.getenv("C2S_REQUIRE_ENCRYPTION");
s2s_require_encryption = os.getenv("S2S_REQUIRE_ENCRYPTION");
s2s_secure_auth = os.getenv("S2S_SECURE_AUTH");

authentication = os.getenv("AUTHENTICATION") or "internal_hashed";

ldap_base = os.getenv("LDAP_BASE");
ldap_server = os.getenv("LDAP_SERVER") or "localhost";
ldap_rootdn = os.getenv("LDAP_ROOTDN") or "";
ldap_password = os.getenv("LDAP_PASSWORD") or "";
ldap_filter = os.getenv("LDAP_FILTER") or "(uid=$user)";
ldap_scope = os.getenv("LDAP_SCOPE") or "subtree";
ldap_tls = os.getenv("LDAP_TLS") or "false";
ldap_mode = os.getenv("LDAP_MODE") or "bind";
ldap_admin_filter = os.getenv("LDAP_ADMIN_FILTER") or "";

log = {
    -- Log all error messages to prosody.err
    {levels = {min = "error"}, to = "file", filename = "/usr/local/var/lib/prosody/logs/prosody.err"};
    -- Log everything of level "info" and higher (that is, all except "debug" messages)
    -- to prosody.log
    {levels = {min = os.getenv("LOG_LEVEL")}, to = "file", filename = "/usr/local/var/lib/prosody/logs/prosody.log"};
};

Include "conf.d/*.cfg.lua";
