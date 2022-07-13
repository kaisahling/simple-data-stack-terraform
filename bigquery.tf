resource "google_bigquery_dataset" "data_warehouse" {
  dataset_id  = "data_warehouse"
  description = "Our sample data warehouse"
  location    = var.location
  project     = var.project

  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }

  labels = merge(var.common_labels, {
    "pipeline-step" = "load"
  })
}

resource "google_bigquery_table" "tweets_table" {
  dataset_id = google_bigquery_dataset.data_warehouse.dataset_id
  table_id   = "src_tweets"
  project    = var.project

  external_data_configuration {
    autodetect    = false
    source_format = "NEWLINE_DELIMITED_JSON"
    schema        = <<EOF
                    [
                    {
                        "name": "public_metrics",
                        "type": "RECORD",
                        "mode": "REPEATED",
                        "description": "Publicly available metrics",
                        "fields": [
                                    {
                                        "name": "retweet_count",
                                        "type": "INT64",
                                        "mode": "NULLABLE"
                                    },
                                    {
                                        "name": "reply_count",
                                        "type": "INT64",
                                        "mode": "NULLABLE"
                                    },
                                    {
                                        "name": "like_count",
                                        "type": "INT64",
                                        "mode": "NULLABLE"
                                    },
                                    {
                                        "name": "quote_count",
                                        "type": "INT64",
                                        "mode": "NULLABLE"
                                    }
                        ]
                      },
                      {
                        "name": "context_annotations",
                        "type": "STRING",
                        "mode": "NULLABLE",
                        "description": "Context"
                      },
                      {
                        "name": "referenced_tweets",
                        "type": "RECORD",
                        "mode": "REPEATED",
                        "description": "Tweet that was referenced",
                        "fields": [
                                    {
                                        "name": "type",
                                        "type": "STRING",
                                        "mode": "NULLABLE"
                                    },
                                    {
                                        "name": "id",
                                        "type": "INT64",
                                        "mode": "NULLABLE"
                                    }
                        ]
                      },
                    {
                        "name": "in_reply_to_user_id",
                        "type": "INT64",
                        "mode": "NULLABLE",
                        "description": "User the poster replied to"
                      },
                    {
                        "name": "author_id",
                        "type": "INT64",
                        "mode": "NULLABLE",
                        "description": "Author id"
                      },
                    {
                        "name": "text",
                        "type": "STRING",
                        "mode": "NULLABLE",
                        "description": "The tweet's text"
                      },
                    {
                        "name": "created_at",
                        "type": "TIMESTAMP",
                        "mode": "NULLABLE",
                        "description": "The tweet's timestamp"
                      },
                     {
                        "name": "tweet_id",
                        "type": "INT64",
                        "mode": "NULLABLE",
                        "description": "Tweet id"
                      }
                    ]
                    EOF


    source_uris = [
      "gs://${google_storage_bucket.twitter_data.name}/tweet-*.json",
    ]
  }
}