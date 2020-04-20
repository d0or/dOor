
pragma solidity ^0.5.0;

//import "@openzeppelin/contracts/ownership/Ownable.sol";
//import "@openzeppelin/contracts/lifecycle/Pausable.sol";


/**
 * @title Meet.inc - "ĐOor"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor contract contains basic ĐOor functionalities
 */
contract Door is Ownable, Pausable {

    string public eventName;
    uint public totalSeats;
    uint public takenSeats;
    uint public attendeesCount;

    enum DoorStatus {
        PLANNED,
        OPEN,
        CLOSED
    }
    DoorStatus internal doorStatus;

    enum TicketStatus {
        NONE,
        REGISTERED,
        ATTENDED
    }

    struct attendeeStruct {
        TicketStatus ticketStatus;
    }
    mapping(address => attendeeStruct) internal attendees;


    modifier whenDoorIsClosed() {
        require(
            doorStatus == DoorStatus.CLOSED,
            "Door is not closed yet."
        );
        _;
    }


    event LogDoorTicketIssued(address indexed attendee, uint takenSeats);
    event LogDoorTicketRevoked(address indexed attendee, uint takenSeats);
    event LogDoorStatusChanged(address indexed owner, DoorStatus doorStatus);
    event LogAttendeeHasAttended(address indexed owner, address attendee, uint attendeesCount);
    event LogOwnerHasWithdrawn(address indexed owner, uint amount);


    constructor(string memory _eventName, uint _totalSeats) internal {
        eventName   = _eventName;
        totalSeats  = _totalSeats;
    }


    /**
      * @dev Interal functions that are to be called from other contract functions
      */
    function issueTicket(address attendeeAddress) internal whenNotPaused returns(bool) {
        require(doorStatus < DoorStatus.CLOSED, "Door is closed.");
        require(
            attendees[attendeeAddress].ticketStatus == TicketStatus.NONE,
            "User has already a ticket."
        );
        require(totalSeats > takenSeats, "All seats are taken.");

        attendees[attendeeAddress].ticketStatus = TicketStatus.REGISTERED;
        takenSeats++;

        emit LogDoorTicketIssued(attendeeAddress, takenSeats);
        return true;
    }

    function revokeTicket(address attendeeAddress) internal whenNotPaused returns(bool) {
        require(doorStatus < DoorStatus.CLOSED, "Door is closed.");
        require(
            attendees[attendeeAddress].ticketStatus == TicketStatus.REGISTERED,
            "User has no ticket or has already attended."
        );

        attendees[attendeeAddress].ticketStatus = TicketStatus.NONE;
        takenSeats--;

        emit LogDoorTicketRevoked(attendeeAddress, takenSeats);
        return true;
    }

    function openDoor() public onlyOwner whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.PLANNED, "Door has already been openend.");
        doorStatus = DoorStatus.OPEN;

        emit LogDoorStatusChanged(msg.sender, doorStatus);
        return true;
    }

    function closeDoor() public onlyOwner whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.OPEN, "Door is not open.");
        doorStatus = DoorStatus.CLOSED;

        emit LogDoorStatusChanged(msg.sender, doorStatus);
        return true;
    }

    function setUserHasAttended(address attendeeAddress) public onlyOwner whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.OPEN, "Door is not open.");
        require(
            attendees[attendeeAddress].ticketStatus == TicketStatus.REGISTERED,
            "Attendee is not registered."
        );

        attendees[attendeeAddress].ticketStatus = TicketStatus.ATTENDED;
        attendeesCount++;

        emit LogAttendeeHasAttended(msg.sender, attendeeAddress, attendeesCount);
        return true;
    }

    function userHasTicket() public view returns(bool) {
        return attendees[msg.sender].ticketStatus == TicketStatus.REGISTERED;
    }

    function getDoorBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getTicketStatus(address attendeeAddress) public view returns(TicketStatus) {
        return attendees[attendeeAddress].ticketStatus;
    }
}