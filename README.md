# Happy IP Scanner

## A simple IP port scanner for FreeBSD

"Like Angry IP Scanner, but happy!"

I scan to see if lab and production systems are up ALL THE TIME.

The available tools are either heavyweight and slow, or not available on my lab systems.

Happy IP Scanner uses FreeBSD's sh(1), netstat(1), grep(1), awk(1), cut(1), timeout(1), and nc(1), all of which are in-base.

By default it will attempt to determine your subnet based on the default gateway reported by netstat(1), and will scan for ports 22, 80, 443, 3389, and 8080 on IPs .1 through .255. These defaults can be overwritten at the command line:

```
sh hipscan.sh -s 10.0.0 - to scan subnet 10.0.0
sh hipscan.sh -p "23 25" - to scan ports 23 and 25
sh hipscan.sh -l 100 - to begin at low IP <subnet>.100
sh hipscan.sh -h 200 - to end at high IP <subnet>.200
```

hipscan.sh is fast!

It makes no attempt to do a fancy DNS lookups at this time and while netcat's -w "wait" can be reduced to 1 second, that's too long! 'timeout .1' seems to work fine.

There are surely better ways to perform every aspect of this and I looked for existing ones but could not find one that met my needs. This proved instantly useful so I thought I would share it!

## TO DO

Test as a user other than root!
More testing!
Input validation
Maybe DNS lookups but that may require fancy mDNS dependencies

This project is not an endorsement of GitHub
