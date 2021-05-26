# Exporting assets to BigQuery

This repository contains code and documentation for export IAM policy data to Big Query for further analysis. 

## Before you begin

1. Enable the Cloud Asset API before you can use the gcloud tool to access Cloud Asset Inventory. Note that the API only needs to be enabled on the project you'll be running Cloud Asset API commands from.

2. Install the Cloud SDK on your local client.

3. Create a BigQuery dataset called **iam** under your project.

4. If you're exporting to a BigQuery table in another project, grant the Cloud Asset Inventory agent the following roles.
roles/bigquery.dataEditor
roles/bigquery.user

## Configure an account

To call the Cloud Asset API, you need to configure either a user account or a service account.

### Configuring a user account
1. Log in with your user account using the following command.

    **gcloud auth login USER_ACCOUNT_EMAIL**

2. Grant your user account the cloudasset.viewer Cloud IAM role on the organization whose metadata you want to export. 

    **gcloud organizations add-iam-policy-binding <Your Org ID> --member='user:your_email@your_company.com' --role='roles/cloudasset.viewer'**


## Setting permissions

If you're running the export command on your Cloud Asset Inventory-enabled project, no addition permissions are needed. By enabling the Cloud Asset API on your project a service account, named service-${CONSUMER_PROJECT_NUMBER}@gcp-sa-cloudasset.iam.gserviceaccount.com is automatically granted the permissions for BigQuery export with the Cloud Asset Service Agent role.

If you're exporting a snapshot to a BigQuery table in another project , grant the Cloud Asset Inventory service account of your Cloud Asset Inventory-enabled project the BigQuery Data Editor and BigQuery User roles.

## Exporting an asset snapshot

1. Run script to export IAM policy Organization level
**./export_iam_policy.sh <your_company.com>**

2. Example of export output

    **Export in progress for root asset [organizations/Your_org_id].**

## Querying an asset snapshot
1. Open BigQuery Console

2. Run command to search for users with hotmail or gmail addresses

SELECT name, asset_type, bindings.role
FROM `<project_id_holding_data>.iam.iam_policy`
JOIN UNNEST(iam_policy.bindings) AS bindings
JOIN UNNEST(bindings.members) AS members
WHERE members like "%@hotmail.com" OR members like "%@gmail.com"


##External Documentation
[Exporting to BigQuery](https://cloud.google.com/asset-inventory/docs/exporting-to-bigquery)
