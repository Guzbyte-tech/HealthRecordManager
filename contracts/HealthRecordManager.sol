// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthRecordManager {

    struct HealthRecord {
        string patientData;
        address patient; 
        uint256 timestamp;
    }

    struct ProviderAccess {
        bool isGranted; // Indicates if the provider has access
        uint256 grantedAt; // Timestamp when access was granted
    }

    mapping(address => HealthRecord[]) private healthRecords; // Patient's health records
    mapping(address => mapping(address => ProviderAccess)) private access; // Access permissions for providers

    event RecordCreated(address indexed patient, uint256 indexed recordIndex);
    event AccessGranted(address indexed patient, address indexed provider);
    event AccessRevoked(address indexed patient, address indexed provider);

    modifier onlyPatient() {
        require(msg.sender != address(0), "Invalid address");
        _;
    }

    // Function to create a new health record
    function createRecord(string memory patientData) public onlyPatient {
        HealthRecord memory newRecord = HealthRecord({
            patientData: patientData,
            patient: msg.sender,
            timestamp: block.timestamp
        });

        healthRecords[msg.sender].push(newRecord);

        emit RecordCreated(msg.sender, healthRecords[msg.sender].length - 1);
    }

    // Function to grant access to a healthcare provider
    function grantAccess(address provider) public onlyPatient {
        require(provider != address(0), "Invalid provider address");
        access[msg.sender][provider] = ProviderAccess({
            isGranted: true,
            grantedAt: block.timestamp
        });

        emit AccessGranted(msg.sender, provider);
    }

    // Function to revoke access from a healthcare provider
    function revokeAccess(address provider) public onlyPatient {
        require(provider != address(0), "Invalid provider address");
        access[msg.sender][provider].isGranted = false;

        emit AccessRevoked(msg.sender, provider);
    }

    // Function to view health records for authorized providers
    function viewRecord(address patient, uint256 recordIndex) public view returns (string memory) {
        require(access[patient][msg.sender].isGranted, "Access not granted");
        require(recordIndex < healthRecords[patient].length, "Invalid record index");

        return healthRecords[patient][recordIndex].patientData;
    }

    // Function to get the number of records for a patient
    function getRecordCount() public view returns (uint256) {
        return healthRecords[msg.sender].length;
    }
}
