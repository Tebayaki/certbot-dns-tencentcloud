#!/bin/sh

if [ -n "$PUID" ] && [ -n "$PGID" ]; then
    echo "Running with PUID=${PUID} and PGID=${PGID}"

    if [ "$(id -u user1)" != "$PUID" ]; then
        echo "Modifying user1 UID from $(id -u user1) to $PUID"
        usermod -o -u "$PUID" user1
    fi

    if [ "$(id -g user1)" != "$PGID" ]; then
        echo "Modifying user1 GID from $(id -g user1) to $PGID"
        groupmod -o -g "$PGID" user1
    fi

    chown -R user1:user1 /app /data

    exec gosu user1 "$@"
else
    echo "Running as root"
    exec "$@"
fi
