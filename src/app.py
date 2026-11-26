import os

import mysql.connector
from flask import Flask, flash, redirect, render_template, request, url_for
from mysql.connector import Error

# templates/ sits at the top of the repo, next to src/
app = Flask(__name__, template_folder="../templates")
app.secret_key = "change-me"  # needed for flash messages

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", ""),
    "database": os.getenv("DB_NAME", "pharmacyDb"),
}

# must match the paymentMethod ENUM in SalesTransaction
PAYMENT_METHODS = ["Cash", "GCash", "Maya", "Credit Card", "Debit Card"]


def get_conn():
    return mysql.connector.connect(**DB_CONFIG)


def query(sql, params=()):
    """Run a SELECT and return a list of dicts."""
    conn = get_conn()
    try:
        cur = conn.cursor(dictionary=True)
        cur.execute(sql, params)
        return cur.fetchall()
    finally:
        conn.close()


def run(sql, params, ok_msg, back_to):
    """Run an INSERT/UPDATE, flash the result, and redirect."""
    conn = get_conn()
    try:
        conn.cursor().execute(sql, params)
        conn.commit()
        flash(ok_msg, "success")
    except Error as e:
        flash(e.msg, "danger")
    finally:
        conn.close()
    return redirect(url_for(back_to))


@app.route("/")
def index():
    low_stock = query("SELECT * FROM vwLowStock ORDER BY stock, medicineName")
    expiring = query(
        "SELECT * FROM vwExpiringBatches ORDER BY (status = 'Expired'), expirationDate LIMIT 10"
    )
    sales = query("SELECT * FROM vwSaleTotals ORDER BY transactionDatetime DESC LIMIT 10")
    return render_template("index.html", low_stock=low_stock, expiring=expiring, sales=sales)


@app.route("/medicines")
def medicines():
    rows = query("SELECT * FROM vwMedicineStock ORDER BY medicineName")
    return render_template("medicines.html", medicines=rows)


@app.route("/medicines/add", methods=["POST"])
def add_medicine():
    f = request.form
    return run(
        """INSERT INTO Medicine (medicineName, genericName, dosage, unitPrice, prescriptionRequired)
           VALUES (%s, %s, %s, %s, %s)""",
        (f["medicineName"], f["genericName"], f["dosage"], f["unitPrice"],
         1 if f.get("prescriptionRequired") else 0),
        "Medicine added.",
        "medicines",
    )


@app.route("/sales/new", methods=["GET", "POST"])
def new_sale():
    if request.method == "POST":
        try:
            medicine_id = int(request.form["medicineId"])
            quantity = int(request.form["quantity"])
            payment = request.form["paymentMethod"]
            conn = get_conn()
            try:
                # the stored procedure does the real work (FEFO batch, triggers, transaction)
                result = conn.cursor().callproc("recordSale", (medicine_id, quantity, payment, 0))
                flash(f"Sale #{result[3]} recorded.", "success")
            finally:
                conn.close()
        except ValueError:
            flash("Enter the quantity as a whole number.", "danger")
        except Error as e:
            flash(e.msg, "danger")
        return redirect(url_for("new_sale"))

    meds = query(
        "SELECT medicineId, medicineName, dosage, unitPrice, prescriptionRequired "
        "FROM Medicine ORDER BY medicineName"
    )
    return render_template("new_sale.html", medicines=meds, payment_methods=PAYMENT_METHODS)


if __name__ == "__main__":
    app.run(debug=True)
