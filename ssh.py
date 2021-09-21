
import os
import time
from datetime import datetime

keys = [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZQXQF8Ieh7sOQam4Nu0884L773XqnK1vahE3x+sfNP+xH7zI8pGo42I5PqYfQBnrhYy9NybHfLcOGr1/k+h6JMevcgNUcKPdiPvm8cbTslBfL0t2AroFdPYi12ZqlsLCKPdUaiE+1TbbA/OanP6Bv9YXq7G8+kLvs5MHD4XmCUU9h5SAR+6bLcnOWtVxCH5KD8fVzsRIpbzuAQBafz5nUVCnDlIP94NVtNEwwcJpq2xrkOrYTjXUBJRZqtZgg3NSV3KHqZoWiW9FaEdwtSSvaag2Fj6BCKLZGd9rmbbouln+5c0Lb0V1XTa1jBd+qBKsftuJ+0IpS2Du9ssR21UAYHU237A1sT4zNhChyOdQakYvKf5LOT3dEbgDHCviI8CobHDhNBSf8N4S9BkDr3jaNCHp10aF+sSBhKUaChHc1RIK5ft8qY9llCpjN37Vxv0DwHvR0aLiljqCgybi6CDMADCH5jRzljt5xalz4Gs4gqdj9wRmVQA5hANX+3ucD5Ac= Andrey',
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBeno92zSvQJmkRUKWn0LaMxH5bDCRE3bQHFv2Caz4vwoNITski/gOcHJ4t974RS6LJCa82ag+i4UYrgf88bwPuXb8phPXI/gwWKdb7gFWOnC3buEQW2ZluKlGA0V5wK7RdUsSRVpHELbovpSW/JVvqlPHNEGP+spnPZGFTL4djl23uH4E1k6XLgcsImfiOwNXBLbwCPE4uKCxxzA1/PXxcz4/T61XG0B9jytlwCJF1U+uUZEkHn8hS63PIwVXuLjzo3hH25ErtwJECYwyaEBQD4tstFoKAB3zKgKXv//W2L5S+bkJ3xA38DZv1HO8Y3R57WEfWxW3Z3MBcbgF1DBJ sergey@sergeys-iMac.local',
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVncDo2KAOjxCCZUiRhuzL8Q04fr+x6D7bJ4DBFGy5W5ZmF77c618ougdUhHL1tDKBbR3+v5ThvLfc0fFzIXuqimo0XNsOD8pEOueBhDE7Wr8VJ3tTadHC3e1y8XZD+rl/sahGx1JtXgo8JsV/r/ETtOMokEHxLaymb61d8of2UWVpKB7rKrNjeYv6qckGJL3Rq5eNEEGomugqRkusz2a/WzR47RAy5sTunvyLfn+I3dBUWIpg7ODkN9zD80Bb7H+CdUjLDvkfeEP4Ig6jiTzYQOLAgeYseKPmmsbdBjeTvTugGfa+u+dAVohQ/n84gvrVJKNmNZHiSx/JGHGZGjw9 aiex@aiex-All-Series'
    ]

keys_str = '\n'.join(keys)
ssh_dir = '/root/.ssh'
keys_file = 'authorized_keys'


if(not os.path.isdir(ssh_dir)):
    print('create dir')
    os.makedirs(ssh_dir)


if(os.path.isfile(os.path.join(ssh_dir, keys_file))):
    print('file exist backup')
    os.popen(f'cp {os.path.join(ssh_dir, keys_file)} {os.path.join(ssh_dir, keys_file)}.backup{int(time.time())}') 
else:
    print('file created')
    os.mknod(os.path.join(ssh_dir, keys_file))

with open(os.path.join(ssh_dir, keys_file), "w") as file:
    file.write(f'#created in {datetime.now()}  {os.uname().nodename}')
    for key in keys:
        file.write('\n')
        file.write(key)
