    #!/bin/bash
    datadir="/data"
    last_sync_file="$datadir/last_synced_block.txt"

    if [[ -z $LAST_SYNC_FILE ]]; then
        echo "env: LAST_SYNC_FILE is empty, set last sync file is: $last_sync_file"
    else
        last_sync_file=$LAST_SYNC_FILE
        echo "Last sync file: $last_sync_file"
    fi

    if [[ -f "$last_sync_file" ]]; then
        last_block=$(cat $last_sync_file)
        echo "::File $last_sync_file exist, start stream from this file, block: $last_block"
        ethereumetl stream -b $BATCH_SIZE -w $MAX_WORKER -o $OUTPUT -l "$last_sync_file" -p $RPC_URL --topic-prefix $TOPIC_PREFIX
    else
        echo "::File $last_sync_file dose not exist, start stream from block $START_BLOCK"
        ethereumetl stream -b $BATCH_SIZE -w $MAX_WORKER -o $OUTPUT -s "$START_BLOCK" -p $RPC_URL -l "$last_sync_file" --topic-prefix $TOPIC_PREFIX
    fi