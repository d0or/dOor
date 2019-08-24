pragma solidity ^0.5.0;

import "./ownership.sol";

contract doorManager is Ownable{
    Door myEvent;
    address[] private eventAddresses;
    mapping (address => bool) public eventCreated;

    event LogNewEventCreated(address indexed eventOwner, address indexed eventAddress);

    function createNewEvent(uint ticketPrice) public returns(bool success,  address newEventAddress){
        myEvent = new Door(ticketPrice);

        //Append address of the new created event to the event array
        eventAddresses.push(address(myEvent));

        //Confirm creation of event
        eventCreated[address(myEvent)] = true;

        emit LogNewEventCreated(msg.sender, address(myEvent));
        return(true, address(myEvent));
    }

    //Get amount of event contracts created by this factory
    function getEventCount() public view returns(uint amountOfEventsCreated){
        return(eventAddresses.length);
    }
}

contract Door is Ownable{

    bool started;
    bool ended;

    enum TicketValues { None, RSVPD, Attended }
    uint ticketPrice;
    mapping(address => TicketValues) public ticketHolders;


    modifier hasNoTicket() {
        require(ticketHolders[msg.sender] == TicketValues.None, 'you have no ticket');
        _;
    }

    constructor(uint price) public payable {
        ticketPrice = price;
    }

    function startEvent() public onlyOwner {
        assert(!started);
        started = true;
    }

    function endEvent() public onlyOwner {
        assert(!ended);
        ended = true;
    }

    function getEventPrice() public view returns (uint) {
        return ticketPrice;
    }

    function buyEventTicket() public payable hasNoTicket {
        require(
            msg.value == ticketPrice,
            "Ticket price is too low"
        );

        ticketHolders[msg.sender] = TicketValues.RSVPD;
    }

    function hasEventTicket() public view returns (TicketValues) {
        return ticketHolders[msg.sender];
    }

    function setUserAttended(address userAddress) public onlyOwner {
        // assuming that the event creator is honest and will verify correctly
        assert(started);
        ticketHolders[userAddress] = TicketValues.Attended;
    }

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }

}