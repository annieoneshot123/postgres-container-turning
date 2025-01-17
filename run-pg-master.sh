#!/bin/bash 


# Copyright 2015 Crunchy Data Solutions, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "starting pg-master container..."

# uncomment these lines to override the pg config files with
# your own versions of pg_hba.conf and postgresql.conf
PGCONF=/root/postgres-container/pgconf
sudo chown postgres:postgres $PGCONF
sudo chmod 0700 $PGCONF
sudo chcon -Rt svirt_sandbox_file_t $PGCONF
# add this next line to the docker run to override pg config files

DATA_DIR=/tmp/pg-master-data
sudo rm -rf $DATA_DIR
sudo mkdir -p $DATA_DIR
sudo chown postgres:postgres $DATA_DIR
sudo chcon -Rt svirt_sandbox_file_t $DATA_DIR

sudo docker run \
	-p 12000:5432 \
	-v $DATA_DIR:/pgdata \
	-v $PGCONF:/pgconf \
	-e TEMP_BUFFERS=9MB \
	-e MAX_CONNECTIONS=101 \
	-e SHARED_BUFFERS=129MB \
	-e MAX_WAL_SENDERS=7 \
	-e WORK_MEM=5MB \
	-e PG_MODE=master \
	-e PG_MASTER_USER=masteruser \
	-e PG_MASTER_PASSWORD=masterpsw \
	-e PG_USER=testuser \
	-e PG_ROOT_PASSWORD=rootpsw \
	-e PG_PASSWORD=testpsw \
	-e PG_DATABASE=testdb \
	--name=pg-master \
	--hostname=pg-master \
	-d crunchydata/crunchy-pg:latest

