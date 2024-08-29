%%%
title = "Integration of DNS Domain Names into Application Environments: Motivations and Considerations"
abbrev = "DNS Domain Name Integrations"
ipr= "trust200902"
area = "Internet"
workgroup = "Internet Engineering Task Force"
submissiontype = "IETF"
keyword = ["History", "RFC Series", "Retrospective"]
updates = []

[seriesInfo]
name = "Draft"
value = "draft-sheth-dns-integration-01"
stream = "IETF"
status = "informational"

[[author]]
initials="S."
surname="Sheth"
fullname="S. Sheth"
organization = "Verisign Labs"
  [author.address]
  email = "ssheth@verisign.com"
  uri = "https://www.verisignlabs.com/"
  [author.address.postal]
  street = "12061 Bluemont Way"
  city = "Reston"
  code = "VA 20190"      

[[author]]
initials="A."
surname="Kaizer"
fullname="A. Kaizer"
organization = "Verisign Labs"
  [author.address]
  email = "akaizer@verisign.com"
  uri = "https://www.verisignlabs.com/"
  [author.address.postal]
  street = "12061 Bluemont Way"
  city = "Reston"
  code = "VA 20190"


[[author]]
initials="B."
surname="Newbold"
fullname="B. Newbold"
organization = "Bluesky, PBC"
  [author.address]
  email = "bryan@blueskyweb.xyz"
  uri = "https://www.blueskyweb.xyz/"
  [author.address.postal]
  street = ""
  city = ""
  code = ""      

[[author]]
initials="N."
surname="Johnson"
fullname="N. Johnson"
organization = "ENS Labs"
  [author.address]
  email = "nick@ens.domains"
  uri = ""
  [author.address.postal]
  street = ""
  city = ""
  code = ""     

%%%

.# Abstract

This document reviews the motivations and considerations for integrating DNS domain names into an application environment and provides terminology to establish a shared understanding of what a DNS integration may entail.

{mainmatter}

# Introduction
Domain names have long been used as identifiers in applications. In the early days of the global DNS, domain names were associated with Teletype Network (TELNET) hosts, File Transfer Protocol (FTP) servers, and email services.  Later, domain names were adopted for web browsing.  More recently, blockchain applications, decentralized protocols, and social media platforms have emerged as new use cases for DNS domain names.  How a DNS domain name is enabled for use as an identifier in each of these applications is known as a DNS integration.

