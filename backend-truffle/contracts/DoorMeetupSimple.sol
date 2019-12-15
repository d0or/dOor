
pragma solidity ^0.5.0;

import "./Door.sol";


/**
 * @title Meet.inc - "ĐOor-Meetup (simple)"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor-Meetup contract is an abstraction of a meetup event
 */
contract DoorMeetupSimple is Door {

    constructor(string memory _eventName, uint _totalSeats) Door(_eventName, _totalSeats) public {
    }

    function toggleAttendance() public whenNotPaused returns(bool) {
        if (attendees[msg.sender].ticketStatus == TicketStatus.NONE){
            issueTicket(msg.sender);
        }
        else{
            revokeTicket(msg.sender);
        }

        return true;
    }
}