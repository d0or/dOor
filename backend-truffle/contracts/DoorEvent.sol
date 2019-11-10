//Meet.inc >>> ĐOor-Event <<<
//Đoor-Event - Everything's decentralized but not your Đoor
//ĐOor opens doors at events that are anchored on the Ethereum blockchain.
//
//Last update: 10.11.2019

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";


contract DoorEvent is Ownable, Pausable {
    //TODO
    //1. Review (old) hackathon code created in sleepytime limbo
    //2. Get GSN working
    //3. Upgradable contracts which includes created user data
    //4. Create event “tickets” that are transferable (can lead to a market)

    constructor(uint256 _doorEventTicketPrice, string memory _doorEventName, bool allowDisposeLeftovers) public {
        //used as interface at the moment
    }

}