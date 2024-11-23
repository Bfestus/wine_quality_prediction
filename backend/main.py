from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, ValidationError
import pickle
import numpy as np

# Initialize FastAPI app
app = FastAPI()

# Load the Random Forest model
with open("random_forest_model.pkl", "rb") as file:
    model = pickle.load(file)

# Define the input schema with limits for each feature
class WineFeatures(BaseModel):
    fixed_acidity: float = Field(..., ge=0, le=15, description="Fixed Acidity (0-15)")
    volatile_acidity: float = Field(..., ge=0, le=2, description="Volatile Acidity (0-2)")
    citric_acid: float = Field(..., ge=0, le=1, description="Citric Acid (0-1)")
    alcohol: float = Field(..., ge=0, le=20, description="Alcohol (0-20)")
    residual_sugar: float = Field(..., ge=0, le=50, description="Residual Sugar (0-50)")
    pH: float = Field(..., ge=0, le=14, description="pH (0-14)")

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "Welcome to the Wine Quality Prediction API"}

# Prediction endpoint
@app.post("/predict")
def predict_wine_quality(features: WineFeatures):
    try:
        # Extract input features and convert to numpy array
        input_data = np.array([[
            features.fixed_acidity,
            features.volatile_acidity,
            features.citric_acid,
            features.alcohol,
            features.residual_sugar,
            features.pH,
        ]])

        # Predict wine quality using the Random Forest model
        prediction = model.predict(input_data)

        return {"prediction": int(prediction[0])}

    except ValidationError as e:
        raise HTTPException(status_code=422, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
