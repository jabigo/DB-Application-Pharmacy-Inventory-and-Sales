# DB-Application-Group-7-Pharmacy-Inventory-and-Sales
## Setup (One time)

1. **Install the Python packages.** From the repository's top folder:
   ```
   pip install -r requirements.txt
   ```
2. **Create the database.** In MySQL Workbench, connect to your local server, open `database/pharmacyDb.sql`, and run the whole script.
   This creates the tables, loads the sample data, and adds the views, triggers, and procedure. Running it again resets the data to the sample set.

## Running the app

1. Open a terminal in the repository's top folder.
2. Set your MySQL password for this terminal window:

   | Terminal | Command |
   |---|---|
   | PowerShell | `$env:DB_PASSWORD="your_password"` |
   | Command Prompt | `set "DB_PASSWORD=your_password"` |
   | Git Bash / macOS / Linux | `export DB_PASSWORD='your_password'` |

3. Start the app:
   ```
   python src/app.py
   ```
4. Open <http://localhost:5000> in a browser.
5. To stop the app, click the terminal and press **Ctrl+C**.
