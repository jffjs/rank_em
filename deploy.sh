#!/bin/bash
set -e

host=rankm.app

./release.sh
scp tmp/rank_em.tar.gz deploy@${host}:

ssh deploy@${host} 'sudo systemctl stop rank_em'
ssh deploy@${host} 'tar xzf rank_em.tar.gz  -C rank_em'
ssh deploy@${host} './rank_em/bin/rank_em eval "RankEm.ReleaseTasks.migrate()"'
ssh deploy@${host} 'sudo systemctl start rank_em'