DNS integrations can be navigational or notational in nature.  A navigational integration consults information about the application environment that is stored in the DNS zone of a DNS domain name, e.g., to determine how to interact with a target destination. Examples of navigational integrations include FTP and web services (via A and/or AAAA records presenting the server's Internet Protocol address or through the use of HTTPS or SVCB record types) and email services (via a MX record providing the names of the email servers associated with a domain name).

A notational integration is a claim that a DNS domain name is associated with some object or resource by an application environment itself.  Examples of notational integrations include domain validated certificates for the web and other applications and badges on social media platforms stating that a profile is associated with a DNS domain name.  

Some application environments employ both navigational and notational integrations, e.g., web browsing, where a client determines how to interact with a web server via information stored in the DNS, then verifies that it is interacting with the intended server by validating the server's certificate and other public-key infrastructure information.

A key difference between navigational and notational approaches is where the data about the integration exists.  In navigational approaches, authoritative data or a pointer to such data (e.g., CNAME) is in the DNS zone.  As a result, these integrations are eventually consistent based on the data stored in the DNS.

Notational approaches, however, maintain information about the application environment's association with the DNS domain name into their own authoritative data.  This, in turn, introduces the challenge of keeping the application environment's data synchronized with the status of the domain name in the global DNS.  For example, if the DNS domain name is deleted, how does the notational integration eventually recognize this change and reflect it in its own data?

The risks of a DNS integration not maintaining synchronization with the DNS domain name depends on use case and context.  In a social media environment, users might be misled into trusting another user based on the DNS domain name the integration claims they are associated with.  In a blockchain environment, payments might go to the incorrect target destination. For web certificates the browser might trust a certificate for a DNS domain name that is no longer accurate because the domain name has been deleted or re-registered by a different registrant, and erroneously establish a secure connection with a server still operated by the previous registrant of the domain name.  (The web's navigational integration mitigates the latter risk because the DNS information about the application environment will be updated to the new registrant's when the domain name is re-registered, but the certificate itself is still out of synchronization.)

Given the ever-increasing number of application environments using or proposing their own DNS integrations that might encounter such challenges, there is a need to define and advise on how application environments can enable domain names for use as identifiers in a way that avoids or mitigates these challenges.  The approaches that are most appropriate will vary based on the type of application environment, its operational environment, and its users' security objectives.  

A "responsible" DNS integration can be defined as one that takes these concerns into account and addresses them in its design and selection of DNS integrations.  While the techniques will vary, the overall goal for responsible DNS integrations is to allow a DNS domain name to be used within an application environment in a way that provides a consistent user experience (unique identifier across environments) and extends the security, stability, and resiliency of the global DNS.

In support of the development of best practices for responsible DNS integration, this document reviews some of the qualities and considerations that DNS integrations should account for to provide a responsible DNS integration.  It does so by reviewing motivations, use cases, and challenges based on existing DNS integrations.  This document does not currently propose techniques that could be standardized for performing such integrations, but may do so after feedback from the community.

## Intended Audience
This document's discussion applies to both navigational and notational integrations, however some qualities and considerations may apply more to one type of integration.  This document may be treated as providing a list of criteria that can be used to evaluate an integration and identify challenges that should be addressed to avoid synchronization related concerns.

Example DNS integration use cases include, but are not limited to: social media, digital wallets, content authentication, etc.  This document is not limited in scope to these use cases.  Any DNS integration using one of the following mechanisms should consider the qualities and considerations described in this document:

- Integrations that prove domain control by following [@I-D.ietf-dnsop-domain-verification-techniques]
- Integrations that store data associated with the DNS domain name in the domain name's zone
- Integrations that store data associated with the DNS domain name outside of the DNS, e.g., on a well-known endpoint of a web server or on a blockchain

Given the above, the intended audience includes both the application environment providing an integration and the users of an integration who may want to evaluate an integration before using it.

# Terminology
This document uses the terminology from [@RFC9499] as a baseline.  Additional terms applicable to DNS integrations are provided here in alphabetical order:

- Application environment: An application, platform, or protocol
- DNS integration: How a DNS domain name is enabled for use as an identifier in an application environment
- Navigational integration: Consults information about the application environment that is stored in the DNS zone of a DNS domain name
- Notational integration: Consults information about the DNS domain name that is stored in the application environment
- Responsible DNS integration: Takes into account qualities and considerations that provide a consistent user experience and extends the security, stability, and resiliency of the global DNS
- Synchronization: The property that an object integrated into an application environment aligns with its state in its original environment

# Motivations to use DNS Domain Names
Application environments might be motivated to integrate with the global DNS for various reasons: global consistency, universal acceptance, human-readable identifiers, stability, flexibility, verifiability, and to utilize the reputation registrants may have already developed around their use of a DNS domain name.

This section briefly describes these reasons, however additional motivations likely exist.  References to specific examples are used to illustrate the general point, while the appendix contains case studies that describe specific integrations.

## Global Consistency and Universal Acceptance
Application environments might integrate DNS domain names because they want globally consistent, human-friendly identifiers that have (near) universal acceptance throughout deployed software and infrastructure.  Challenges can occur in namespaces that lack (near) universal acceptance, such as those described in ICANN's [@OCTO-034].

## Stability
The global DNS has developed a technical, social, and policy infrastructure over decades that has led to a stable and reliable naming and resolution system.  [@RFC9518, section 4.8] also notes that an application environment may prefer to avoid technical and governance complications related to implementing a naming function of its own by leveraging the existing stability of the DNS protocol.

## Flexibility
The global DNS provides the administrator of a namespace technical flexibility for how to use it.  Examples of this flexibility include which DNS provider to use (including the option to self-host), which DNS records to set, and which subdomains to delegate (if any).

One specific example of this flexibility is how Bluesky can issue subdomains as a user's handle on Bluesky.  When users sign up for a Bluesky account, they can opt to be given a handle under the *.bsky.social domain space.  Bluesky can provide this flexibility because the DNS allows for it.

## Verifiability
DNS provides cryptographic verifiability of DNS zone data through DNSSEC.  DNSSEC is the standards-defined way of digitally signing and verifying DNS data.  For some application environments, such as those being used for payment use cases, this verifiability might be important to ensuring that funds are being appropriately routed.

One example of verifiability is how Ethereum Name Service uses DNSSEC data to validate DNS resource records associated with the given DNS domain name.  Once validated, these records are used by Ethereum Name Service clients to support Ethereum Name Service use cases, such as routing payments.

## Reputation and Brand
Individuals and institutions that have registered a DNS domain name can build a reputation around that DNS domain name over time.  DNS domain names may be considered as part of a brand, e.g., when the DNS domain name is also the name of the company.  In such cases, enabling the registrant to expand the use of their existing DNS domain name into new application environments adds an alternative to creating separate identities on each platform as they can continue to build or leverage their reputation and brand around their existing DNS domain name.

Additionally, if a user is familiar with a DNS domain name and sees that DNS domain name in a well designed DNS integration, then the user might have a reasonable assurance that it is the same DNS domain name as they can resolve in the global DNS, e.g., via web browsing.  This can benefit the integrating application environment as users who identify familiar DNS domain names can quickly bootstrap their existing familiarity into this new context.

# Qualities of a DNS Integration {#challenges}
This section provides qualities that a DNS integration should account for in their specification design.  Failure to account for these might lead to negative outcomes, such as user confusion or name collisions that could provide complications to both the global DNS and application environments using a given DNS integration.  The exact risks depend on the context and design of the integration.

## Domain Name Lifecycle
A DNS integration should account for DNS domain name lifecycle events, such as expiration or change in DNSSEC status.  Such life cycle events might result in a change of control or status of the DNS domain name compared to when it was originally integrated that could require one of the parties involved in the DNS integration to take some action to stay aligned with the state of the DNS domain name in the global DNS.

Failure to account for the DNS domain name lifecycle might result in a DNS integration allowing users other than the current registrant of the DNS domain name to control the DNS domain name in the integration which could lead to confusion.

## Domain Control Validation
A DNS integration should implement validation checks to ensure only the DNS registrant or an authorized party associated with the DNS domain name can establish the integration.  Some examples of domain control validation include storing data in DNS [@I-D.ietf-dnsop-domain-verification-techniques] or storing evidence directly on a server referenced by a DNS domain name.

Failure to perform validation might result in a DNS integration allowing users other than the current registrant of the DNS domain name to control the DNS domain name in the integration which could be confusing. This could lead to a security risk which may break end user trust.

## Completeness
A DNS integration should allow any DNS domain name that meets the integration's technical criteria to be integrated.  Not doing so excludes DNS domain names from participation for non-technical reasons, which could lead to registrant confusion if they are not able to associate their DNS domain name.

## DNS Protocol Evolution
A designer of a DNS integration should be aware that the DNS protocol will evolve over time and such evolutions might impact their DNS integration. For example, DNSSEC algorithms have changed over time as new algorithms are added, and existing algorithms are deprecated.  Failure to account for such changes might pose a security risk, lead to user confusion, or cause a lack of interoperability with the current state of the global DNS.

## Identifier Attribution
A designer of a DNS integration should not assume a DNS domain name is a persistent identifier that always associates to the same DNS registrant.  In practice, DNS domain names may be deleted and re-registered or be transferred, which might result in the previous registrant no longer being associated with the DNS domain name.  Additionally, DNS domain names could be exposed to risks such as DNS hijacking that might temporarily but unexpectedly change who can utilize the DNS domain name.

Integrations should account for such changes in control to avoid potential confusion, e.g., content being mis-attributed to the current registrant that belonged to a previous registrant.

## Variety of DNS Management User Interfaces
A DNS integration might request a user follow certain actions to enable the integration.  For example, a TXT record might need to be set or DNSSEC might need to be configured.  However, each DNS management user interface might expose how to achieve the required actions in different ways.  This introduces friction to the integration process as the user might only know what they need to do -- e.g., add a TXT record -- but not necessarily how to do it.  Integrations might provide advice for how to perform such actions for some interfaces, but it is not feasible to do so for all.

## DNS Record Support
A DNS integration might utilize certain record types but these types might not be widely supported.  For example, new DNS record types will take time to be rolled out to DNS providers or a DNS provider might opt not to support a particular record type.  In such cases, a registrant would need to change to a new DNS provider that could support the required record type.

Some DNS resolvers might fail when encountering new or unexpected record types.  In such cases, a different resolver would need to be utilized or the integration would need to directly handle resolution to ensure reliable access to the data stored in the DNS zone.

# IANA Considerations {#IANA}
This document has no IANA actions.

# Security Considerations {#security_considerations}
This document does not introduce new protocol artifacts with security considerations, however, DNS integrations should account for general DNS related issues including confusable characters such as those discussed in Section 4.4 of [@RFC5890] and resource capacity considerations.

Resource capacity in a DNS integration impacts who is capable of performing the necessary steps to participate in or validate the integration.  For example, if an integration requires DNSSEC then some clients might not be able to perform the necessary cryptographic operations on their own such as IoT devices or human users performing manual validation.  DNS integrations should be cognizant of this potential gap in capabilities and how it could impact their DNS integration.

{backmatter}

# Integration Lessons Learned
## Bluesky
TO BE FILLED IN BY BLUESKY

## Ethereum Name Service
TO BE FILLED IN BY ENS


{numbered="false"}
# Appendix B. Change Log
{empty="true" spacing="normal"}
* 00: Initial draft of the document.
* 01: Change to informational based on feedback received during IETF 120 conversations.

{numbered="false"}
# Acknowledgements
The authors would like to acknowledge the following individuals for their contributions to this document: TBD.

<reference anchor="I-D.ietf-dnsop-domain-verification-techniques" target="https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-domain-verification-techniques-04">
<front>
<title>Domain Control Validation using DNS</title>
<author initials="S. K." surname="Sahib" fullname="Shivan Kaul Sahib">
<organization>Brave Software</organization>
</author>
<author initials="S." surname="Huque" fullname="Shumon Huque">
<organization>Salesforce</organization>
</author>
<author initials="P." surname="Wouters" fullname="Paul Wouters">
<organization>Aiven</organization>
</author>
<author initials="E." surname="Nygren" fullname="Erik Nygren">
<organization>Akamai Technologies</organization>
</author>
<date month="March" day="3" year="2024"/>
<abstract>
<t>
Many application services on the Internet need to verify ownership or control of a domain in the Domain Name System (DNS). The general term for this process is "Domain Control Validation", and can be done using a variety of methods such as email, HTTP/HTTPS, or the DNS itself. This document focuses only on DNS-based methods, which typically involve the application service provider requesting a DNS record with a specific format and content to be visible in the requester's domain. There is wide variation in the details of these methods today. This document proposes some best practices to avoid known problems.
</t>
</abstract>
</front>
<seriesInfo name="Internet-Draft" value="draft-ietf-dnsop-domain-verification-techniques-04"/>
</reference>

<reference anchor="OCTO-034" target="https://www.icann.org/en/system/files/files/octo-034-27apr22-en.pdf">
<front>
<title>Challenges with Alternative Name Systems</title>
<author initials="A. D." surname="Durand" fullname="Alain Durand">
<organization>ICANN OCTO</organization>
</author>
<date month="April" day="27" year="2022"/>
</front>
<!-- <seriesInfo name="Internet-Draft" value="draft-ietf-dnsop-domain-verification-techniques-04"/> -->
</reference>