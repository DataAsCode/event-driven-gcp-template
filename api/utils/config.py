from dotenv import load_dotenv
from pydantic_settings import BaseSettings

load_dotenv()

class Settings(BaseSettings):
    LOGFIRE_TOKEN: str
    BUCKET_NAME: str

    API_V1_STR: str = "/api/v1"


settings = Settings()
