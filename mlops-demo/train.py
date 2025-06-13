import pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import joblib
import os

# Sample data
data = pd.DataFrame({
    "hours_studied": [1, 2, 3, 4, 5],
    "score": [40, 50, 60, 70, 80]
})

X = data[["hours_studied"]]
y = data["score"]

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

model = LinearRegression()
model.fit(X_train, y_train)

# Save model
os.makedirs("model", exist_ok=True)
joblib.dump(model, "model/model.pkl")

print("Model trained and saved.")
