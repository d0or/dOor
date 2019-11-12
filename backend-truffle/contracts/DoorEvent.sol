pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

contract Door is Ownable, Pausable {
    using SafeMath for uint;
    
    string public eventName;
    uint public ticketPrice;
    bool public allowsWithdraws;

    enum TicketStatus {
        NONE,       
        REGISTERED,
        ATTENDED
    }
    
    struct attendeeStruct{
        TicketStatus ticketStatus;
        bool hasWithdrawn;
    }
    
    mapping(address => attendeeStruct) private tickets;
    
    event TicketSold(address indexed rsvp);

    constructor(string memory _eventName, uint256 _ticketPrice, bool _allowsWithdraws) public {
        eventName = _eventName;
        ticketPrice = _ticketPrice;
        allowsWithdraws = _allowsWithdraws;
    }
    
    function buyTicket() public whenNotPaused payable returns (bool) {
        require(
            tickets[msg.sender].ticketStatus == TicketStatus.NONE,
            'User has already a ticket'
        );
        require(
            msg.value == ticketPrice,
            "msg.value does not meet the ticket price."
        );

        tickets[msg.sender].ticketStatus = TicketStatus.REGISTERED;
        
        emit TicketSold(msg.sender);
        return true;
    }
    
    function getTicketStatus(address attendeeAddress) public view returns (TicketStatus) {
        return tickets[attendeeAddress].ticketStatus;
    }

    function getHasWithdrawn(address attendeeAddress) public view returns (bool){
        return tickets[attendeeAddress].hasWithdrawn;
    }
}
