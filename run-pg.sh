#!/bin/bash

echo "Starting crunchy-pg container..."

PGCONF=/root/postgres-container/pgconf
DATA_DIR=/tmp/crunchy-pg-data

# Tạo thư mục cho pgconf và pgdata
mkdir -p $PGCONF
mkdir -p $DATA_DIR

# Kiểm tra và cập nhật chủ sở hữu và quyền truy cập cho pgconf và pgdata
chown -R postgres:postgres $PGCONF $DATA_DIR

# Gán nhãn cho pgconf và pgdata
chcon -Rt svirt_sandbox_file_t $PGCONF $DATA_DIR

# Kiểm tra nếu container với tên crunchy-pg đã tồn tại và xóa nếu cần
if [ "$(docker ps -a -q -f name=crunchy-pg)" ]; then
    docker rm -f crunchy-pg
fi

# Khởi chạy container mới
docker run \
    -p 12000:5432 \
    -v $DATA_DIR:/pgdata \
    -v $PGCONF:/pgconf \
    -e TEMP_BUFFERS=9MB \
    -e MAX_CONNECTIONS=101 \
    -e SHARED_BUFFERS=129MB \
    -e MAX_WAL_SENDERS=7 \
    -e WORK_MEM=5MB \
    -e PG_MODE=standalone \
    -e PG_USER=testuser \
    -e PG_PASSWORD=testpsw \
    -e PG_DATABASE=testdb \
    --name=crunchy-pg \
    --hostname=crunchy-pg \
    -d crunchydata/crunchy-pg:latest

echo "crunchy-pg container started."

