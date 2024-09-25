#!/usr/bin/env python3

import sys
import json

def main():
    # Read the task being added
    task = json.loads(sys.stdin.readline())

    cod = float(task.get('cod', 0))
    duration = float(task.get('duration', 1))

    # Avoid division by zero
    if duration == 0:
        duration = 1

    wsjf = cod / duration
    task['wsjf'] = wsjf

    # Output the modified task
    sys.stdout.write(json.dumps(task))
    sys.exit(0)

if __name__ == '__main__':
    main()

