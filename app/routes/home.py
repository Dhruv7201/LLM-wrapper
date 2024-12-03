from transformers import AutoModelForCausalLM, AutoTokenizer
from fastapi import FastAPI

app = FastAPI()

# Load the Llama 2 model and tokenizer
model_name = "meta-llama/Llama-2-7b-chat-hf"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(model_name)

@app.get("/")
async def home():
    return {"message": "Llama 2 Integration Successful!"}

@app.post("/generate")
async def generate_response(prompt: str):
    inputs = tokenizer(prompt, return_tensors="pt")
    outputs = model.generate(**inputs, max_new_tokens=50)
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return {"response": response}
