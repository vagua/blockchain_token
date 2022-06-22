pragma solidity^0.5.0;
contract Ticket{
    address payable Host; //主辦單位的錢包
    uint public TicketPrice; //票價
    uint public MaxTickets; //總票數
    uint public SalesTime; //當日販售結束時間
    uint public OwnedTickets;//持有多少票
    uint public TicketAmount;//販售出了多少票
    mapping(address => uint) public Tickets;


    constructor(uint _price, uint _people, uint _time) public{
        Host = msg.sender;
        TicketPrice = 1 finney*_price;
        MaxTickets = _people;
        SalesTime = now + (1 days*_time);
    }

    //簡易資訊
    function info() public view returns(string memory,uint,string memory,uint,string memory,uint){
        return ("票價(finney)",TicketPrice/10**15,"剩餘票數",MaxTickets-TicketAmount,"剩餘時間",SalesTime-now); 
    }

    //買票
    function buyTikcet(uint _Amount) public payable{
        require(now <= SalesTime,"超出時間"); //確認有無超過販售時間
        require(TicketAmount+_Amount < MaxTickets,"已超過可售票數"); //確認沒有超過總售票量
        require(msg.value == TicketPrice*_Amount,"不符合票價"); //確認支付的錢跟售價一樣

        TicketAmount+=_Amount;//更新販售票數
        Tickets[msg.sender]+=_Amount; //紀錄
    }


    //主辦驗票
    function verify(address _costumer) public view returns(uint){
        require (msg.sender == Host); //只有Host能夠使用
        return Tickets[_costumer];
    }

    //主辦提款
    function withdraw() public{
        require (msg.sender == Host); //只有Host能夠使用
        Host.transfer(address(this).balance); //轉帳到主辦單位的錢包
    }

    
}