# ĐOor

## Everything's decentralized but not your Đoor: ticket verification by proving user signatures 

### Rationale: why is the door of Dappcon / ETHBerlinZwei operated by h00mans? :thinking: :robot: 

How long do you stand in line until you get into an event for decentralized apps? Why is it still not possible to prove your ticket ownership at the door by using ledger / crypto technology. Why do I have to use fiat money to enter events like Dappcon (or any other conference on planet earth)? The QR code I'm presenting just contains a simple number, it's open for forgery, duplication, abuse. To redeem my ETHBerlinZwei badge I was supposed to disclose my email address to someone typing it into his Mac.

### the idea 
Lets change that. In a way that it's truly usable. **Build an app that I can use to "buy" a ticket and to "open the door" / "get into the venue"**  Just a "simple" decentralized and publicly useable "lets open the door with a ticket token" Đapp and its necessary counterparts.

### what we've built:
- Solidity smart contracts that event hosts use to manage events (each event gets its own smart contract)
- contract based purchase options that accept cryptos (eth) as payment 
- attendees are registered as ticket owners in a simple mapping (address) => (ticket count)
- at the door attendees present a QR code that contains the public address of the attendee & the signature of a pre-shared secret
- bouncers scan the qr code and verify that a) the presented public address is associated with a ticket for the event, b) the signature has been created by the private key belonging to that address

### vision
- we're trying to add OpenZeppelin's GSN for the presenting app so users don't have to pay gas 
- instead of maintaining event data on the ledger we'd like to bind the app to real world event URLs (e.g. eventbrite / meetup events); users can transfer their ownership proof of a ticket into the decentralized space to just use the "door opening" capabilities.

### outlook
- everybody can be a bouncer! Each attendee who enters the venue gains the role of a ticket verifier, being able to verify other incoming attendees. Bouncers operating devices are only needed in the beginning of an event
- we'd love to hide the details of crypto completely. "Average" users shouldn't bother with the details of exchanges, wallets or signatures. We tried to develop our frontend towards that direction already.  
- the proof of identity can be achieved by using zero knowledge proofs or self sovereign identities.
- tickets can be created as ERC721 tokens and voided by transferring them to a bouncer's account. This way they're even tradeable.