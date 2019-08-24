pragma solidity ^0.5.0;

import "./Ownership.sol";
import "../node_modules/@openzeppelin/upgrades/contracts/Initializable.sol";

contract Door is Ownable, Initializable {

    bool started;
    bool ended;

    enum AttendanceTypes { NONE, REGISTERED, ATTENDED }
    uint ticketPrice;
    mapping(address => AttendanceTypes) public tickets;
    address[] public registerees;
    address payable[] public attendees;
    mapping(address => bool) public withdrawals;

    modifier hasNoTicket() {
        require(tickets[msg.sender] == AttendanceTypes.NONE, 'you have no ticket');
        _;
    }

    function initialize(uint256 _price, string memory eventName, bool allowDisposeLeftovers) public initializer payable  {
         ticketPrice = _price;
         nameOfEvent = eventName;
         canWithdrawFunds = allowDisposeLeftovers;
    }

    function startEvent() public onlyOwner {
        require(!started, 'the event has already started');
        started = true;
    }

    function endEvent() public onlyOwner {
        require(!ended, 'the event has already ended');
        ended = true;
    }

    function getEventPrice() public view returns (uint) {
        return ticketPrice;
    }

    function buyEventTicket() public payable hasNoTicket {
        require(started, 'the event has not been started');
        require(
            msg.value == ticketPrice,
            "Ticket price is too low"
        );

        tickets[msg.sender] = AttendanceTypes.REGISTERED;
        registerees.push(msg.sender);
    }

    function hasEventTicket() public view returns (bool) {
        return tickets[msg.sender] == AttendanceTypes.REGISTERED;
    }

    function setUserATTENDED(address payable userAddress) public onlyOwner {
        // assuming that the event creator is honest and will verify correctly
        require(started, 'the event has not started');
        tickets[userAddress] = AttendanceTypes.ATTENDED;
        attendees.push(userAddress);
    }

    function getBalance() public view returns (uint256){
        return address(this).balance;
    }

    function withdraw() public {
        require(canWithdrawFunds, 'cannot withdraw funds');
        require(!withdrawals[msg.sender], 'funds already withrdrawn');
        require(ended == true, 'Event has not ended');
        require(tickets[msg.sender]==AttendanceTypes.ATTENDED, 'You have not attended the event');

        uint256 amount = address(this).balance / (registerees.length - attendees.length);

        msg.sender.transfer(amount);
        withdrawals[msg.sender] = true;
    }

    string nameOfEvent;
    bool canWithdrawFunds;
}