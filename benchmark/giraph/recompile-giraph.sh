#!/bin/bash -e

commondir=$(dirname "${BASH_SOURCE[0]}")/../common
source "$commondir"/get-hosts.sh
source "$commondir"/get-dirs.sh

cd "$GIRAPH_DIR"

# -pl specifies what packages to compile (e.g., giraph-examples,giraph-core)
# -Dfindbugs.skip skips "find bugs" stage (saves quite a bit of time)
mvn clean install -Phadoop_1.0 -DskipTests -pl giraph-examples -Dfindbugs.skip

# copy compiled jars to workers
for ((i = 1; i <= ${nodes}; i++)); do
    scp ./giraph-examples/target/*.jar ${name}${i}:$GIRAPH_DIR/giraph-examples/target/ &
    scp ./giraph-core/target/*.jar ${name}${i}:$GIRAPH_DIR/giraph-core/target/ &
done
wait

echo "OK."