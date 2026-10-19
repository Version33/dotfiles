{
  flake.modules.nixos.hacking-tools =
    { pkgs, ... }:
    {
      environment.systemPackages =
        # Reconnaissance / OSINT
        (with pkgs; [
          amass # OWASP attack surface mapping and external asset discovery
          subfinder # fast passive subdomain discovery
          # assetfinder # find related domains/subdomains (redundant with subfinder)
          # findomain # subdomain enumerator (redundant with subfinder)
          dnsx # fast DNS toolkit for lookups and bruteforcing
          dnsvalidator # find and validate reliable DNS resolvers
          massdns # high-performance DNS stub resolver
          # puredns # massdns wrapper (redundant with massdns)
          # shuffledns # massdns wrapper (redundant with massdns)
          alterx # subdomain alteration/permutation generator
          # dnsrecon # DNS enumeration (obsolete; dnsx/massdns cover)
          # dnsenum # multithreaded DNS enumeration (obsolete)
          # dnsmap # DNS bruteforcer (obsolete)
          # fierce # DNS recon for non-contiguous IPs (obsolete)
          theharvester # gather emails, subdomains, hosts from public sources
          # recon-ng # web recon framework (abandoned)
          # photon # web crawler for OSINT (obsolete)
          # sherlock # social media username hunt (superseded by maigret)
          maigret # collect info about a person by username
          holehe # check if an email is registered on sites
          # socialscan # username/email availability (redundant with maigret)
          # ghunt # OSINT for Google accounts (very niche)
          # waybackurls # fetch URLs from Wayback (gau covers this + more)
          gau # get all URLs from multiple sources (AlienVault, Wayback, etc.)
          # hakrawler # web crawler (katana/httpx cover)
          # httprobe # probe URLs for live HTTP (superseded by httpx)
          # unfurl # extract URLs/entities (niche)
          # qsreplace # replace query string values (niche)
          katana # crawling and spidering framework
        ])
        # Network scanning & discovery
        ++ (with pkgs; [
          nmap # network discovery and security auditing
          masscan # very fast internet-scale port scanner
          rustscan # fast port scanner with nmap integration
          # naabu # fast port scanner (redundant with rustscan)
          arp-scan # ARP-based LAN host discovery
          # arping # ARP ping utility (redundant with arp-scan)
          # netdiscover # passive ARP scanner (redundant with arp-scan)
          fping # ping multiple hosts in parallel
          hping # TCP/IP packet crafting and probing
          mtr # traceroute + ping combined diagnostic
          # tcptraceroute # traceroute over TCP (mtr covers)
          # nbtscan # NetBIOS scanning (obsolete)
          # onesixtyone # SNMP scanner (net-snmp covers)
          net-snmp # SNMP tools (snmpwalk, snmpget)
          # snmpcheck # SNMP enumeration (redundant with net-snmp)
          dnsutils # dig/nslookup/host DNS tools
          # bind # BIND DNS server + dig tools (redundant with dnsutils)
          # drill # dig-style DNS debugger (redundant with dig)
          # ldns # DNS library/drill (redundant with dnsutils)
          # dnsdiag # DNS diagnostics (niche)
          whois # domain/registry WHOIS queries
          # ike-scan # VPN/IPsec scanner (niche)
        ])
        # Vulnerability scanning
        ++ (with pkgs; [
          nuclei # template-based vulnerability scanner
          nuclei-templates # vulnerability templates for nuclei
          nikto # web server scanner
          wpscan # WordPress security scanner
          # joomscan # Joomla scanner (obsolete)
          sqlmap # automatic SQL injection tool
          # commix # command injection tool (niche)
          # wafw00f # WAF identification (whatweb covers fingerprinting)
          whatweb # web technology fingerprinting
          # sslscan # SSL/TLS cipher scanner (superseded by testssl)
          testssl # SSL/TLS configuration tester
          vulnix # NixOS CVE scanner
          trivy # container/IaC/SBOM vulnerability scanner
          # grype # container image scanner (redundant with trivy)
          # syft # SBOM generation (trivy covers SBOM)
          osv-scanner # vulnerability scanner via OSV database
          # zap # OWASP ZAP web scanner (heavy GUI)
        ])
        # Web application analysis
        ++ (with pkgs; [
          # gobuster # dir/DNS bruteforcer (ffuf/feroxbuster cover)
          ffuf # fast web fuzzer
          feroxbuster # recursive content discovery
          # dirb # web content scanner (obsolete)
          # dirbuster # GUI web dir bruteforcer (obsolete)
          # wfuzz # web fuzzer (obsolete; ffuf covers)
          dalfox # XSS scanner and analyzer
          arjun # discover hidden HTTP parameters
          # gospider # web spider (katana covers)
          gf # grep-find patterns for bug hunting
          # burpsuite # web security proxy (heavy GUI)
          interactsh # out-of-band interaction server client
          notify # notification tool for pipeline output
          # tlsx # TLS fingerprinting (httpx covers TLS info)
          # uncover # search engine API wrapper (subfinder covers)
          # fingerprintx # service fingerprinting (nmap covers)
          httpx # HTTP probing toolkit
        ])
        # Password attacks / cracking
        ++ (with pkgs; [
          john # John the Ripper password cracker
          hashcat # GPU-accelerated password recovery
          hydra # online password bruteforcer (many protocols)
          # medusa # parallel login bruteforcer (redundant with hydra)
          # ncrack # network auth cracker (redundant with hydra)
          # ophcrack # Windows LM hash cracker (obsolete)
          # truecrack # TrueCrypt password cracker (TrueCrypt dead)
          bruteforce-luks # LUKS volume password cracker
          fcrackzip # ZIP password cracker
          cewl # custom wordlist generator from target websites
          crunch # wordlist generator
          # rsmangler # wordlist mangler (niche)
          hashcat-utils # hashcat helper utilities
          # hashpump # hash length extension (niche)
          hashid # identify hash types
          # hash-identifier # identify hash types (redundant with hashid)
          # hashdeep # file hash comparison (niche)
          ssdeep # fuzzy hashing / similarity
          # wordlists # common wordlists (superseded by seclists)
          seclists # security-focused wordlists and payloads
          # rockyou # rockyou wordlist (included in seclists)
        ])
        # Wireless attacks
        ++ (with pkgs; [
          aircrack-ng # WiFi WEP/WPA cracking suite
          # wifite2 # wireless auditor (wrapper around aircrack-ng)
          # airgeddon # wireless audit script (wrapper around aircrack-ng)
          # kismet # wireless detector/sniffer (niche)
          # mdk4 # WiFi attack tool (niche)
          # bully # WPS brute-forcer (niche)
          # pixiewps # offline WPS PIN attack (niche)
          # cowpatty # WPA-PSK dictionary attack (obsolete; hashcat covers)
          hcxtools # convert capture formats for hashcat
          hcxdumptool # capture WPA handshakes
          # yersinia # layer-2 attack framework (niche)
        ])
        # Exploitation frameworks
        ++ (with pkgs; [
          metasploit # penetration testing framework
          exploitdb # exploit database and searchsploit
          # routersploit # router exploitation (abandoned)
          evil-winrm # Windows Remote Management shell
          kerbrute # Kerberos user enumeration/bruteforce
          netexec # network exploitation / lateral movement (formerly crackmapexec)
          responder # LLMNR/NBT-NS/mDNS poisoning
          mitm6 # IPv6 MITM / WPAD attack
          python3Packages.impacket # Python network protocol toolkit
        ])
        # Sniffing / MITM
        ++ (with pkgs; [
          wireshark # GUI packet analyzer (includes tshark)
          # wireshark-cli # CLI tools (redundant with tshark)
          # tshark # CLI packet analyzer (bundled with wireshark)
          tcpdump # packet capture
          tcpflow # capture TCP streams to files
          # ngrep # grep network traffic (tcpdump/tcpflow cover)
          # dsniff # sniffing/password suite (bettercap covers)
          # ettercap # MITM attack suite (bettercap covers)
          bettercap # powerful MITM / swiss-army framework
          mitmproxy # interactive HTTPS proxy
          # sslsplit omitted: needs -levent_openssl, removed in libevent
          # 2.1.13; upstream unmaintained. mitmproxy/bettercap cover this.
          # sslstrip # strip HTTPS from connections (obsolete; HSTS defeats it)
          macchanger # spoof MAC address
          netcat-openbsd # networking swiss-army knife (nc)
          # netcat-gnu # GNU netcat (redundant with netcat-openbsd)
          socat # bidirectional data relay
          proxychains # force traffic through a proxy
          tor # anonymity network
          torsocks # socksify apps through Tor
          # privoxy # filtering proxy (niche)
          # dante # SOCKS proxy server (niche)
          # redsocks # redirect connections through proxy (niche)
          # dns2tcp # DNS tunnel (iodine covers)
          iodine # IPv4-over-DNS tunnel
          # dnschef # fake DNS server for testing (niche)
          dnsmasq # DNS/DHCP server
        ])
        # Post-exploitation
        ++ (with pkgs; [
          samba # SMB client (smbclient, nmblookup)
          # enum4linux # Samba enumeration (superseded by enum4linux-ng)
          enum4linux-ng # modern enum4linux rewrite
          freerdp # RDP client
          # rdesktop # RDP client (freerdp supersedes)
          # remmina # remote desktop client (GUI)
          chntpw # Windows SAM password editor
          sqlcmd # SQL Server CLI
          # mariadb # MySQL client/server (heavy; sqlcmd covers)
          # postgresql # PostgreSQL client/server (heavy)
          redis # Redis server/client
          sqlite # SQLite database CLI
          # sqlcipher # encrypted SQLite CLI (niche)
          # tftp-hpa # TFTP client/server (niche)
        ])
        # Reverse engineering
        ++ (with pkgs; [
          # radare2 # RE framework (superseded by rizin)
          rizin # binary analysis framework (radare2 fork)
          ghidra # NSA reverse engineering suite (GUI)
          gdb # GNU debugger
          # gef # GDB enhanced features (pwntools covers exploit-dev)
          pwntools # CTF/exploit development framework
          strace # syscall tracer
          ltrace # library call tracer
          binutils # objdump, strings, and friends
          # elfutils # readelf/ELF tools (redundant with binutils)
          file # file type detection
          binwalk # firmware analysis and extraction
          # boofuzz # fuzz testing framework (niche)
          # angr omitted: nixpkgs 9.2.193 is broken in this revision
          # (setuptools-rust + cargoSetupHook regression); ghidra/rizin/pwntools cover binary analysis.
        ])
        # Forensics
        ++ (with pkgs; [
          # autopsy # digital forensics GUI (heavy GUI)
          sleuthkit # filesystem forensics toolkit
          volatility3 # memory forensics framework
          foremost # file carving
          dc3dd # patched dd for forensics
          ddrescue # data recovery
          # guymager # forensic imaging GUI (heavy GUI)
          testdisk # partition recovery
          # extundelete # undelete ext3/4 (testdisk covers)
          # afflib # AFF forensic image library (niche)
          steghide # steganography tool
          stegseek # steganography cracker
          exiftool # metadata reader/writer
          yara # pattern matching for malware
        ])
        # Defensive / monitoring
        ++ (with pkgs; [
          # snort # network intrusion detection (superseded by suricata)
          suricata # high-performance IDS/IPS
          zeek # network security monitor
          # argus # network audit/flow monitor (niche)
        ])
        # Languages & runtime
        ++ (with pkgs; [
          python3 # Python interpreter
          # perl # Perl interpreter (rarely used as standalone CLI)
          # ruby # Ruby interpreter (rarely used as standalone CLI)
          # php # PHP CLI (rarely used as standalone CLI)
          nodejs # Node.js runtime
          inetutils # telnet, ftp, traceroute, and friends
          python3Packages.scapy # packet manipulation library
        ]);
    };
}
