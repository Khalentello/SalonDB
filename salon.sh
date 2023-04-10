#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")


MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "How may I help you?" 
  echo "$SERVICES" | while read service_ID BAR name
  do
    echo "$service_ID) $name"
  done
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]
    then
      # send to main menu
      MAIN_MENU "That is not a valid service number."
    else
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'";)
    echo -e "\nWhat is your phone number"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'";)
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "What's your name?"
      read CUSTOMER_NAME
      CREATE_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'";)
    echo -e '\nWhen you want your service?'
    read SERVICE_TIME
    CREATE_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id, time, customer_id) VALUES ($SERVICE_ID_SELECTED, '$SERVICE_TIME', $CUSTOMER_ID )")
    echo 'I have put you down for a '$SERVICE_NAME' at '$SERVICE_TIME', '$CUSTOMER_NAME'.'
  fi
}

MAIN_MENU