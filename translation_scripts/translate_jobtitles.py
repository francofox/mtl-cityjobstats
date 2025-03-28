# must set the GOOGLE_APPLICATION_CREDENTIALS environment variable to creds with sufficient privileges and install google translate library
# pip install google-cloud-translate==2.0.1

# put project info in input_uri, output_uri, 
# put csv resulting from dim_jobcode.sql query in this directory, called dim_jobcode.csv, run commented code below on it to create tsv
# then upload to gcs bucket and fill out input uri, output uri, project id with requisite data

# import csv
# with open('dim_jobcode.csv', 'r', newline='') as csv_in:
#     csv_contents = csv.reader(csv_in)
#     with open('dim_jobcode.tsv', 'w', newline='') as tsv_out:
#         writer = csv.writer(tsv_out, delimiter="\t")
#         writer.writerows(csv_contents)


from google.cloud import translate

def batch_translate_text(
    input_uri: str = "gs://vdemtl-jobspostul/glossaries/dim_jobcode.tsv",
    output_uri: str = "gs://vdemtl-jobspostul/translated-dim/",
    project_id: str = "vdmtl-jobspostul",
    timeout: int = 180,
) -> translate.TranslateTextResponse:
    """Translates a batch of texts on GCS and stores the result in a GCS location.

    Args:
        input_uri: The input URI of the texts to be translated.
        output_uri: The output URI of the translated texts.
        project_id: The ID of the project that owns the destination bucket.
        timeout: The timeout for this batch translation operation.

    Returns:
        The translated texts.
    """

    client = translate.TranslationServiceClient()

    location = "us-central1"
    # Supported file types: https://cloud.google.com/translate/docs/supported-formats
    gcs_source = {"input_uri": input_uri}

    input_configs_element = {
        "gcs_source": gcs_source,
        "mime_type": "text/plain",  # Can be "text/plain" or "text/html".
    }
    gcs_destination = {"output_uri_prefix": output_uri}
    output_config = {"gcs_destination": gcs_destination}
    parent = f"projects/{project_id}/locations/{location}"

    # Supported language codes: https://cloud.google.com/translate/docs/languages
    operation = client.batch_translate_text(
        request={
            "parent": parent,
            "source_language_code": "fr",
            "target_language_codes": ["en"],  # Up to 10 language codes here.
            "input_configs": [input_configs_element],
            "output_config": output_config,
        }
    )

    print("Waiting for operation to complete...")
    response = operation.result(timeout)

    print(f"Total Characters: {response.total_characters}")
    print(f"Translated Characters: {response.translated_characters}")

    return response

if __name__ == '__main__':
    batch_translate_text()