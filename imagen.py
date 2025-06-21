import base64
from datetime import datetime
import pandas as pd
from openai import OpenAI
client = OpenAI(api_key="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")

df = pd.read_excel("prompts.xlsx")

# for i, row in df.iterrows():

user_input = """ Ansel crouching in ankle-deep mud, cracked spoon in hand, tunic soaked and clinging to his back,
steam rising faintly from his breath, fingers curled stiffly in the cold"""
    # user_input = row['prompt']

prompt = f"""
Generate image which describes followig content like a drawing on an old manuscript with medium image quality.
the character should be like the provided first image
the style should be like the provided second image second image is the style reference

{user_input}
"""

result = client.images.edit(
    model="gpt-image-1",
    image=[
        open("image1.png", "rb"),
        open("image2.png", "rb")
    ],
    quality="low",
    size="1536x1024",
    prompt=prompt,
)

image_base64 = result.data[0].b64_json
image_bytes = base64.b64decode(image_base64)    
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
filename = f"{timestamp}.png"

# Save the image to a file
with open(filename, "wb") as f:
    f.write(image_bytes)