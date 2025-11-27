import base64
from pathlib import Path

import logfire
import pyarrow as pa
from deltalake import DeltaTable, write_deltalake
from fastapi import APIRouter, Request
from loguru import logger

from api.docs.ingest_delta import docs_ingest_event
from api.models.events import EventModelV1
from api.utils.config import Settings

settings = Settings()

logfire.configure(token=settings.LOGFIRE_TOKEN, handlers=[logfire.loguru_handler()])

router = APIRouter(tags=["ingest"])

BUCKET_NAME = "event-driven"
PATH_TO_FOLDER_JINJA_SQL = Path(__file__).parent / "sql"
GCS_PATH = f"gs://{BUCKET_NAME}/ingest_table"


@router.post("/ingest_event", **docs_ingest_event.model_dump())
async def ingest_delta(request: Request):
    cloudevent = await request.json()
    pubsub_data_base64 = cloudevent.get("message").get("data")
    data_decoded = base64.b64decode(pubsub_data_base64).decode("utf-8")

    logger.info(f"🗓️ CloudEvent Pub/Sub decoded: {data_decoded}")
    logger.info(f"🆔 ID (ce-id): {request.headers.get('ce-id')}")
    logger.info(f"🏷️ Type (ce-type): {request.headers.get('ce-type')}")

    data_to_ingest = EventModelV1(id=request.headers.get("ce-id"), **data_decoded)

    source_data = pa.table(data_to_ingest.model_dump())
    if DeltaTable.is_deltatable(GCS_PATH):
        dt = DeltaTable(GCS_PATH)

        (
            dt.merge(
                source=source_data,
                predicate="target.id = source.id",
                source_alias="source",
                target_alias="target",
                merge_schema=True,
            )
            .when_matched_update_all(except_cols=["id"])
            .when_not_matched_insert_all()
            .execute()
        )
        logger.info(f"🚀 Event merged in table {GCS_PATH}")

        dt.optimize.compact()
        dt.vacuum(retention_hours=0, enforce_retention_duration=False, dry_run=False)

        logger.info(f"⚙️ Table {GCS_PATH} optimize")
        return {"status": "success", "message_data": data_decoded}

    write_deltalake(GCS_PATH, source_data)
    logger.info(f"✨ Table {GCS_PATH} create")

    return {"status": "success", "message_data": data_decoded}
