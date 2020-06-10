from locust import HttpUser, TaskSet, task, between
import random
import json
import csv

#tokens = []

#with open('tokens.csv') as csvfile:
#    readCSV = csv.reader(csvfile, delimiter = ',')
#    for row in readCSV:
#        tokens.append({
#            'token': row[0],
#        })

#def getActor():
#    return random.choice(tokens)


class MyTask(HttpUser):

    host = 'https://callofthevoid.dk'
 
    wait_time = between(3, 9)

    @task(1) 
    def index(self):
        self.client.get('/')

    @task(3) 
    def image(self):
        self.client.get('/robot_remaster.gif')

    #def on_start(self):
    #    #self.actor = 'test' #getActor()
    #    self.index()

    #def getHeaders(self):
    #    headers = {
    #        'Authorization': 'Bearer ' + self.actor['token'],
    #        'content-type': 'application/json'
    #    }
    #    return headers

    #@task(3)
    #def somethingelse(self):
        #self.client.get('/endpoint/something/else', headers = self.getHeaders())
        #self.client.get('/endpoint/something/1', headers = self.getHeaders())