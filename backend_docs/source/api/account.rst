.. _account-api:

/account/
=======================

This is the page for all user account related APIs

/account/register - ``POST``
----------------------------------------
This api allows user to create a new account.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/account/register``

**Returns:** Sign up success message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
        "username": "alice",
        "password": "totallysecure"
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
        "data": "Sign up success"
    }

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 400

  .. code-block:: json

    {
        "data": "Username already exists!"
    }

/account/login - ``POST``
----------------------------------------
This api allows user to login to an account

.. NOTE::

    Please make sure you save the token--"data" returned. Set this to the header "Authorization"\\'s value to show that you
    are authenticated.

**Full Request Path**
``POST`` - ``http://3.145.83.83:8080/account/login``

**Returns:** Token and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
        "username": "alice",
        "password": "totallysecure"
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
        "message": null,
        "data": "e4ed4c61-49fe-4e46-948b-ac07103246c1"
    }

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 400

  .. code-block:: json

    {
        "data": "Incorrect username or password"
    }

/account/reset - ``PUT``
----------------------------------------
Request a password reset and perform the reset.

**Full Request Path**
``PUT`` - ``http://3.145.83.83:8080/account/reset``

**Returns:** Reset result message and http status code.

**Examples:**

* Sample Request Param

  .. code-block:: json

    {
        "username": "alice",
        "oldPassword": "totallysecure",
        "newPassword": "totallysecurenew"
    }

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
        "data": "Success"
    }

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 400

  .. code-block:: json

    {
        "data": "The new password cannot be the same as the old one"
    }

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 400

  .. code-block:: json

    {
        "data": "Incorrect username or password"
    }

/account/delete - ``DELETE``
----------------------------------------
Delete a user


**Full Request Path**
``DELETE`` - ``http://3.145.83.83:8080/account/delete``

**Returns:** Delete result message and http status code.

**Examples:**

* Sample Request Param

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
        "data": "Account alice successfully deleted"
    }

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 401

  .. code-block:: json

    {
        "data": "Failed. Account not found."
    }

/logout - ``PUT``
----------------------------------------
logout a user


**Full Request Path**
``PUT`` - ``http://3.145.83.83:8080/logout``

**Returns:** Delete result message and http status code.

**Examples:**

* Sample Request Param

* Sample Success Response

  .. code-block::

    HTTP Status Code: 200

  .. code-block:: json

    {
        "data": "Account logged out"
    }

* Sample Fail Response

  .. code-block::

    HTTP Status Code: 401

  .. code-block:: json

    {
        "data": "Invalid token"
    }