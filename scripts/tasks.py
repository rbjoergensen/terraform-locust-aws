from locust import HttpLocust, TaskSet, task, between
import random
import json
import csv

tokens = []

with open('tokens.csv') as csvfile:
    readCSV = csv.reader(csvfile, delimiter = ',')
    for row in readCSV:
        tokens.append({
            'token': row[0],
        })

def getActor():
    return random.choice(tokens)


class ApiTests(TaskSet):
    def on_start(self):
        self.actor = getActor()
        self.openApp()

    def getHeaders(self):
        headers = {
            'Authorization': 'Bearer ' + self.actor['token'],
            'content-type': 'application/json'
        }
        return headers

    @task(1)
    def something(self):
        self.client.get('/endpoint/something', headers = self.getHeaders())
        self.client.get('/endpoint/something/1', headers = self.getHeaders())

    @task(3)
    def somethingelse(self):
        self.client.get('/endpoint/something/else', headers = self.getHeaders())

class LocustTest(HttpLocust):
    task_set = ApiTests
    wait_time = between(3, 9)
    if __name__ == "__main__":
        host = "https://api.cotv.dk"

if __name__ == "__main__":
    LocustTest().run()