#!/usr/bin/env bash

cd $WARC_DIR
rm path-index.txt

for f in *.warc.gz; do if [[ -f "$f" ]]; then
  # Do something with "$f"
  g=${f/warc\.gz/cdx}
  echo "Generating $g..."
  ${WAYBACK_INSTALL_ROOT}/openwayback/openwayback/bin/cdx-indexer $f $g
  h=${f/WARC_DIR\//}
  echo "$f	$WAYBACK_WARC_PATH$f" >> path-index.txt
fi; done
