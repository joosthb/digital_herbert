#!/usr/bin/env python3
import socket
import json
from math import radians, cos, sin, asin, sqrt
import time

def haversine(lon1, lat1, lon2, lat2):
    """
    Calculate the great circle distance in kilometers between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])

    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    r = 6371.137 # Radius of earth in kilometers. Use 3956 for miles. Determines return value units.
    return c * r * 1000.0 # to meters

# Create a socket (SOCK_STREAM means a TCP socket)
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

try:
  # Connect to server and send data
  sock.connect(('localhost', 2947))
  # send watch command 
  sock.send(bytes('?WATCH={"enable":true,"json":true};', 'UTF-8'))

except Exception as e:
  print(e)

last = {}
# implemented write buffer to prevent flash-mem-wear
lastwrite = 0.0
writebuffer = []

while True:
  try:
    # Receive data from the server and shut down
    received = json.loads(sock.recv(1024).decode('UTF-8'))
  except json.JSONDecodeError:
    continue

  if received['class'] == 'TPV':
    print(received)
    if not last:
      last = received
    else:
      # if delta in meters > 10
      if haversine(last['lat'], last['lon'], received['lat'], received['lon']) > 10.0:
        writebuffer.append(json.dumps(received))
        # only write once an hour or after 10 entries to preveent wear
        if len(writebuffer) > 9 or time.time() - lastwrite > 3600:
          with open('gpstrack.json', 'a', encoding='utf-8') as f:
            f.write('\n'.join(writebuffer))
          writebuffer=[]
          lastwrite = time.time()
        # update last saved
        last = received

