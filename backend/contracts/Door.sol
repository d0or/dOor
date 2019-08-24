pragma solidity ^0.5.0;

import "./Ownership.sol";
import "@openzeppelin/upgrades/contracts/Initializable.sol";

contract DoorFactory {
    address[] public doorAddresses;

    event NewDoorCreated(
        address indexed doorOwner,
        address indexed doorAddress,
        string indexed doorName,
        uint ticketPrice,
        bool allowDisposeLeftovers
    );

    function createNewDoor(uint256 _price, string memory eventName, bool allowDisposeLeftovers) public returns(address) {
        Door door = new Door();
        door.initialize(_price, eventName, allowDisposeLeftovers);
        door.transferOwnership(msg.sender);
        doorAddresses.push(address(door));

        emit NewDoorCreated(
            msg.sender,
            address(door),
            eventName,
            _price,
            allowDisposeLeftovers
        );
        return address(door);
    }

    function getDoorCount() public view returns(uint) {
        return doorAddresses.length;
    }

    function getDoorByIndex(uint index) public view returns(address) {
        return address(doorAddresses[index]);
    }

    function getAllDoors() public view returns(address[] memory) {
        return doorAddresses;
    }
}

contract Door is Ownable, Initializable {

    string public nameOfEvent;
    uint public ticketPrice;
    bool private canWithdrawFunds;

    bool private eventHasStarted;
    bool private eventHasEnded;

    uint attendeesCount;
    uint256 shares;

    enum AttendanceTypes { NONE, REGISTERED, ATTENDED }

    struct UserStruct{
        AttendanceTypes ticketStatus;
        bool hasWithdrawn;
    }
    mapping(address => UserStruct) public users;


    function initialize(uint256 _price, string memory eventName, bool allowDisposeLeftovers) public initializer payable  {
         ticketPrice = _price;
         nameOfEvent = eventName;
         canWithdrawFunds = allowDisposeLeftovers;
    }

    function startEvent() public onlyOwner {
        require(!eventHasStarted, 'The event has already been started.');
        eventHasStarted = true;
    }

    function endEvent() public onlyOwner {
        require(!eventHasEnded && eventHasStarted, 'The event has already ended or hasnt started yet.');
        eventHasEnded = true;

        shares = address(this).balance / attendeesCount;
    }

    function getEventPrice() public view returns (uint price) {
        return ticketPrice;
    }

    function buyEventTicket() public payable {
        require(users[msg.sender].ticketStatus == AttendanceTypes.NONE, 'User has already a ticket');
        require(
            msg.value == ticketPrice,
            "msg.value does not meet the ticket price."
        );

        users[msg.sender].ticketStatus = AttendanceTypes.REGISTERED;
    }

    function userHasEventTicket() public view returns (bool) {
        return users[msg.sender].ticketStatus == AttendanceTypes.REGISTERED;
    }

    function setUserHasAttendedByOwner(address payable userAddress) public onlyOwner{
        // assuming that the event creator is honest and will verify correctly
        require(eventHasStarted, 'The event has not been started yet.');
        require(users[userAddress].ticketStatus != AttendanceTypes.ATTENDED, 'User has already attended.');
        users[userAddress].ticketStatus = AttendanceTypes.ATTENDED;
        attendeesCount++;
    }

    function getEventBalance() public view returns (uint256 eventBalance){
        return address(this).balance;
    }

    function withdraw() public {
        require(eventHasEnded == true, 'Event has not ended yet.');
        require(canWithdrawFunds, 'You are not allowed to withdraw funds.');
        require(users[msg.sender].ticketStatus == AttendanceTypes.ATTENDED, 'User didnt attend.');
        require(users[msg.sender].hasWithdrawn, 'Users funds are already withdrawn.');

        users[msg.sender].hasWithdrawn = true;

        msg.sender.transfer(shares);
    }

    function getEventName() public view returns (string memory name) {
        return nameOfEvent;
    }

}