import "@stdlib/deploy";
import "@stdlib/ownable";

contract Lotton with Deployable, OwnableTransferable{
    const Price: Int = ton("5");
    const gasConsumption: Int = ton("0.03");//뭔지 모르겠다
    startTime:Int;
    endTime:Int;
    raffleStatus: Bool;
    owner: Address;
    maxTicket: Int;
    participateNum: Int = 0;
    participate:  map<Int, Address>;// 이따가 사용법 알아내야함 
    winners: map<Int,Address>;
 

    init() {
        self.startTime = now();
        self.endTime = self.startTime + 86400;
        self.owner = sender();
        self.raffleStatus = true;
        self.maxTicket = 300;
    }

    fun checkAddress(address:Address): Int {
        let i: Int = 0;
        while(i <= self.participateNum){
            if (address == self.participate.get(i))
            {
                return 1;
            }
        }
        return 0;
    }
    
    fun sendMoney(address:Address, money:Int){
        let to: Address = address;
        let value: Int = money;
        send(SendParameters{
            to: to,
            value: value, 
            mode: SendIgnoreErrors, 
            bounce: true, 
            body: "Congrats!".asComment()
        });

    }
    
    receive("participate") {
        require(myBalance() >= self.Price, "Send more money");
        require(self.participateNum < self.maxTicket, "full participate!");
        require(self.checkAddress(sender())==0,"you already participate");

        self.participate.set(self.participateNum,sender());
        self.participateNum = self.participateNum +1;
    }
    

    receive("random"){
        self.requireOwner(); // 이거 다른곳에서 어떻게 했는지 찾자
        require(self.raffleStatus==1,"raffle end");
        
        require(now() > self.endTime, "time yet");
    
        //시간이 end time 이상이라면 이라는 require 넣기 
        let balance:Int = myBalance();
        let firstPrice:Int  =  balance*7/10;   // 1등 돈 준다 70% 700
        let secondPrice:Int  = balance*2/10;     // 2등 돈준다 20% 200
        let thirdPrice:Int  = balance*5/100;     // 3등 돈준다 5% 50

        
        let firstWinner: Address = self.participate.get(random(1, self.participateNum))!!;
        let secondWinner: Address = self.participate.get(random(1, self.participateNum))!!;
        let thirdWinner: Address = self.participate.get(random(1, self.participateNum))!!;
       

        self.sendMoney(firstWinner,firstPrice);
        self.sendMoney(firstWinner,secondPrice);
        self.sendMoney(firstWinner,thirdPrice);
        self.sendMoney(self.owner, myBalance());
        self.winners.set(1,firstWinner);
        self.winners.set(2,secondWinner);
        self.winners.set(3,thirdWinner);
       

        self.raffleStatus == 0;
        
    }

    get fun winners(): map<Int,Address>{
        return self.winners;
    }
}
