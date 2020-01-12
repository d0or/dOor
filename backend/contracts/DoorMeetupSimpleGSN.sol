
pragma solidity ^0.5.0;

//import "@openzeppelin/contracts/ownership/Ownable.sol";
//import "@openzeppelin/contracts/lifecycle/Pausable.sol";
//import "@openzeppelin/contracts/GSN/GSNRecipient.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/lifecycle/Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/GSN/GSNRecipient.sol";


/**
 * @title Meet.inc - "ĐOor-Meetup"
 *  ĐOor opens doors at events that are anchored on the Ethereum blockchain.
 * @notice The ĐOor-Meetup contract is an abstraction of a meetup event
 *
 * @dev NOT READY FOR PRODUCTION (Test file for making use of GSN)
 */
contract DoorMeetupGSN is Ownable, Pausable, GSNRecipient {

    string public eventName;
    uint public attendeesCount;

    struct attendeeStruct {
        bool attendanceConfirmed;
    }
    mapping(address => attendeeStruct) private attendees;


    constructor(string memory _eventName) public {
        eventName = _eventName;
    }


    function toggleAttendance() public whenNotPaused returns(bool) {
        bool rsvpStatus = attendees[_msgSender()].attendanceConfirmed;
        if (rsvpStatus == false){
            attendees[_msgSender()].attendanceConfirmed = true;
            attendeesCount++;
        }
        else{
            attendees[_msgSender()].attendanceConfirmed = false;
            attendeesCount--;
        }

        return true;
    }


    /**
     * @dev Mandatory contract functions for GSNRecipient functionality
     */
    function acceptRelayedCall(
     address relay,
     address from,
     bytes calldata encodedFunction,
     uint256 transactionFee,
     uint256 gasPrice,
     uint256 gasLimit,
     uint256 nonce,
     bytes calldata approvalData,
     uint256 maxPossibleCharge
     ) external view returns (uint256, bytes memory){
        //we can do something here

        /**
        * @dev At the moment all relay queries are going to be accepted
        */
        return (0, "");
    }

    function preRelayedCall(bytes calldata context) external returns (bytes32){
        return ("");
    }

    function postRelayedCall(
     bytes calldata context,
     bool success,
     uint actualCharge,
     bytes32 preRetVal
     ) external{
        //we can do something here
    }
}