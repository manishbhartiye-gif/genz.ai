import hmac
import hashlib
import time
from multiprocessing import shared_memory

class SecurityKernel:
    def __init__(self, shm_name="agentic_os_secret"):
        self.shm_name = shm_name

    def get_current_secret(self):
        try:
            shm = shared_memory.SharedMemory(name=self.shm_name)
            token = bytes(shm.buf[:32])
            shm.close()
            return token
        except FileNotFoundError:
            return None

    def validate_request(self, challenge, timestamp):
        # Prevent replay attacks by checking timestamp window (e.g., 60 seconds)
        if abs(time.time() - timestamp) > 60:
            return False
            
        secret = self.get_current_secret()
        if not secret:
            return False
            
        # Re-calculate HMAC using the shared secret and timestamp
        expected_hmac = hmac.new(secret, str(timestamp).encode(), hashlib.sha256).hexdigest()
        return hmac.compare_digest(expected_hmac, challenge)