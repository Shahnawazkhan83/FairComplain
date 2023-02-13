// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Complaint {
    address public officer;
    address public owner;
    uint256 public nextId;
    uint256[] public pendingApprovals;
    uint256[] public pendingResolutions;
    uint256[] public resolvedCases;

    constructor(address _officer) {
        owner = msg.sender;
        officer = _officer;
        nextId = 1;
    }

    modifier onlyowner() {
        require(
            msg.sender == officer,
            "You are not the officer of this smart contract"
        );
            _; 
    }

    modifier onlyofficer() {
        require(
            msg.sender == officer,
            "You are not the offficer of this smart contract"
        );
            _;
    }

    struct complaint {
        uint256 id;
        address complaintRegisteredBy;
        string title;
        string description;
        string approvalRemarks;
        string resolutionRemark;
        bool isApproved;
        bool isResolved;
        bool exists;
    }
    mapping(uint256 => complaint) public Complaints;

    event complaintFiled(
        uint256 id,
        address complaintRegisteredBy,
        string title
    );

    function filecomplaint(string memory _title, string memory _description)
        public
    {
        complaint storage newComplaint = Complaints[nextId];
        newComplaint.id = nextId;
        newComplaint.complaintRegisteredBy = msg.sender;
        newComplaint.title = _title;
        newComplaint.description = _description;
        newComplaint.approvalRemarks = "pending Approval";
        newComplaint.resolutionRemark = "pending Resolution";
        newComplaint.isApproved = false;
        newComplaint.isResolved = false;
        newComplaint.exists = true;
        emit complaintFiled(nextId, msg.sender, _title);
        nextId++;
    }

    function approveComplaint(uint256 _id, string memory _approvalRemark)
        public
        onlyofficer
    {
        require(
            Complaints[_id].exists == true,
            "This complaint id does not exixt"
        );
        require(
            Complaints[_id].isApproved == false,
            "complaint is already approved"
        );
        Complaints[_id].isApproved = true;
        Complaints[_id].approvalRemarks = _approvalRemark;
    }

    function declineComplaint(uint256 _id, string memory _approvalRemark)
        public
        onlyofficer
    {
        require(
            Complaints[_id].exists == true,
            "This complaint id does not exixt"
        );
        require(
            Complaints[_id].isApproved == false,
            "complaint is already approved"
        );
        Complaints[_id].isApproved = false;
        Complaints[_id].approvalRemarks = _approvalRemark;
    }

    function resolveComplaint(uint256 _id, string memory _resolutionRemark)
    public
    onlyofficer
    {
         require(
            Complaints[_id].exists == true,
            "This complaint id does not exixt"
        );
        require(
            Complaints[_id].isApproved == true,
            "complaint is already approved"
        );
        require(
            Complaints[_id].isResolved == false,
            "complaint is already resolved"
        );
         Complaints[_id].isResolved = true;
         Complaints[_id].resolutionRemark = _resolutionRemark;
    }

    function calcPendingApprovalIds() public {
        delete pendingApprovals;
        for(uint256 i= 1; 1< nextId; i++) {
            if(
                Complaints[i].isApproved == false &&
                Complaints[i].exists == true
            ) {
                pendingApprovals.push(Complaints[i].id);
            }
        }
    }

    function calcPendingResolutionIds() public {
        delete pendingResolutions;
        for(uint256 i= 1; 1< nextId; i++) {
            if(
                Complaints[i].isResolved == false &&
                Complaints[i].isApproved == true &&
                Complaints[i].exists == true
            ) {
                pendingResolutions.push(Complaints[i].id);
            }
        }
    }

    function calcPendingResolved() public {
        delete resolvedCases;
        for(uint256 i= 1; 1< nextId; i++) {
            if( Complaints[i].isResolved == true ) {
                resolvedCases.push(Complaints[i].id);
            }
        }
    }

    function setOfficerAddress(address _officer) public onlyowner {
        owner = _officer;
    }
}
