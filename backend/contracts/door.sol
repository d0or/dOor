pragma solidity ^0.5.0;

import "./ownership.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";

contract doorManager is Ownable {
    //Variables
    Door myEvent;
    address[] private eventAddresses;
    mapping (address => bool) public eventCreated;

    event LogNewEventCreated(address indexed eventOwner, address indexed eventAddress, bytes32 indexed eventName, uint ticketPrice, bool allowDisposeLeftovers);

    function createNewEvent(bytes32 eventName, uint ticketPrice, bool allowDisposeLeftovers) onlyOwner public returns(bool success,  address newEventAddress){
        myEvent = new Door();
        myEvent.initialize(ticketPrice);

        //Change owner of the child contract
        myEvent.transferOwnership(msg.sender);

        //Append address of the new created event to the event array
        eventAddresses.push(address(myEvent));

        //Hold verification that a new door contract was created by this factory
        eventCreated[address(myEvent)] = true;

        emit LogNewEventCreated(msg.sender, address(myEvent), eventName, ticketPrice, allowDisposeLeftovers);
        return(true, address(myEvent));
    }

    //Retrieve the addresses of event contracts created by this factory
    function getEventAtIndex(uint index) public view returns(address eventAddress){
        return(eventAddresses[index]);
    }

    //Get verification that a certain event contract was created by this factory
    function getEventVerification(address eventAddress) public view returns(bool assertion){
        return(eventCreated[splitterAddress]);
    }

    //Get amount of event contracts created by this factory
    function getEventCount() public view returns(uint amountOfEventsCreated){
        return(eventAddresses.length);
    }
}

//pragma solidity >=0.4.22 <0.6.0;

contract Door is Ownable, Initializable {

    bool started;
    bool ended;

    enum TicketValues { None, RSVPD, Attended }
    uint ticketPrice;
    mapping(address => TicketValues) public ticketHolders;


    modifier hasNoTicket() {
        require(ticketHolders[msg.sender] == TicketValues.None, 'you have no ticket');
        _;
    }

    function initialize(uint256 _price) public initializer payable  {
        //owner = msg.sender;
         ticketPrice = _price;
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