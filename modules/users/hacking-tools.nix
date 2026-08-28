{
  flake.modules.nixos.hacking-tools =
    { pkgs, ... }:
    {
      environment.systemPackages =
        # Reconnaissance / OSINT
        (with pkgs; [
          amass # OWASP attack surface mapping and external asset discovery
          subfinder # fast passive subdomain discovery
          assetfinder # find related domains and subdomains from public sources
          findomain # fastest subdomain enumerator
          dnsx # fast DNS toolkit for lookups and bruteforcing
          dnsvalidator # find and validate reliable DNS resolvers
          massdns # high-performance DNS stub resolver
          puredns # fast domain resolver/bruteforcer with wildcard filtering
          shuffledns # massdns wrapper for domain enumeration
          alterx # subdomain alteration/permutation generator
          dnsrecon # DNS enumeration and zone transfer tool
          dnsenum # multithreaded DNS enumeration
          dnsmap # DNS network mapper / subdomain bruteforcer
          fierce # DNS reconnaissance for non-contiguous IP space
          theharvester # gather emails, subdomains, hosts from public sources
          recon-ng # web reconnaissance framework
          photon # fast web crawler for OSINT
          sherlock # hunt down social media usernames
          maigret # collect info about a person by username
          holehe # check if an email is registered on sites
          socialscan # check username/email availability across platforms
          ghunt # OSINT for Google accounts and emails
          maltego # link analysis and data mining for OSINT (GUI)
          waybackurls # fetch known URLs from the Wayback Machine
          gau # get all URLs from multiple sources (AlienVault, Wayback, etc.)
          hakrawler # simple web crawler for endpoint discovery
          httprobe # probe a list of URLs for live HTTP servers
          unfurl # extract URLs and entities from data
          qsreplace # replace query string values in URLs
          katana # crawling and spidering framework
        ])
        # Network scanning & discovery
        ++ (with pkgs; [
          nmap # network discovery and security auditing
          masscan # very fast internet-scale port scanner
          rustscan # fast port scanner with nmap integration
          naabu # fast port scanner
          arp-scan # ARP-based LAN host discovery
          arping # ARP ping utility
          netdiscover # passive ARP-based network scanner
          fping # ping multiple hosts in parallel
          hping # TCP/IP packet crafting and probing
          mtr # traceroute + ping combined diagnostic
          tcptraceroute # traceroute using TCP packets
          nbtscan # NetBIOS name scanning
          onesixtyone # SNMP scanner
          net-snmp # SNMP tools (snmpwalk, snmpget)
          snmpcheck # SNMP enumeration
          dnsutils # dig/nslookup/host DNS tools
          bind # BIND DNS server and dig tools
          drill # dig-style DNS debugger
          ldns # DNS library and drill tool
          dnsdiag # DNS diagnostics (dnsping, dnstraceroute)
          whois # domain/registry WHOIS queries
          ike-scan # VPN/IPsec scanner
        ])
        # Vulnerability scanning
        ++ (with pkgs; [
          nuclei # template-based vulnerability scanner
          nuclei-templates # vulnerability templates for nuclei
          nikto # web server scanner
          wpscan # WordPress security scanner
          joomscan # Joomla vulnerability scanner
          sqlmap # automatic SQL injection tool
          commix # command injection exploitation tool
          wafw00f # identify web application firewalls
          whatweb # web technology fingerprinting
          sslscan # SSL/TLS cipher scanner
          testssl # SSL/TLS configuration tester
          vulnix # NixOS CVE scanner
          trivy # container/IaC vulnerability scanner
          grype # container image vulnerability scanner
          syft # SBOM generation for containers
          osv-scanner # vulnerability scanner via OSV database
          zap # OWASP ZAP web app scanner (GUI)
        ])
        # Web application analysis
        ++ (with pkgs; [
          gobuster # directory/file/DNS bruteforcer
          ffuf # fast web fuzzer
          feroxbuster # recursive content discovery
          dirb # web content scanner
          dirbuster # GUI web directory bruteforcer
          wfuzz # web application fuzzer
          dalfox # XSS scanner and analyzer
          arjun # discover hidden HTTP parameters
          gospider # fast web spider
          gf # grep-find patterns for bug hunting
          burpsuite # web security testing proxy (GUI)
          interactsh # out-of-band interaction server client
          notify # notification tool for pipeline output
          tlsx # TLS fingerprinting and probing
          uncover # search engine API wrapper for discovery
          fingerprintx # service fingerprinting
          httpx # HTTP probing toolkit
        ])
        # Password attacks / cracking
        ++ (with pkgs; [
          john # John the Ripper password cracker
          hashcat # GPU-accelerated password recovery
          hydra # online password bruteforcer (many protocols)
          medusa # parallel network login bruteforcer
          ncrack # high-speed network authentication cracker
          ophcrack # Windows LM hash cracker
          truecrack # TrueCrypt password cracker
          bruteforce-luks # LUKS volume password cracker
          fcrackzip # ZIP password cracker
          cewl # custom wordlist generator from target websites
          crunch # wordlist generator
          rsmangler # wordlist mangler
          hashcat-utils # hashcat helper utilities
          hashpump # hash length extension attack tool
          hashid # identify hash types
          hash-identifier # identify hash types
          hashdeep # compute and compare file hashes
          ssdeep # fuzzy hashing / similarity
          wordlists # common password wordlists
          seclists # security-focused wordlists and payloads
          rockyou # classic rockyou password wordlist
        ])
        # Wireless attacks
        ++ (with pkgs; [
          aircrack-ng # WiFi WEP/WPA cracking suite
          wifite2 # automated wireless auditor
          airgeddon # multi-use wireless audit script
          kismet # wireless network detector/sniffer
          mdk4 # WiFi attack tool (deauth, beacon flood)
          bully # WPS brute-forcer
          pixiewps # offline WPS PIN attack
          cowpatty # WPA-PSK dictionary attack
          hcxtools # convert capture formats for hashcat
          hcxdumptool # capture WPA handshakes
          yersinia # layer-2 attack framework
        ])
        # Exploitation frameworks
        ++ (with pkgs; [
          metasploit # penetration testing framework
          exploitdb # exploit database and searchsploit
          routersploit # router exploitation framework
          evil-winrm # Windows Remote Management shell
          kerbrute # Kerberos user enumeration/bruteforce
          bloodhound # Active Directory privilege mapping
          netexec # network exploitation / lateral movement (formerly crackmapexec)
          responder # LLMNR/NBT-NS/mDNS poisoning
          mitm6 # IPv6 MITM / WPAD attack
          python3Packages.impacket # Python network protocol toolkit
        ])
        # Sniffing / MITM
        ++ (with pkgs; [
          wireshark # GUI packet analyzer
          wireshark-cli # Wireshark CLI tools (capinfos, editcap)
          tshark # CLI packet analyzer
          tcpdump # packet capture
          tcpflow # capture TCP streams to files
          ngrep # grep network traffic
          dsniff # network sniffing/password auditing suite
          ettercap # MITM attack suite
          bettercap # powerful MITM / swiss-army framework
          mitmproxy # interactive HTTPS proxy
          # sslsplit omitted: links -levent_openssl, removed in libevent 2.1.13
          # (upstream sslsplit 0.5.5 unmaintained); mitmproxy/bettercap cover this.
          sslstrip # strip HTTPS from connections
          macchanger # spoof MAC address
          netcat-openbsd # networking swiss-army knife (nc)
          netcat-gnu # GNU netcat
          socat # bidirectional data relay
          proxychains # force traffic through a proxy
          tor # anonymity network
          torsocks # socksify apps through Tor
          privoxy # filtering proxy
          dante # SOCKS proxy server
          redsocks # redirect connections through a proxy
          dns2tcp # DNS tunnel
          iodine # IPv4-over-DNS tunnel
          dnschef # fake DNS server for testing
          dnsmasq # DNS/DHCP server
        ])
        # Post-exploitation
        ++ (with pkgs; [
          samba # SMB client (smbclient, nmblookup)
          enum4linux # Windows/Samba enumeration
          enum4linux-ng # modern enum4linux rewrite
          freerdp # RDP client
          rdesktop # RDP client
          remmina # remote desktop client (GUI)
          chntpw # Windows SAM password editor
          sqlcmd # SQL Server CLI
          mariadb # MySQL client/server
          postgresql # PostgreSQL client/server
          redis # Redis server/client
          sqlite # SQLite database CLI
          sqlcipher # encrypted SQLite CLI
          tftp-hpa # TFTP client/server
        ])
        # Reverse engineering
        ++ (with pkgs; [
          radare2 # reverse engineering framework
          rizin # radare2 fork / binary analysis
          ghidra # NSA reverse engineering suite (GUI)
          gdb # GNU debugger
          gef # GDB enhanced features for exploit dev
          pwntools # CTF/exploit development framework
          strace # syscall tracer
          ltrace # library call tracer
          binutils # objdump, strings, and friends
          elfutils # readelf and ELF tools
          file # file type detection
          binwalk # firmware analysis and extraction
          boofuzz # fuzz testing framework
          # angr omitted: nixpkgs 9.2.193 is broken in this revision
          # (setuptools-rust + cargoSetupHook regression); ghidra/radare2/pwntools cover binary analysis.
        ])
        # Forensics
        ++ (with pkgs; [
          autopsy # digital forensics GUI
          sleuthkit # filesystem forensics toolkit
          volatility3 # memory forensics framework
          foremost # file carving
          dc3dd # patched dd for forensics
          ddrescue # data recovery
          guymager # forensic imaging GUI
          testdisk # partition recovery
          extundelete # undelete ext3/4 files
          afflib # AFF forensic image library
          steghide # steganography tool
          stegseek # steganography cracker
          exiftool # metadata reader/writer
          yara # pattern matching for malware
        ])
        # Defensive / monitoring
        ++ (with pkgs; [
          snort # network intrusion detection
          suricata # high-performance IDS/IPS
          zeek # network security monitor
          argus # network audit/flow monitor
        ])
        # Languages & runtime
        ++ (with pkgs; [
          python3 # Python interpreter
          perl # Perl interpreter
          ruby # Ruby interpreter
          php # PHP CLI
          nodejs # Node.js runtime
          inetutils # telnet, ftp, traceroute, and friends
          python3Packages.scapy # packet manipulation library
        ]);
    };
}
