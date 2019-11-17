
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/lifecycle/Pausable.sol";
import "./DoorEvent.sol";
import "./DoorMeetup.sol";


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

    event LogNewDoorCreated(
        DoorType indexed doorType,
        address indexed doorOwner,
        address indexed doorAddress,
        string doorName,
        uint ticketPrice,
        bool allowWithdrawal
    );

    /**
      * @notice Creation of a Door Event
      *  The ĐOor-Event contract is an abstraction of a standard event
      * @return Address of deployed Door contract
      */
    function createNewDoorEvent(string memory _name, uint256 _ticketPrice, bool _allowWithdrawal) public whenNotPaused returns(address) {

        DoorEvent door = new DoorEvent(_name, _ticketPrice, _allowWithdrawal);
        door.transferOwnership(msg.sender);

        doorEventAddresses.push(address(door));
        doorCreatedConfirmation[address(door)] = true;

        emit LogNewDoorCreated(
            DoorType.EVENT,
            msg.sender,
            address(door),
            _name,
            _ticketPrice,
            _allowWithdrawal
        );

        return address(door);
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