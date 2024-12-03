from transformers import pipeline
import torch

model_id = "meta-llama/Meta-Llama-Guard-2-8B"

try:
    text_gen_pipeline = pipeline(
        "text-generation",
        model=model_id,
        model_kwargs={"torch_dtype": torch.bfloat16},
        device_map="auto"
    )
    print(text_gen_pipeline("Hey, how are you doing today?"))
except OSError as e:
    print(f"Error: {e}. Please ensure the model path or ID is correct.")
