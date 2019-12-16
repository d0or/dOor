
pragma solidity ^0.5.0;

//import "@openzeppelin/contracts/ownership/Ownable.sol";
//import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "./DoorEventSimple.sol";
import "./DoorMeetupSimple.sol";


/**
 * @title Meet.inc - "ĐOor-Factory"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor-Factory allows event managers to deploy their own Door Event and/or Door Meetup
 */
contract DoorFactory is Ownable, Pausable{

    address[] private doorEventAddresses;
    address[] private doorMeetupAddresses;
    mapping (address => bool) private doorCreatedConfirmation;

    enum DoorType {
        UNDEFINED,
        EVENT,
        MEETUP
    }

    /**
      * @notice Fee is just for Door Events. Value represents 0.x%
      */
    uint eventFee = 5;

    event LogNewDoorCreated(
        DoorType indexed doorType,
        address indexed doorOwner,
        address indexed doorAddress,
        string doorName,
        uint totalSeats
    );
    event LogEventFeeChanged(address indexed owner, uint newFee);
    event LogOwnerHasWithdrawn(address indexed owner, uint amount);

    /**
      * @notice Creation of a Door Meetup
      *  The ĐOor-Meetup contract is an abstraction of a meetup event
      * @return Address of deployed Door contract
      */
    function createNewDoorMeetup(string memory _meetupName, uint _totalSeats) public whenNotPaused returns(address) {

        DoorMeetupSimple door = new DoorMeetupSimple(_meetupName, _totalSeats);
        door.transferOwnership(msg.sender);

        doorMeetupAddresses.push(address(door));
        doorCreatedConfirmation[address(door)] = true;

        emit LogNewDoorCreated(
            DoorType.MEETUP,
            msg.sender,
            address(door),
            _meetupName,
            _totalSeats
        );

        return address(door);
    }

    /**
      * @notice Creation of a Door Event
      *  The ĐOor-Event contract is an abstraction of an event
      * @return Address of deployed Door contract
      */
    function createNewDoorEvent(string memory _eventName, uint _totalSeats, uint _ticketPrice) public whenNotPaused returns(address) {

        DoorEventSimple door = new DoorEventSimple(_eventName, _totalSeats, _ticketPrice, eventFee, address(this));
        door.transferOwnership(msg.sender);

        doorEventAddresses.push(address(door));
        doorCreatedConfirmation[address(door)] = true;

        emit LogNewDoorCreated(
            DoorType.EVENT,
            msg.sender,
            address(door),
            _eventName,
            _totalSeats
        );

        return address(door);
    }

    function collectEventFee(uint index) public returns(bool) {
        address doorEventAddress = getDoorByIndex(DoorType.EVENT, index);
        require(
            confirmDoorCreated(doorEventAddress),
            "Door is not created by this factory."
        );

        DoorEventSimple door = DoorEventSimple(doorEventAddress);
        return door.transferFees();
    }

    function changeFee(uint newFee) external onlyOwner returns(bool) {
        eventFee = newFee;

        emit LogEventFeeChanged(msg.sender, newFee);
        return true;
    }

    /**
      * @dev Preparation for EIP 1884 (https://eips.ethereum.org/EIPS/eip-1884) in Istanbul hard fork
      *  Avoidance of Solidity's transfer() or send() methods
      */
    function withdrawalByOwner() external onlyOwner whenNotPaused returns(bool) {
        uint amount = address(this).balance;
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success, "Transfer failed.");

        emit LogOwnerHasWithdrawn(msg.sender, amount);
        return true;
    }

    function getDoorCount(DoorType _doorType) public view returns(uint) {
        if(_doorType == DoorType.EVENT){
            return doorEventAddresses.length;
        }
        else if(_doorType == DoorType.MEETUP){
            return doorMeetupAddresses.length;
        }
        else { revert("Door type does not exist."); }
    }

    function getDoorByIndex(DoorType _doorType, uint index) public view returns(address) {
        if(_doorType == DoorType.EVENT){
            return doorEventAddresses[index];
        }
        else if(_doorType == DoorType.MEETUP){
            return doorMeetupAddresses[index];
        }
        else { revert("Door type does not exist."); }
    }

    /**
      * @dev Use 'pragma experimental ABIEncoderV2;' instead of 'pragma solidity ^0.5.x;'
      * @notice Here be dragons (experimental!)
      */
    function getAllDoors() public view returns(address[] memory doorEvents, address[] memory doorMeetups) {
        return (doorEventAddresses, doorMeetupAddresses);
    }

    function confirmDoorCreated(address _doorAddress) public view returns(bool) {
        return doorCreatedConfirmation[_doorAddress];
    }
}