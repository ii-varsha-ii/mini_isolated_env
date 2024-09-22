import multiprocessing
import time
import psutil

def busy_cpu_task():
    while True:
        pass

def measure_cpu_utilization(interval=1):
    while True:
        cpu_percent = psutil.cpu_percent(interval=interval)
        print(f"Current CPU utilization: {cpu_percent}%")
        time.sleep(interval)

if __name__ == "__main__":
    print("Test CPU:")
    num_tasks = multiprocessing.cpu_count()

    processes = [multiprocessing.Process(target=busy_cpu_task) for _ in range(num_tasks)]

    cpu_utilization_process = multiprocessing.Process(target=measure_cpu_utilization)
    cpu_utilization_process.start()

    for process in processes:
        process.start()

    time.sleep(10)
    for process in processes:
        process.terminate()
    cpu_utilization_process.terminate()

    print("CPU utilization test complete.")
