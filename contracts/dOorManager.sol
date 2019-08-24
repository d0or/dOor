//EthBerlinZwei Hackathon
//
//>>> DOor Manager <<<
//Everything's decentralized but not your Đoor: Event ticket tokens
//The D0or Manager is a factory that allows event managers to deploy their own event

pragma solidity ^0.5.0;

import "./ownership.sol";

contract dOorManager is Ownable{
    //Variables
    D0or myEvent;
    address[] private eventAddresses;
    mapping (address => bool) public eventCreated;

    //Events
    event LogNewEventCreated(address indexed eventOwner, address indexed eventAddress);

    //Create new Event
    function createNewEvent() public returns(bool success,  address newEventAddress){
        myEvent = new DOor;

        //Append address of the new created event to the event array
        eventAddresses.push(address(myEvent));

        //Confirm creation of event
        eventCreated[address(myEvent)] = true;

        emit LogNewEventCreated(msg.sender, address(myEvent));
        return(true, address(myEvent));
    }

    //Get amount of event contracts created by this factory
    function getEventCount() public view returns(uint amountOfEventsCreated){
        return(splitterAddresses.length);
    }
}