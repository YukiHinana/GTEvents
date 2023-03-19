.. _event-api:

/events/
=======================

This is the page for all event related APIs

/events/create - ``POST``
----------------------------------------
This api allows user to create a new event.

.. NOTE::

    Here, ``title``, ``location``, ``description`` are required. We can discuss this later and change it.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/events/create``

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

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 401

/events/{eventId} - ``PUT``
----------------------------------------
This api allows the user to change an event information.

**Full Request Path**
``PUT`` - ``http://3.145.83.83:8080/events/{eventId}``

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

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 400

  .. code-block::

    {
      PLACEHOLDER
    }

/event/delete - ``DELETE``
----------------------------------------
Delete an event

PLACEHOLDER