
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


/**
 * @title Meet.inc - "ĐOor-Meetup"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor-Meetup contract is an abstraction of a meetup event
 */
contract DoorMeetup is Ownable, Pausable {
    using SafeMath for uint;

    string public eventName;
    uint private ticketPrice;
    bool private allowWithdrawal;

    uint private withdrawableShares;
    uint public attendeesCount;

    enum DoorStatus {
        PLANNED,
        OPEN,
        CLOSED
    }
    DoorStatus doorStatus;

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


    event LogDoorMeetupTicketSold(address indexed attendee, uint newDoorBalance);
    event LogDoorMeetupOpened(address indexed owner);
    event LogDoorMeetupClosed(address indexed owner, uint withdrawableDoorShares);
    event LogAttendeeHasAttended(address indexed owner, address attendee, uint attendeesCount);
    event LogAttendeeHasWithdrawn(address indexed attendee, uint withdrawableShares, uint newDoorBalance);
    event LogOwnerHasWithdrawn(address indexed owner, uint newDoorBalance);


    constructor(string memory _eventName, uint256 _ticketPrice, bool _allowWithdrawal) public {
        eventName = _eventName;
        ticketPrice = _ticketPrice;
        allowWithdrawal = _allowWithdrawal;
    }


    /**
      * @notice Function need to be queried by attendees themselves
      */
    function buyTicket() public whenNotPaused payable returns(bool) {
        require(doorStatus <= DoorStatus.CLOSED, 'Tickets can no longer be purchased.');
        require(
            attendees[msg.sender].ticketStatus == TicketStatus.NONE,
            'User has already a ticket.'
        );
        require(
            msg.value == ticketPrice,
            "msg.value does not meet the ticket price."
        );

        attendees[msg.sender].ticketStatus = TicketStatus.REGISTERED;

        emit LogDoorMeetupTicketSold(msg.sender, address(this).balance);
        return true;
    }

    function setUserHasAttended(address attendeeAddress) public onlyOwner whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.OPEN, 'Door is not open.');
        require(attendees[attendeeAddress].ticketStatus == TicketStatus.REGISTERED, 'Attendee is not registered.');

        attendees[attendeeAddress].ticketStatus = TicketStatus.ATTENDED;
        attendeesCount++;

        emit LogAttendeeHasAttended(msg.sender, attendeeAddress, attendeesCount);
        return true;
    }

    function openDoor() public onlyOwner returns(bool) {
        require(doorStatus == DoorStatus.PLANNED, 'Door has already been openend.');
        doorStatus = DoorStatus.OPEN;

        emit LogDoorMeetupOpened(msg.sender);
        return true;
    }

    function closeDoor() public onlyOwner returns(bool) {
        require(doorStatus == DoorStatus.OPEN, 'Door is not open.');
        doorStatus = DoorStatus.CLOSED;

        withdrawableShares = address(this).balance.div(attendeesCount);

        emit LogDoorMeetupClosed(msg.sender, withdrawableShares);
        return true;
    }

    /**
      * @dev Preparation for EIP 1884 (https://eips.ethereum.org/EIPS/eip-1884) in Istanbul hard fork
      *  Avoidance of Solidity's transfer() or send() methods
      */
    function withdrawalByAttendee() external whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.CLOSED, 'Door is not closed yet.');
        require(allowWithdrawal, 'You are not allowed to withdraw funds.');
        require(!getHasWithdrawn(msg.sender), 'Attendee funds are already withdrawn.');

        attendees[msg.sender].hasWithdrawn = true;
        (bool success, ) = msg.sender.call.value(withdrawableShares)("");
        require(success, "Transfer failed.");

        emit LogAttendeeHasWithdrawn(msg.sender, withdrawableShares, getEventBalance());
        return true;
    }

    function withdrawalByOwner() external onlyOwner whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.CLOSED, 'Door is not closed yet.');

        (bool success, ) = msg.sender.call.value(getEventBalance())("");
        require(success, "Transfer failed.");

        emit LogOwnerHasWithdrawn(msg.sender, getEventBalance());
        return true;
    }


    function userHasEventTicket() public view returns(bool) {
        return attendees[msg.sender].ticketStatus == TicketStatus.REGISTERED;
    }

    function getEventPrice() public view returns (uint) {
        return ticketPrice;
    }

    function getEventBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getTicketStatus(address attendeeAddress) public view returns(TicketStatus) {
        return attendees[attendeeAddress].ticketStatus;
    }

    function getHasWithdrawn(address attendeeAddress) public view returns(bool) {
        return attendees[attendeeAddress].hasWithdrawn;
    }
}