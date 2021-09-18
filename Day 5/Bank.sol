Source Code:
pragma solidity ^0.5.13;

contract Bank{
    
    mapping(address => uint256) public accountbal;
    
     function depositeMoney() public payable{
         accountbal[msg.sender]= accountbal[msg.sender]+msg.value;
        }
     function withdrawMoney(uint256 amt)public{
         require(accountbal[msg.sender]>=amt*1 ether ,"Balance is low");
         uint amtIneth = amt * 1 ether;
         msg.sender.transfer(amtIneth);
         accountbal[msg.sender]=accountbal[msg.sender]-amtIneth;
     }
     function bankBalance()public view returns(uint amount){
         return address(this).balance/1 ether;
     }
    function checkMyBalance()public view returns(uint amount){
         return accountbal[msg.sender]/1 ether;
     }
    }
    
    
