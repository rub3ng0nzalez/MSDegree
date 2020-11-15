from fastapi import FastAPI
from enum import Enum
from typing import Optional
from pydantic import BaseModel
from fastapi.responses import ORJSONResponse
from fastapi.responses import UJSONResponse
from fastapi.responses import HTMLResponse
from fastapi import FastAPI, Response
from fastapi.responses import PlainTextResponse
from fastapi.responses import RedirectResponse
from fastapi.responses import StreamingResponse
from fastapi.responses import FileResponse
from fastapi.responses import StreamingResponse
import pandas as pd
import io


app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World From DataScience Msc"}
    
@app.get("/items/{item_id}")
async def read_item(item_id):
    return {"item_id": item_id}


@app.get("/items/{item_idnum}")
async def read_item(item_idnum: int):
    return {"item_idnum": item_idnum}


@app.get("/users/me")
async def read_user_me():
    return {"user_id": "the current user"}


@app.get("/users/{user_id}")
async def read_user(user_id: str):
    return {"user_id": user_id}
    
    
class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"


@app.get("/model/{model_name}")
async def get_model(model_name: ModelName):
    if model_name == ModelName.alexnet:
        return {"model_name": model_name, "message": "Deep Learning FTW!"}

    if model_name.value == "lenet":
        return {"model_name": model_name, "message": "LeCNN all the images"}

    return {"model_name": model_name, "message": "Have some residuals"}
    
    
##---------------------Query parameters
fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]

@app.get("/items/")
async def read_item(skip: int = 0, limit: int = 10):
    return fake_items_db[skip : skip + limit]
    
    
@app.get("/query/{item_id}")
async def query_item(item_id: str, q: Optional[str] = None):
    if q:
        return {"item_id": item_id, "q": q}
    return {"item_id": item_id}
    

@app.get("/users/{user_id}/items/{item_id}")
async def read_user_item(
    user_id: int, item_id: str, q: Optional[str] = None, short: bool = False
):
    item = {"item_id": item_id, "owner_id": user_id}
    if q:
        item.update({"q": q})
    if not short:
        item.update(
            {"description": "This is an amazing item that has a long description"}
        )
    return item


class Item(BaseModel):
    name: str
    description: Optional[str] = None
    price: float
    tax: Optional[float] = None



@app.post("/items/")
async def create_item(item: Item):
    item.tax = item.price * 0.12
    return item
    
@app.put("/items/{item_id}")
async def update_item(item_id: int, item: Item):
    return {"item_id": item_id, **item.dict()}
    
@app.get("/items/all", response_class=ORJSONResponse)
async def read_items():
    return [{"item_id": "Foo"}]    

@app.get("/items/all", response_class=UJSONResponse)
async def read_items():
    return [{"item_id": "Foo"}]
    
@app.get("/html", response_class=HTMLResponse)
async def read_items():
    return """
    <html>
        <head>
            <title>Some HTML in here</title>
        </head>
        <body>
            <h1>Look ma! HTML!</h1>
        </body>
    </html>
    """

@app.get("/legacy/")
def get_legacy_data():
    data = """<?xml version="1.0"?>
    <shampoo>
    <Header>
        Apply shampoo here.
    </Header>
    <Body>
        You'll have to use soap here.
    </Body>
    </shampoo>
    """
    return Response(content=data, media_type="application/xml")
    
@app.get("/plain/", response_class=PlainTextResponse)
async def main():
    return "Hello World"
    
@app.get("/redirect")
async def read_typer():
    return RedirectResponse("https://youtube.com")


some_file_path = "ejemplo.mp4"


@app.get("/video")
def main():
    file_like = open(some_file_path, mode="rb")
    return StreamingResponse(file_like, media_type="video/mp4")
    

@app.get("/download")
async def main():
    return FileResponse(some_file_path)

@app.get("/get_csv")
async def get_csv():

   df = pd.DataFrame({'col1': [1, 2], 'col2': [3, 4]})

   stream = io.StringIO()

   df.to_csv(stream, index = False)

   response = StreamingResponse(iter([stream.getvalue()]),
                        media_type="text/csv"
   )

   response.headers["Content-Disposition"] = "attachment; filename=export.csv"

   return response
