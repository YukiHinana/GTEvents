.. _event-api:

/events/
=======================

This is the page for all event related APIs

/events/events - ``POST`` Create Events
----------------------------------------
This api allows user to create a new event.

.. NOTE::

    Here, ``title``, ``location``, ``description`` are required. We can discuss this later and change it.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/events/events``

**Returns:** Created event details and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
        "title": "post1",
        "location": "somewhere",
        "description": "example event",
        "eventDate": null,
        "capacity": 50,
        "fee": 0,
        "tagIds": [1, 2]
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
      "message": null,
      "data": {
        "id": 304,
        "title": "example title",
        "location": "somewhere",
        "eventDate": null,
        "eventCreateDate": null,
        "description": "example event",
        "participantNum": 0,
        "capacity": 50,
        "fee": 0,
        "tags": [
          {
            "id": 1,
            "name": "atag"
          },
          {
            "id": 2,
            "name": "anothertag"
          }
        ],
        "author": {
          "id": 252,
          "username": "alice",
          "organizer": true
        }
      }
    }

* Sample Fail Response (When tag does not match)

  .. code-block::

    HTTP Status Code: 400

  .. code-block::

    {
      "data": "Invalid tag"
    }



/events/events/{eventId} - ``PUT`` Edit Events
----------------------------------------
This api allows the user to change an event information.
(example: /events/events/1)

**Full Request Path**
``PUT`` - ``http://3.145.83.83:8080/events/events/{eventId}``

**Require Authorization**

**Returns:** Edit result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
      "title": "example new title",
      "location": "somewhere",
      "description": "example event!!!",
      "eventDate": null,
      "capacity": 50,
      "fee": 0,
      "tagIds": [1, 2]
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
      "message": null,
      "data": {
        "id": 252,
        "title": "example new title",
        "location": "somewhere",
        "eventDate": null,
        "eventCreateDate": null,
        "description": "example event!!!",
        "participantNum": 0,
        "capacity": 33,
        "fee": 10,
        "tags": [
          {
            "id": 1,
            "name": "atag"
          },
          {
            "id": 2,
            "name": "anothertag"
          }
        ],
        "author": {
          "id": 252,
          "username": "alice",
          "organizer": true
        }
      }
    }

* Sample Fail Response (When event does not exist)

  .. code-block::

    HTTP Status Code: 400

  .. code-block::

    {
      "data": "can't find the event"
    }
* Sample Fail Response (When username does not match)

  .. code-block::

    HTTP Status Code: 400

  .. code-block::

    {
      "data": "can't edit the event"
    }
* Sample Fail Response (When tag does not match)

  .. code-block::

    HTTP Status Code: 400

  .. code-block::

    {
      "data": "Invalid tag"
    }

/events/events/{eventId} - ``DELETE``
----------------------------------------
This api allows the user to delete an event information.
(example: /events/events/1)

**Full Request Path**
``DELETE`` - ``http://3.145.83.83:8080/events/events/{eventId}``

**Require Authorization**

**Returns:** Edit result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
      "title": "example new title",
      "location": "somewhere",
      "description": "example event!!!",
      "eventDate": null,
      "capacity": 50,
      "fee": 0,
      "tagIds": [1, 2]
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

   {
     "data": "successfully delete the event"
   }

* Sample Fail Response (When there is no such even exist)

  .. code-block::

      HTTP Status Code: 400

  .. code-block:: json

     {
       "data": "can't find the event"
     }
* Sample Fail Response (When username does not match)

  .. code-block::

       HTTP Status Code: 400

  .. code-block:: json

     {
       "data": "can't delete the event"
     }
/events/find/event-date-between} - ``GET``
----------------------------------------
This api allows the user to find an event information based on dates between.

**Full Request Path**
``DELETE`` - ``http://3.145.83.83:8080/events/find/event-date-between}``

**Returns:** Edit result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
      "title": "example new title",
      "location": "somewhere",
      "description": "example event!!!",
      "eventDate": null,
      "capacity": 50,
      "fee": 0,
      "tagIds": [1, 2]
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

   {
     "data": "successfully delete the event"
   }

* Sample Fail Response (When there is no such even exist)

  .. code-block::

      HTTP Status Code: 400

  .. code-block:: json

     {
       "data": "can't find the event"
     }
/events/find/event-creation-date-between} - ``GET``
----------------------------------------
This api allows the user to find an event information based on events created dates between.

**Full Request Path**
``DELETE`` - ``http://3.145.83.83:8080/events/find/event-creation-date-between?pageNumber={#}&pageSize={#}&startDate={UnixTimestamp#}&endDate={UnixTimestamp}``

**Returns:** Find result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {

    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

   {
   }

* Sample Fail Response (When there is no such even exist)

  .. code-block::

      HTTP Status Code: 400

  .. code-block:: json

     {
     }
/events/{eventId}/file} - ``GET``
----------------------------------------
This api allows the user to get an event key file based on the event ID.

**Full Request Path**
``DELETE`` - ``http://3.145.83.83:8080/events/{eventId}/file}``

**Returns:** Get file ID

**Examples:**

* Sample Request Param

  .. code-block:: json

    {

    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

   {
   }

* Sample Fail Response (When there is no such even exist)

  .. code-block::

      HTTP Status Code: 400

  .. code-block:: json
      {
      }

/events/{eventId} - ``POST`` Save events
----------------------------------------
This api allows the user to save an event.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/events/{eventId}``

**Require Authorization**
**Returns:** Save result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
     "title": "example new title",
      "location": "somewhere",
      "description": "example event!!!",
      "eventDate": null,
      "capacity": 50,
      "fee": 0,
      "tagIds": [1, 2]
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

   {
     "data": "success"
   }

* Sample Fail Response (When there is no such even exist)

  .. code-block::

      HTTP Status Code: 400

  .. code-block:: json

     {
      "data": "can't find this event"
     }
/created - ``GET`` create events
----------------------------------------
This api allows the user to get a created event.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/events/created``

**Require Authorization**
**Returns:** Save result message and http status code.

/saved - ``GET`` Save events
----------------------------------------
This api allows the user to get a saved event.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/events/saved``

**Require Authorization**
**Returns:** Save result message and http status code.

/events/{eventId}/tags - ``POST``
----------------------------------------
This api allows the user to get tags by event

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/events/{eventId}/tags``

**Require Authorization**
**Returns:** Save result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
     "id": 52
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

   {
     "data": {
            "tags": [52]
              }
   }

* Sample Fail Response (When there is no such even exist)

  .. code-block::

      HTTP Status Code: 400

  .. code-block:: json

     {
      "data": "can't find the event"
     }

