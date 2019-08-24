pragma solidity >=0.4.22 <0.6.0;

contract Door {

    address public owner;
    bool started;
    bool ended;

    modifier onlyOwner() {
        require(msg.sender == owner, 'you are not the contract owner');
        _;
    }

    enum TicketValues { None, RSVPD, Attended }
    uint ticketPrice;
    mapping(address => TicketValues) public ticketHolders;


    modifier hasNoTicket() {
        require(ticketHolders[msg.sender] == TicketValues.None, 'you have no ticket');
        _;
    }

    constructor(uint price) public payable {
        ticketPrice = price;
        owner = msg.sender;
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