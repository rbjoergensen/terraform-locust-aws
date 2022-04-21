from locust import HttpUser, TaskSet, task, between
import random
import json

class MyTask(HttpUser):
    host = 'https://callofthevoid.dk'
 
    wait_time = between(3, 9)

    @task(1) 
    def index(self):
        self.client.get('/')

    @task(3) 
    def image(self):
        self.client.get('/robot_remaster.gif')
