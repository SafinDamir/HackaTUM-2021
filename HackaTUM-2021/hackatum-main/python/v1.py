import numpy as np
from typing import Tuple, List
import matplotlib.pyplot as plt

SIM_OBJECTS = []
N_SAT = 3
V_SAT = 10
H_SAT = 0.05
ACTIVE_ANGLES = np.multiply((10, 75), np.pi / 180)
N_STEPS = 1000


class Plane:
    def __init__(self, location: float):
        self.location = location


class Satellite:
    def __init__(self, location: float, height: float, velocity: float):
        self.velocity = velocity
        self.location = location
        self.height = height
        self.location_hist = []

    def update(self, dt) -> None:
        self.location += self.velocity * dt
        if self.location > 1:
            self.location -= 2
        self.location_hist.append(self.location)

    def angle_to_plane(self, plane: Plane) -> float:
        dist = np.abs(plane.location - self.location)
        return np.tan(self.height / dist)


def update(dt: float) -> None:
    for element in SIM_OBJECTS:
        element.update(dt)


def check_good_sats(plane: Plane, sats: List[Satellite]) -> int:
    good_sats = 0
    for sat in sats:
        angle = sat.angle_to_plane(plane)
        if ACTIVE_ANGLES[0] < angle < ACTIVE_ANGLES[1]:
            good_sats += 1

    return good_sats


def plot_good_sats(history: List[int], dt) -> None:
    fig, ax = plt.subplots(figsize=(10, 10))
    time_steps = np.arange(len(history)) * dt

    ax.plot(time_steps, history)

    ax.set_ylabel('Nbr. of good satellites')
    ax.set_xlabel('time')
    ax.set_xlim(min(time_steps), max(time_steps))

    plt.show()


def plot_sats_location(satellites: List[Satellite], dt):
    fig, ax = plt.subplots(figsize=(10, 10))
    time_steps = np.arange(len(satellites[0].location_hist)) * dt
    for sat in satellites:
        ax.plot(time_steps, sat.location_hist)

    ax.set_ylabel('location')
    ax.set_xlabel('time')
    ax.set_xlim(min(time_steps), max(time_steps))

    d_start = H_SAT / ACTIVE_ANGLES[0]
    d_end = H_SAT / ACTIVE_ANGLES[1]
    ax.fill_between(time_steps, -d_start, -d_end, facecolor='gray', alpha=0.3)
    ax.fill_between(time_steps, d_start, d_end, facecolor='gray', alpha=0.3)

    plt.show()


def main():
    plane = Plane(location=0)

    satellites = []
    for location in np.linspace(-1, 1, N_SAT + 1):
        satellites.append(Satellite(location, height=H_SAT, velocity=V_SAT))
    satellites.pop()
    SIM_OBJECTS.extend(satellites)

    t_sim = 2 / V_SAT
    dt = t_sim / N_STEPS
    good_sats_ts = []  # good sats over every time_step
    for step in range(N_STEPS):
        update(dt)
        good_sats_ts.append(check_good_sats(plane, satellites))

    plot_good_sats(good_sats_ts, dt)
    plot_sats_location(satellites, dt)


if __name__ == '__main__':
    main()
