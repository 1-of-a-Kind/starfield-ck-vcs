import json
from http.server import SimpleHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs

class CKFakeServer(SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urlparse(self.path)

        # ✅ Handling /user?username=JMPZ11
        if parsed_path.path == "/user":
            query_params = parse_qs(parsed_path.query)
            username = query_params.get("username", ["UnknownUser"])[0]

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()

            # ✅ Returns only the userId as expected
            user_response = {
                "userId": 1  # Matches the ID from /users
            }

            self.wfile.write(json.dumps(user_response).encode("utf-8"))
            print(f"✅ Served /user response for {username}: {user_response}")

        # ✅ Handling /users
        elif parsed_path.path == "/users":
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()

            # ✅ Correct structure: { "userId": "username" }
            users_response = {
                "1": "JMPZ11",   # CK expects userId as a string, username as value
                "67890": "DummyUser"
            }

            self.wfile.write(json.dumps(users_response).encode("utf-8"))
            print(f"✅ Served /users response: {users_response}")

        ## Enabling this will cause CK to crash -- dont do it!
        # elif parsed_path.path == "/config/Genesis":
        #     self.send_response(200)
        #     self.send_header("Content-Type", "application/json")
        #     self.end_headers()

        #     # Fake response to trick CK into thinking the Genesis service is available
        #     fake_response = {
        #         "version": "1.0",
        #         "server": "GenesisAssetService",
        #         "status": "ok",
        #         "authRequired": False,
        #         "features": ["perforce", "localization", "versioning"]
        #     }

        #     self.wfile.write(json.dumps(fake_response).encode("utf-8"))
        #     print(f"✅ Served fake /config/Genesis response: {fake_response}")

        # ❌ Any other request gets a 404
        else:
            self.send_response(404)
            self.end_headers()
            print(f"❌ CK requested unknown path: {self.path}")

# Start the fake CK server
def run_server():
    server_address = ("127.0.0.1", 15243)  # Using random low-priv port
    httpd = HTTPServer(server_address, CKFakeServer)
    print("🚀 Fake CK Server Running on http://127.0.0.1:15243 🚀")
    print("Waiting for CK requests...")
    httpd.serve_forever()

if __name__ == "__main__":
    run_server()
