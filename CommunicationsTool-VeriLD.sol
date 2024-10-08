// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunicationsTool {
    // Structure to store messages
    struct Message {
        address sender;
        string content;
        uint256 timestamp;
    }

    // Mapping to store messages for each chat room
    mapping(string => Message[]) private chatRooms;

    // Access control mapping (address => role)
    mapping(address => string) public roles;

    // Event to emit when a message is sent
    event MessageSent(string indexed chatRoomId, address indexed sender, string content, uint256 timestamp);

    // Modifier to check user role
    modifier onlyRole(string memory requiredRole) {
        require(
            keccak256(abi.encodePacked(roles[msg.sender])) == keccak256(abi.encodePacked(requiredRole)),
            "Access Denied: You do not have the required role"
        );
        _;
    }

    // Function to send a message to a chat room
    function sendMessage(string memory chatRoomId, string memory content) public {
        Message memory newMessage = Message({
            sender: msg.sender,
            content: content,
            timestamp: block.timestamp
        });

        chatRooms[chatRoomId].push(newMessage);

        emit MessageSent(chatRoomId, msg.sender, content, block.timestamp);
    }

    // Function to retrieve messages from a chat room
    function getMessages(string memory chatRoomId) public view returns (Message[] memory) {
        return chatRooms[chatRoomId];
    }

    // Function to set user roles (admin function)
    function setUserRole(address user, string memory role) public onlyRole("admin") {
        roles[user] = role;
    }

    // Function to collect and share findings (basic implementation)
    function shareFindings(string memory data) public {
        // In a more advanced implementation, this function would interact with other storage
        // and smart contract systems to collect, organize, and share findings.
        emit MessageSent("findings", msg.sender, data, block.timestamp);
    }
}
