
pragma solidity ^0.5.0;

import "./Door.sol";
//import "@openzeppelin/contracts/math/SafeMath.sol";


/**
 * @title Meet.inc - "ĐOor-Event (simple)"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor-Event contract is an abstraction of a standard event
 */
contract DoorEventSimple is Door {
    using SafeMath for uint;

    uint private ticketPrice;
    uint private doorBalance;

    uint private eventFee;
    uint private collectedFees;
    address private factory;
    bool private feesTransferred;

    mapping(address => bool) private hasWithdrawn;


    event LogDoorEventTicketSold(address indexed sender, address indexed attendee, uint ticketPrice, uint doorBalance, uint collectedFees, uint contractBalance);
    event LogTicketPriceChanged(address indexed owner, uint newTicketPrice);
    event LogFeesTransferred(address indexed sender, address indexed factory, uint amount, uint contractBalance);


    constructor(string memory _eventName, uint _totalSeats, uint _ticketPrice, uint _eventFee, address _factory) Door(_eventName, _totalSeats) public {
        ticketPrice = _ticketPrice;
        eventFee = _eventFee;
        factory = _factory;
    }


    function buyTicket(address attendeeAddress) public whenNotPaused payable returns(bool) {
        require(
            attendeeAddress != address(0x0),
            "Address field has to be filled."
        );
        require(
            msg.value == ticketPrice,
            "msg.value does not meet the ticket price."
        );

        issueTicket(attendeeAddress);

        uint fee = ticketPrice.mul(eventFee).div(1000);
        collectedFees += fee;
        doorBalance += ticketPrice.sub(fee);

        emit LogDoorEventTicketSold(msg.sender, attendeeAddress, ticketPrice, doorBalance, collectedFees, getDoorBalance());
        return true;
    }

    function changeTicketPrice(uint newTicketPrice) public onlyOwner whenNotPaused returns(bool) {
        ticketPrice = newTicketPrice;

        emit LogTicketPriceChanged(msg.sender, newTicketPrice);
        return true;
    }

    /**
      * @dev EIP 1884 (https://eips.ethereum.org/EIPS/eip-1884) within Istanbul hard fork
      *  Avoidance of Solidity's transfer() or send() methods
      */
    function transferFees() external whenNotPaused whenDoorIsClosed returns(bool) {
        uint amount = collectedFees;
        collectedFees = 0;

        (bool success, ) = factory.call.value(amount)("");
        require(success, "Transfer failed.");

        feesTransferred = true;

        emit LogFeesTransferred(msg.sender, factory, amount, getDoorBalance());
        return true;
    }

    function withdrawalByOwner() external onlyOwner whenNotPaused whenDoorIsClosed returns(bool) {
        require(feesTransferred, "Fees need to be transferred first.");

        uint amount = doorBalance;
        doorBalance = 0;
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success, "Transfer failed.");

        emit LogOwnerHasWithdrawn(msg.sender, amount);
        return true;
    }

    function getTicketPrice() public view returns (uint) {
        return ticketPrice;
    }
}