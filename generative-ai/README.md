# Vertex AI Generative AI

## Contents

```text
vertex-ai-examples/
├── generative-ai/
    ├── language/
        ├── document-qa/             - examples for doc Q&A
        ├── document-summarization/  - examples for doc summarization #TODO
        ├── langchain/               - examples for langchain #TODO
        ├── prompt-design/           - examples for prompts #TODO
        ├── reference-architectures/ - examples of architectures #TODO
        └── tuning/                  - examples of tuning models #TODO
```

## Environment Setup

Use a Vertex Workbench Notebook

```sh
gcloud notebooks instances create vertex-ai-examples \
    --vm-image-project=deeplearning-platform-release \
    --vm-image-family=common-cpu-notebooks \
    --machine-type=n1-standard-8 \
    --location=us-east1-b
```

## References

* [GoogleCloudPlatform/generative-ai: Sample code and notebooks for Generative AI on Google Cloud](https://github.com/GoogleCloudPlatform/generative-ai): official Google Cloud Repository
* [statmike/vertex-ai-mlops/Applied GenAI](https://github.com/statmike/vertex-ai-mlops/tree/main/Applied%20GenAI): unoffical repository of Vertex AI MLOps including Applied GenAI examples