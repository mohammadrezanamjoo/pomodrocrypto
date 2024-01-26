pragma solidity ^0.8.0;


contract PomodoroToken {
    address public owner;
    mapping(address => uint256) public userTokens;
    mapping(address => uint256) public lastSessionEndTime;

    uint256 public constant pomodoroDuration = 25 minutes;
    uint256 public constant tokenRewardPerSession = 1;

    event StudySessionCompleted(address indexed user, uint256 tokensEarned);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not The Owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function startStudySession() external {
        require(lastSessionEndTime[msg.sender] + pomodoroDuration <= block.timestamp, "Session In Progress");

        uint256 tokensEarned = (block.timestamp - lastSessionEndTime[msg.sender]) / pomodoroDuration * tokenRewardPerSession;
        userTokens[msg.sender]+=  tokensEarned;
        lastSessionEndTime[msg.sender] = block.timestamp;

        emit StudySessionCompleted(msg.sender, tokensEarned);
    }

    function getUserTokens() external view returns (uint256) {
        return userTokens[msg.sender];
    }

    function withdrawTokens() external {
        uint256 tokensToWithdraw = userTokens[msg.sender];
        require(tokensToWithdraw > 0, "No tokens to Withdraw");

        userTokens[msg.sender] = 0;


        emit StudySessionCompleted(msg.sender, tokensToWithdraw);
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
}
