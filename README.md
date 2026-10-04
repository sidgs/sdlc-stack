# SDLC stacks

Local Docker services for development: Redis, Postgres with pgvector, Mailpit, LiteLLM, local S3 (MinIO), and local GCS (`fake-gcs-server`).

## Quick start

```bash
export GEMINI_API_KEY=...       # required for Gemini chat and embeddings
export OPENAI_API_KEY=...       # required for gpt-4o / gpt-4o-mini
export ANTHROPIC_API_KEY=...    # required for Claude Sonnet / Opus
make start
```

`make` with no target prints usage.

| Target | Action |
| --- | --- |
| `make start` | Start the stack (`docker compose -f sdlc-stacks.yaml up -d`) |
| `make stop` | Stop the stack |
| `make restart` | Stop then start |
| `make usage` | Print this target list |

## Services

| Service | Image | Host ports | Notes |
| --- | --- | --- | --- |
| Redis | `redis:latest` | `6379` | LiteLLM router cache |
| pgvector | `pgvector/pgvector:pg16` | `5432` | User `dev`, password `dev`, database `dev`. Data in `./data/pgvector_data` |
| Mailpit | `axllent/mailpit:latest` | SMTP `1025`, UI `8025` | Catch outbound mail at http://localhost:8025 |
| LiteLLM | `ghcr.io/berriai/litellm:main-stable` | `4000` | Proxy UI/API at http://localhost:4000. Config: [`litellm_config.yaml`](litellm_config.yaml) |
| S3 (MinIO) | `minio/minio:latest` | API `9000`, console `9001` | Access key `dev`, secret `12345678`. Data in `./data/s3_data`. Console: http://localhost:9001. Use path-style S3 (`http://localhost:9000`) |
| GCS | `fsouza/fake-gcs-server:latest` | `4443` | Native GCS JSON API emulator (Google has no official GCS emulator). HTTP at http://localhost:4443. Data in `./data/gcs_data`. Clients: `STORAGE_EMULATOR_HOST=http://localhost:4443` |

Compose file: [`sdlc-stacks.yaml`](sdlc-stacks.yaml). Images are multi-arch (`linux/amd64` and `linux/arm64`); Docker pulls the variant for the host CPU. `make start` unsets `DOCKER_DEFAULT_PLATFORM` so a shell export of `linux/amd64` on Apple Silicon does not force an amd64 image that Mailpit may not have locally.

Postgres credentials are applied only on first init. To recreate the database:

```bash
make stop
rm -rf data/pgvector_data
mkdir -p data/pgvector_data
make start
```

## LiteLLM

Master key: `sk-1234` (`Authorization: Bearer sk-1234`).

Provider keys are read from the host environment:

| Key | Purpose | Default | Required |
| --- | --- | --- | --- |
| `GEMINI_API_KEY` | Gemini chat and embeddings | empty | Y (Gemini models) |
| `OPENAI_API_KEY` | OpenAI chat models | empty | Y (gpt-4o models) |
| `ANTHROPIC_API_KEY` | Claude Sonnet and Opus | empty | Y (Claude models) |
| `LITELLM_MASTER_KEY` | Proxy auth (set in compose) | `sk-1234` | Y |
| `LITELLM_SALT_KEY` | Encrypt stored provider keys | `sk-1234` | Y |

Chat models: `default` (Gemini 3.5 Flash), `gpt-4o`, `gpt-4o-mini`, `gemini-2.5-flash`, `gemini-2.5-pro`, `claude-sonnet-5`, `claude-opus-5`.

Embeddings (`gemini-embedding-001`): `embeddings-768`, `embeddings-1536`, `embeddings-3072`.
