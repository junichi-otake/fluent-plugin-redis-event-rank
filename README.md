# fluent-plugin-redis-event-rank

## EventRankOutput

set id and data,
zadd id and score (rank_key's value) as sorted set to redis from fluentd log
    

### message sample

    app.event_id_001.rank {"id":"user_id", "myrank":99, "point1":100, "poit2":20}

### configuration sample

 * host and port for redis server setting.
 * event_id is your application's event id.
 * rank_key is a score for sorted set.
 
    <match app.event_id_001.rank>
      type event_rank
      host 127.0.0.1
      port 30110
      event_id event_id_001
      rank_key myrank
    </match>


##
2013 Junichi Otake

