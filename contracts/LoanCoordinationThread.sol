// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunicationsTool {
    // Enum for message types in the lending workflow
    enum MessageType {
        REQUEST,
        RISK_RESULT,
        PROOF,
        APPROVAL,
        REJECTION,
        RISK_REQUESTED,
        RISK_EVALUATED
    }

    // Structure to store thread actions
    struct ThreadAction {
        address sender;
        bytes32 threadId;
        MessageType messageType; // enum for the type of message: SEND_MESSAGE, RECEIVE_MESSAGE
        string ciphertextURI;  // IPFS/Arweave/HTTPS location
        uint256 sequenceNumber; // strict ordering per thread
        uint256 timestamp;
    }

    // Mapping to store thread actions for each thread
    mapping(bytes32 => ThreadAction[]) public threadActions;

    // Mapping to track sequence numbers for strict ordering per thread
    address public admin; 
    mapping(bytes32 => uint256) public sequenceNumbers; // sequence number for each thread

    mapping(address => string) public roles; // Maps address to role (e.g., "admin", "user")

    // Constructor to initialize user roles (admin function)
    constructor() {
        admin = msg.sender;
        roles[msg.sender] = "admin";
    }

    // ============================ Access Control Modifiers ============================

    // Modifier to check user role
    modifier onlyAdmin() {
        require(keccak256(abi.encodePacked(roles[msg.sender])) == keccak256(abi.encodePacked("admin")), "Only admin can call this function");
        _;
    }

    // Come back to this for more flexibility in access control
    // Modifier to check to allow admin OR a specific user role
    modifier onlyAdminOrUser(string memory role) {
        require(
            keccak256(abi.encodePacked(roles[msg.sender])) == keccak256(abi.encodePacked("admin")) ||
            keccak256(abi.encodePacked(roles[msg.sender])) == keccak256(abi.encodePacked(role)),
            "Only admin or user with role can call this function"
        );
        _;
    }

    // ============================ Events (immutable audit trail) ============================

    event ThreadCreated(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);
    event RiskEvaluationRequested(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);
    event RiskEvaluationReceived(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);
    event ProofSent(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);
    event ApprovalReceived(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);
    event RejectionReceived(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);
    event RiskEvaluationResultReceived(bytes32 indexed threadId, address indexed sender, uint256 sequenceNumber, uint256 timestamp);

    // ============================ Functions ============================

    // Function to create a new thread
    function createThread(bytes32 threadId) public {
        uint256 currentSequenceNumber = 0;
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.REQUEST,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber, // initial sequence number for the thread
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId] = 1; // increment sequence number for the thread
        emit ThreadCreated(threadId, msg.sender, sequenceNumbers[threadId], block.timestamp);
    }

    // Function to send a message to a thread
    function requestRiskEvaluation(bytes32 threadId) public {
        uint256 currentSequenceNumber = sequenceNumbers[threadId];
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.RISK_REQUESTED,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber,
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
        emit RiskEvaluationRequested(threadId, msg.sender, currentSequenceNumber, block.timestamp);
    }

    // Function to receive a message from a thread
    function receiveRiskEvaluation(bytes32 threadId) public {
        uint256 currentSequenceNumber = sequenceNumbers[threadId];
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.RISK_EVALUATED,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber,
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
        emit RiskEvaluationReceived(threadId, msg.sender, sequenceNumbers[threadId], block.timestamp);
    }

    // Function to send a proof to a thread for risk evaluation
    function sendProof(bytes32 threadId) public {
        uint256 currentSequenceNumber = sequenceNumbers[threadId];
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.PROOF,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber,
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
        emit ProofSent(threadId, msg.sender, currentSequenceNumber, block.timestamp);
    }
    
    // Function for the iExec worker to call with the result of the risk evaluation
    function receiveRiskEvaluationResult(bytes32 threadId, bool /* result */) public {
        uint256 currentSequenceNumber = sequenceNumbers[threadId];
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.RISK_RESULT,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber,
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
        emit RiskEvaluationResultReceived(threadId, msg.sender, currentSequenceNumber, block.timestamp);
    }

    // Function to receive approval for the loan
    function approveLoan(bytes32 threadId) public {
        uint256 currentSequenceNumber = sequenceNumbers[threadId];
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.APPROVAL,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber,
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
        emit ApprovalReceived(threadId, msg.sender, currentSequenceNumber, block.timestamp);
    }

    // Function to reject the loan
    function rejectLoan(bytes32 threadId) public {
        uint256 currentSequenceNumber = sequenceNumbers[threadId];
        threadActions[threadId].push(ThreadAction({
            sender: msg.sender,
            threadId: threadId,
            messageType: MessageType.REJECTION,
            ciphertextURI: "",
            sequenceNumber: currentSequenceNumber,
            timestamp: block.timestamp
        }));
        sequenceNumbers[threadId]++;
        emit RejectionReceived(threadId, msg.sender, currentSequenceNumber, block.timestamp);
    }

    // Function to get the thread actions for a thread
    function getThreadActions(bytes32 threadId) public view returns (ThreadAction[] memory) {
        return threadActions[threadId];
    }   
}