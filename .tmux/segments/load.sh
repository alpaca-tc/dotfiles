# Print the average load.

run_segment() {
  # uptime | cut -d "," -f 3- | cut -d ":" -f2 | sed -e "s/^[ \t]*//"
  time=`uptime | cut -d "," -f 3- | cut -d ":" -f2 | sed -e "s/^[ \t]*//"`
  time=$(echo $time | awk -F ' ' '{printf("LA %s%% %s%% %s%%", $1, $2, $3)}')
  echo $time
  exit 0
}
