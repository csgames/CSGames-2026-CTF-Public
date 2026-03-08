with open ("/tmp/flag.txt", "rb") as f:
    flag_content = f.read().strip()

key = "e286374bcd860a00003b9fc58b3116e8"

outstr = ""
key_len = len(key)
for i in range(len(flag_content)):
    key_char1 = key[i % key_len]
    key_char2 = chr(ord(key[(i + 1 + 16) % key_len]))
    decoded_char = chr((flag_content[i] - ord(key_char1) - ord(key_char2)) % 256)
    outstr += decoded_char

print(f"Result: {outstr}")
