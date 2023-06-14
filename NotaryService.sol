// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NotaryService {
    struct Document {
        address owner;
        string content;
        uint256 timestamp;
    }
    
    mapping(bytes32 => Document) public documents;
    
    event DocumentNotarized(bytes32 indexed documentHash, address indexed owner, uint256 timestamp);
    
    function notarizeDocument(string memory _content) public returns (bytes32) {
        bytes32 documentHash = keccak256(abi.encodePacked(_content));
        
        require(documents[documentHash].timestamp == 0, "Document already notarized");
        
        documents[documentHash] = Document(msg.sender, _content, block.timestamp);
        
        emit DocumentNotarized(documentHash, msg.sender, block.timestamp);
        
        return documentHash;
    }
    
    function verifyDocument(bytes32 _documentHash) public view returns (address owner, string memory content, uint256 timestamp) {
        Document memory document = documents[_documentHash];
        require(document.timestamp != 0, "Document not found");
        
        return (document.owner, document.content, document.timestamp);
    }
}
