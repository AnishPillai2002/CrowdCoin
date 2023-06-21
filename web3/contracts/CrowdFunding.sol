// SPDX-License-Identifier: UNLICENSED

//source code is written for Solidity version 0.8.9
pragma solidity ^0.8.9;

contract CrowdFunding {
    
    struct Campaign {

        address owner; //represents a 20-byte Ethereum address. It can hold the address of an Ethereum account or a contract.
        
        string title;  //used to store a variable-length string of UTF-8 encoded characters. In the code, it is used to store the title, description, and image of a crowdfunding campaign.
        string description;
        string image;
        
        uint256 target;    //This type represents unsigned integers of 256 bits (32 bytes) in size. 
        uint256 deadline; //It is commonly used for arithmetic and storage purposes. In the code, it is used to represent the target amount, deadline, amount collected, and donations for a campaign.
        uint256 amountCollected;    
        
        address[] donators; //array of address types. It is used in the Campaign struct to store the addresses of donators who contributed to the campaign.
        uint256[] donations; //array of uint256 types. It is used in the Campaign struct to store the amounts donated by different contributors.
    }
    
    //declares a public mapping named campaigns in the CrowdFunding contract.
    mapping(uint256 => Campaign) public campaigns;

    //global variable to store the number of campaigns

    uint256 public numberOfCampaigns = 0;

    //---------------Functions--------------------------------------
    
    // Function to Create a Campaign
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    // Function to Donate to a Campaign
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }


    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}



/*
-----------------DOCUMENTATION--------------------------------------------------

The line `mapping(uint256 => Campaign) public campaigns;` 

declares a public mapping named `campaigns` in the `CrowdFunding` contract. 

A mapping is a data structure in Solidity that allows you to associate values with unique keys. In this case, the keys are of type `uint256`
(unsigned integers of 256 bits) and the values are of type `Campaign` (a struct defined earlier in the code).

By making the mapping `public`, Solidity automatically generates a getter function for the `campaigns` mapping. 
This allows external contracts or users to access the values stored in the mapping.

The mapping `campaigns` is used to store information about different crowdfunding campaigns. 
The keys (of type `uint256`) represent unique identifiers for each campaign, and the corresponding values (of type `Campaign`) 
hold the detailed information about the campaign, such as the owner, title, description, target amount, deadline, amount collected, donators, and donations.

By using this mapping, you can easily retrieve and manipulate campaign data by specifying the 
campaign's unique identifier (key) to access its associated information (value).




 */