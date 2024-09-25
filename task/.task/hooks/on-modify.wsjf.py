#!/usr/bin/env python3

import sys
import json

def main():
    original_task = json.loads(sys.stdin.readline())
    modified_task = json.loads(sys.stdin.readline())

    cod = float(modified_task.get('cod', 0))
    duration = float(modified_task.get('duration', 1))

    # Avoid division by zero
    if duration == 0:
        duration = 1

    wsjf = cod / duration
    modified_task['wsjf'] = wsjf

    sys.stdout.write(json.dumps(modified_task))
    sys.exit(0)

if __name__ == '__main__':
    main()

