# **Wine Quality Predictor**

## **Overview**
This project is a Wine Quality Predictor that uses a machine learning model to predict wine quality based on various input features. It consists of:  
1. A mobile app for user interaction.  
2. A REST API built with FastAPI to process predictions.  
3. A video demonstration of the app and API in action.

---

## **Public API Endpoint**
The API is hosted on a publicly routable URL and accepts input values for wine features to return predictions.

### **API URL**:  
[https://winequality-ewyy.onrender.com/docs](https://winequality-ewyy.onrender.com/docs)

You can test the API using Swagger UI by providing the following input values:  
- `fixed_acidity`  
- `volatile_acidity`  
- `citric_acid`  
- `alcohol`  
- `residual_sugar`  
- `pH`  

### **/predict Endpoint**
The `/predict` endpoint accepts these inputs in JSON format and returns the predicted wine quality.

#### **Example Request**:
```json
{
  "fixed_acidity": 7.4,
  "volatile_acidity": 0.7,
  "citric_acid": 0.0,
  "alcohol": 9.4,
  "residual_sugar": 1.9,
  "pH": 3.51
}

# YouTube Video Demo
Watch the video demonstration showcasing:

The mobile app predicting wine quality.
Testing the API using Swagger UI.
