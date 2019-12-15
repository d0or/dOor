
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
    DoorStatus doorStatus;

    enum TicketStatus {
        NONE,
        REGISTERED,
        ATTENDED
    }

    struct attendeeStruct {
        TicketStatus ticketStatus;
    }
    mapping(address => attendeeStruct) internal attendees;


    event LogDoorTicketIssued(address indexed attendee);
    event LogDoorTicketRevoked(address indexed attendee);
    event LogDoorOpened(address indexed owner);
    event LogAttendeeHasAttended(address indexed owner, address attendee, uint attendeesCount);
    event LogDoorClosed(address indexed owner);
    event LogOwnerHasWithdrawn(address indexed owner, uint amount);


    constructor(string memory _eventName, uint _totalSeats) internal {
        eventName   = _eventName;
        totalSeats  = _totalSeats;
    }


    /**
      * @dev Interal functions that are to be called from other contract functions
      */
    function issueTicket(address attendeeAddress) internal whenNotPaused returns(bool) {
        require(doorStatus < DoorStatus.CLOSED, 'Tickets will no longer be issued.');
        require(
            attendees[attendeeAddress].ticketStatus == TicketStatus.NONE,
            'User has already a ticket.'
        );
        require(totalSeats > takenSeats, 'All seats are taken.');

        attendees[attendeeAddress].ticketStatus = TicketStatus.REGISTERED;
        takenSeats++;

        emit LogDoorTicketIssued(attendeeAddress);
        return true;
    }

    function revokeTicket(address attendeeAddress) internal whenNotPaused returns(bool) {
        require(doorStatus < DoorStatus.CLOSED, 'Tickets can no longer be revoked.');
        require(
            attendees[attendeeAddress].ticketStatus == TicketStatus.REGISTERED,
            'User has no ticket or has already attended.'
        );

        attendees[attendeeAddress].ticketStatus = TicketStatus.NONE;
        takenSeats--;

        emit LogDoorTicketRevoked(attendeeAddress);
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

        emit LogDoorOpened(msg.sender);
        return true;
    }

    function closeDoor() public onlyOwner returns(bool) {
        require(doorStatus == DoorStatus.OPEN, 'Door is not open.');
        doorStatus = DoorStatus.CLOSED;

        emit LogDoorClosed(msg.sender);
        return true;
    }

    /**
      * @dev Preparation for EIP 1884 (https://eips.ethereum.org/EIPS/eip-1884) in Istanbul hard fork
      *  Avoidance of Solidity's transfer() or send() methods
      */
    function withdrawalByOwner() external onlyOwner whenNotPaused returns(bool) {
        require(doorStatus == DoorStatus.CLOSED, 'Door is not closed yet.');

        uint amount = getDoorBalance();
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success, "Transfer failed.");

        emit LogOwnerHasWithdrawn(msg.sender, getDoorBalance());
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