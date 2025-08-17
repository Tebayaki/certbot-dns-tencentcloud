#!/bin/sh

if [ -n "$PUID" ] && [ -n "$GUID" ]; then
    echo "Running with PUID=${PUID} and GUID=${GUID}"

    if [ "$(id -u user1)" != "$PUID" ]; then
        echo "Modifying user1 UID from $(id -u user1) to $PUID"
        usermod -o -u "$PUID" user1
    fi

    if [ "$(id -g user1)" != "$GUID" ]; then
        echo "Modifying user1 GID from $(id -g user1) to $GUID"
        groupmod -o -g "$GUID" user1
    fi

    chown -R user1:user1 /app /data

    exec gosu user1 "$@"
else
    echo "Running as root"
    exec "$@"
fi
