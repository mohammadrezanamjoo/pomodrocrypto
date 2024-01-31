// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    struct Candidate {
        uint id;
        string name;
        uint votes;
    }


    mapping(uint => Candidate) public candidates;

    // Mapping to store the address of voters and their selected candidate ID
    mapping(address => uint) public voters;

    // Array to store candidate IDs
    uint[] public candidateIds;

    // Event triggered when a new vote is cast
    event Voted(address indexed voter, uint candidateId);

    // Event triggered when a new candidate is added
    event CandidateAdded(uint candidateId, string name);

    // Modifier to ensure that only the contract owner can perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    address public owner;

    // Constructor to set the contract owner
    constructor() {
        owner = msg.sender;
    }

    // Function to add a new candidate
    function addCandidate(string memory name) public onlyOwner {
        uint candidateId = candidateIds.length + 1;
        candidates[candidateId] = Candidate(candidateId, name, 0);
        candidateIds.push(candidateId);

        emit CandidateAdded(candidateId, name);
    }

    // Function to cast a vote
    function vote(uint candidateId) public {
        require(candidateId > 0 && candidateId <= candidateIds.length, "Invalid candidate ID");
        require(voters[msg.sender] == 0, "You have already voted");

        candidates[candidateId].votes++;
        voters[msg.sender] = candidateId;

        emit Voted(msg.sender, candidateId);
    }

    // Function to get the total votes for a candidate
    function getVotes(uint candidateId) public view returns (uint) {
        require(candidateId > 0 && candidateId <= candidateIds.length, "Invalid candidate ID");
        return candidates[candidateId].votes;
    }

    // Function to get the list of candidate IDs
    function getCandidateIds() public view returns (uint[] memory) {
        return candidateIds;
    }
}
