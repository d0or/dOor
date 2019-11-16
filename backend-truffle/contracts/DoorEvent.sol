
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


/**
 * @title Meet.inc - "ĐOor-Event"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor-Event contract is an abstraction of a standard event
 */
contract DoorEvent is Ownable, Pausable {
    using SafeMath for uint;

    string public eventName;
    uint private ticketPrice;
    bool private allowWithdrawal;

    enum TicketStatus {
        NONE,
        REGISTERED,
        ATTENDED
    }

    struct attendeeStruct {
        TicketStatus ticketStatus;
        bool hasWithdrawn;
    }
    mapping(address => attendeeStruct) private attendees;


    event LogDoorEventTicketSold(address indexed attendee);


    constructor(string memory _eventName, uint256 _ticketPrice, bool _allowWithdrawal) public {
        eventName = _eventName;
        ticketPrice = _ticketPrice;
        allowWithdrawal = _allowWithdrawal;
    }


    function buyTicket() public whenNotPaused payable returns(bool) {
        require(
            attendees[msg.sender].ticketStatus == TicketStatus.NONE,
            'User has already a ticket.'
        );
        require(
            msg.value == ticketPrice,
            "msg.value does not meet the ticket price."
        );

        attendees[msg.sender].ticketStatus = TicketStatus.REGISTERED;

        emit LogDoorEventTicketSold(msg.sender);
        return true;
    }

    function getTicketStatus(address attendeeAddress) public view returns(TicketStatus) {
        return attendees[attendeeAddress].ticketStatus;
    }

    function getHasWithdrawn(address attendeeAddress) public view returns(bool) {
        return attendees[attendeeAddress].hasWithdrawn;
    }
}