import cv2
import time
from Crypto.Cipher import ChaCha20
import socket

#Initialize the camera and socket
cap = cv2.VideoCapture(0)

#Use fixed key and nonce
key = b'\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20'  # 32-byte key
nonce = b'\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c'  # 12-byte nonce

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.connect(('192.168.4.32', 9999))  # Replace with the IP of the PC

while True:
    ret, frame = cap.read()

    if not ret:
        break

    # Display the original video on the Raspberry Pi
    cv2.imshow('Original Video', frame)

    # Measure encryption time
    start_time = time.time()

 #Reinitialize cipher for each frame with the fixed key and nonce
    cipher = ChaCha20.new(key=key, nonce=nonce)

#Encrypt the frame
    encrypted_frame = cipher.encrypt(frame.tobytes())

    end_time = time.time()
    encryption_time = end_time - start_time
    print(f"Encryption Time: {encryption_time:.6f} seconds")

    # Send encrypted frame to PC
    sock.sendall(encrypted_frame)

    # Exit if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
sock.close()
cv2.destroyAllWin
