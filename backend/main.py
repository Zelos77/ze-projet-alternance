from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
import boto3
import uuid
import datetime

app = FastAPI()

# CORS pour permettre les appels depuis le site
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('CommentairesAlternance')

@app.post("/commentaires")
async def save_comment(data: dict):
    item = {
        "id": str(uuid.uuid4()),
        "sectionId": data["sectionId"],
        "pseudo": data["pseudo"],
        "commentaire": data["commentaire"],
        "timestamp": datetime.datetime.utcnow().isoformat()
    }
    table.put_item(Item=item)
    return {"message": "Commentaire sauvegardé"}

@app.get("/commentaires")
async def get_comments(sectionId: str):
    response = table.query(
        IndexName="sectionId-timestamp-index",
        KeyConditionExpression=boto3.dynamodb.conditions.Key('sectionId').eq(sectionId),
        ScanIndexForward=False
    )
    return response['Items']

# Health check
@app.get("/health")
def health_check():
    return {"status": "ok"}