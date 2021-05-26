#!/bin/bash
set -x

if [ $# -ne 1 ]; then
    echo $0: usage: Requires argument of Organizational name e.g.   your_dns_domain.com
    exit 1
fi

export org_name=$1
export project_id=$(gcloud config list --format 'value(core.project)')
export org_id=$(gcloud organizations list --format=[no-heading] | grep ${org_name} | awk '{print $2}')
export bigquery_dataset=iam
export bigquery_table=iam_policy

function check_variables () {
    if [  -z "$project_id" ]; then
        printf "ERROR: GCP PROJECT_ID is not set.\n\n"
        printf "To view the current PROJECT_ID config: gcloud config list project \n\n"
        printf "To view available projects: gcloud projects list \n\n"
        printf "To update project config: gcloud config set project PROJECT_ID \n\n"
        exit
    fi
    
    if [  -z "$org_id" ]; then
        printf "ERROR: GCP organization id is not set.\n\n"
        printf "To check if you have Organizational rights: gcloud organizations list\n\n"
        printf "Or $org_name has a typo which would impact the lookup for the Organizational ID\n\n"
        exit
    fi
}

function export_iam_policy () {
    gcloud asset export --organization=${org_id} \
    --bigquery-table=projects/$project_id/datasets/${bigquery_dataset}/tables/${bigquery_table} \
    --output-bigquery-force --content-type=iam-policy
}

check_variables
export_iam_policy
