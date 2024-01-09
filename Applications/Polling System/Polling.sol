
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {
    address public owner;
    
    struct Poll {
        string question;
        string[] options;
        mapping(string => uint256) votes;
        bool isOpen;
    }
    
    Poll[] public polls;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    modifier pollExists(uint256 pollId) {
        require(pollId < polls.length, "Poll does not exist");
        _;
    }
    
    modifier pollOpen(uint256 pollId) {
        require(polls[pollId].isOpen, "Poll is closed");
        _;
    }

    event PollCreated(uint256 indexed pollId, string question, string[] options);
    event Voted(uint256 indexed pollId, address indexed voter, string option);

    constructor() {
        owner = msg.sender;
    }

    function createPoll(string memory _question, string[] memory _options) external onlyOwner {
        polls.push(Poll({
            question: _question,
            options: _options,
            isOpen: true
        }));

        emit PollCreated(polls.length - 1, _question, _options);
    }

    function vote(uint256 pollId, string memory option) external pollExists(pollId) pollOpen(pollId) {
        require(bytes(option).length > 0, "Option cannot be empty");
        require(isOptionValid(pollId, option), "Invalid option");

        polls[pollId].votes[option]++;
        
        emit Voted(pollId, msg.sender, option);
    }

    function closePoll(uint256 pollId) external onlyOwner pollExists(pollId) pollOpen(pollId) {
        polls[pollId].isOpen = false;
    }

    function getPoll(uint256 pollId) external view pollExists(pollId) returns (string memory question, string[] memory options, uint256[] memory voteCounts) {
        Poll storage poll = polls[pollId];
        uint256 numOptions = poll.options.length;

        question = poll.question;
        options = new string[](numOptions);
        voteCounts = new uint256[](numOptions);

        for (uint256 i = 0; i < numOptions; i++) {
            options[i] = poll.options[i];
            voteCounts[i] = poll.votes[poll.options[i]];
        }
    }

    function isOptionValid(uint256 pollId, string memory option) internal view returns (bool) {
        for (uint256 i = 0; i < polls[pollId].options.length; i++) {
            if (keccak256(abi.encodePacked(polls[pollId].options[i])) == keccak256(abi.encodePacked(option))) {
                return true;
            }
        }
        return false;
    }
}
