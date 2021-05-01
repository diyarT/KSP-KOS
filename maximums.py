import sys

import numpy
import sympy as sympy
from sympy import integrate

pathToTimeTxtFile = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Kerbal Space Program\\Ships\\Script\\time.txt"
pathToCompleteTimeTxtFile = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Kerbal Space Program\\Ships\\Script\\completeTime.txt"
pathToAccelerationTxtFile = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Kerbal Space Program\\Ships\\Script\\acceleration.txt"
pathToWriteCalculatedValue = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Kerbal Space Program\\Ships\\Script\\calculation.txt"

completeTime = 0
time = list()
acceleration = list()
x = sympy.Symbol('x')

while True:
    try:
        with open(pathToTimeTxtFile) as f:
            time.clear()
            for line in f:
                time.append(round(float(line), 6))

        with open(pathToCompleteTimeTxtFile) as f:
            for line in f:
                completeTime = round(float(line),4)
        with open(pathToAccelerationTxtFile) as f:
            acceleration.clear()
            for line in f:
                acceleration.append(round(float(line), 6))



        function = numpy.polyfit(time, acceleration, 4)
        altitude = \
            integrate(integrate(
                function[0] * x ** 4 + function[1] * x ** 3 + function[2] * x ** 2 + function[3] * x + function[4], x),
                (x, 0, completeTime))
        with open(pathToWriteCalculatedValue, "w") as f:
            f.write(str(altitude))
        print(altitude, end="\r", flush=True)
    except:
        pass
