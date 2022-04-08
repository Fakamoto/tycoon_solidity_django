from django.shortcuts import render
from django.http import HttpResponse
from brownie import *
from .utils import Player


if not network.is_connected():
    network.connect("development")
a = network.accounts

try:
    myProject = project.load("brownie_files")
except:
    myProject = project.get_loaded_projects()[0]

global player
global dic
me = a[0]
payDic = {"from": me}
contract = myProject.Game.deploy(payDic)
player = Player(contract=contract, payDic=payDic, me=me)
dic = {}
dic["action1"] = 0
dic["action2"] = 0
dic["action3"] = 0
dic["action4"] = 0
def home(request):
    global dic
    button = request.POST.get('button', False)
    if button:
        number = int(request.POST.get('button', 4))
        if number == 1:
            player.buyLand()
        elif number == 2:
            player.buyCollector()
        elif number == 3:
            player.upgradeMultiplier()
        elif number == 4:
            player.refreshState()
        player.goldRefresh()
        if not player.win:
            array = player.display()
        else:
            array = [0] * 4
            player.win = False
        dic = {}
        dic["action1"] = array[0]
        dic["action2"] = array[1]
        dic["action3"] = array[2]
        dic["action4"] = array[3]
        
    return render(request, "index.html", dic)
