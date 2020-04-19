#!/bin/bash
set -euo pipefail

SHOEBOX_ROOT=$1
YOUR_DOMAIN=$2
PORTS_PREFIX=$3

# PROGET

PACKAGES_SRC=$(dirname "$0")

echo "Setting up ProGet..."
echo "https://inedo.com/proget"
echo

PROGET_ROOT=$SHOEBOX_ROOT/proget
PROGET_SECRETS=$PROGET_ROOT/secrets.ini
PROGET_PACKAGES=$PROGET_ROOT/packages
PROGET_EXTENSIONS=$PROGET_ROOT/extensions
PROGET_CONFIG=$PROGET_ROOT/config
PROGET_POSTGRESQL_DATA=$PROGET_ROOT/postgresql/data
PROGET_HTTP_PORT=${PORTS_PREFIX}80
PROGET_POSTGRESQL_PORT=${PORTS_PREFIX}32

mkdir -p $PROGET_PACKAGES
mkdir -p $PROGET_EXTENSIONS
mkdir -p $PROGET_CONFIG
mkdir -p $PROGET_POSTGRESQL_DATA

if test ! -f "$PROGET_SECRETS"; then
  PROGET_POSTGRESQL_DATABASE=proget
  PROGET_POSTGRESQL_USER=proget
  PROGET_POSTGRESQL_PASSWORD=$(openssl rand 16 -hex)
  echo "PROGET_POSTGRESQL_DATABASE=$PROGET_POSTGRESQL_DATABASE" >> $PROGET_SECRETS
  echo "PROGET_POSTGRESQL_USER=$PROGET_POSTGRESQL_USER" >> $PROGET_SECRETS
  echo "PROGET_POSTGRESQL_PASSWORD=$PROGET_POSTGRESQL_PASSWORD" >> $PROGET_SECRETS
fi

source $PROGET_SECRETS

PACKAGES_ENV=$PACKAGES_SRC/.env
cp $PACKAGES_SRC/env.tmpl $PACKAGES_ENV

sed -i 's|@YOUR_DOMAIN$|'"$YOUR_DOMAIN"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_PACKAGES$|'"$PROGET_PACKAGES"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_EXTENSIONS$|'"$PROGET_EXTENSIONS"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_CONFIG$|'"$PROGET_CONFIG"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_POSTGRESQL_DATA$|'"$PROGET_POSTGRESQL_DATA"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_HTTP_PORT$|'"$PROGET_HTTP_PORT"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_POSTGRESQL_PORT$|'"$PROGET_POSTGRESQL_PORT"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_POSTGRESQL_DATABASE$|'"$PROGET_POSTGRESQL_DATABASE"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_POSTGRESQL_USER$|'"$PROGET_POSTGRESQL_USER"'|g' $PACKAGES_ENV
sed -i 's|@PROGET_POSTGRESQL_PASSWORD$|'"$PROGET_POSTGRESQL_PASSWORD"'|g' $PACKAGES_ENV

echo "Created .env file at '$PACKAGES_SRC'."
echo

echo "ProGet volume mounts:"
echo "PROGET_PACKAGES: $PROGET_PACKAGES"
echo "PROGET_EXTENSIONS: $PROGET_EXTENSIONS"
echo "PROGET_CONFIG: $PROGET_CONFIG"
echo "PROGET_POSTGRESQL_DATA: $PROGET_POSTGRESQL_DATA"
echo
echo "ProGet ports:"
echo "PROGET_HTTP_PORT: $PROGET_HTTP_PORT"
echo "PROGET_POSTGRESQL_PORT: $PROGET_POSTGRESQL_PORT"
echo
echo "ProGet secrets:"
echo "PROGET_POSTGRESQL_DATABASE: $PROGET_POSTGRESQL_DATABASE"
echo "PROGET_POSTGRESQL_USER: $PROGET_POSTGRESQL_USER"
echo "PROGET_POSTGRESQL_PASSWORD: $PROGET_POSTGRESQL_PASSWORD"
echo

echo "Completed ProGet setup."
echo