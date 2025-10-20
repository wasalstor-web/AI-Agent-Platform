import requests
import logging
import time

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

API_URL = 'http://localhost:8000'
API_KEY = 'aip_bb1dc27e182e83edcf6ea1e6b989d3c8d32d0e54a00b26f39cfda657fc493cea'
RETRY_LIMIT = 3
RETRY_DELAY = 2

def send_command(command):
    url = f"{API_URL}/send-command"
    headers = {
        'Authorization': f"Bearer {API_KEY}",
        'Content-Type': 'application/json'
    }
    data = {'command': command}

    for attempt in range(RETRY_LIMIT):
        try:
            response = requests.post(url, json=data, headers=headers)
            response.raise_for_status()  # Raise an error for bad responses
            logging.info(f"Command sent successfully: {response.json()}")
            return response.json()
        except requests.exceptions.RequestException as e:
            logging.error(f"Attempt {attempt + 1} failed: {e}")
            time.sleep(RETRY_DELAY)

    logging.error("All attempts to send the command failed.")
    return None

if __name__ == "__main__":
    command = input("Enter the command to send: ")
    send_command(command)