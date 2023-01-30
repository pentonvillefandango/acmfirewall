# acmfirewall

v0.1
Initial commit
Added check for root user
Added check for existence of provided file

v0.2
Basic Functionality
acmfirewall -b <path/to/file> blocks CIDRS in file
acmfirewall -u <path/to/file> unblocks CIDRs in file
acmfirewall -l <path/to/file> lists blocked CIDRs
