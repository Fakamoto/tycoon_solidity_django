from brownie import *
import time


class Player:
    def __init__(self, contract, payDic, me):
        self.contract = contract
        self.payDic = payDic
        self.me = me
        self.balance = 0
        self.gold = 0
        self.collectors = 0
        self.multiplier = 0
        self.lastCheck = int(time.time())
        self.win = False

    def buyLand(self):
        try:
            self.contract.buyLand({"from": self.me, "value": Wei("1 ether")})
            self.refreshState()
            self.goldRefresh()
        except:
            return 0

    def buyCollector(self):
        try:
            self.contract.buyCollector(self.payDic)
            self.refreshState()
            self.goldRefresh()
        except:
            return 0

    def upgradeMultiplier(self):
        try:
            self.contract.upgradeMultiplier(self.payDic)
            self.refreshState()
            self.goldRefresh()
        except:
            return 0

    def display(self):
        try:
            self.goldRefresh()
            return self.balance, self.gold, self.collectors, self.multiplier
        except:
            return
    def refreshState(self):
        try:
            self.contract.refresh()
            self.balance = str(round(float(self.me.balance().to("ether")), 4))
            self.gold = int(self.contract.display().return_value[0])
            self.collectors = int(self.contract.display().return_value[1])
            self.multiplier = int(self.contract.display().return_value[2])
        except:
            if self.win:
                 self.gold = 0
                 self.collectors = 0
                 self.multiplier = 0

    def goldRefresh(self):
        new_check = int(time.time())
        remainder = new_check - self.lastCheck
        if self.gold >= 100000 and self.collectors >= 10:
            self.win = True
            self.refreshState()
            return
        if remainder < 1:
            return
        self.lastCheck = new_check
        self.gold += remainder * self.collectors * self.multiplier
