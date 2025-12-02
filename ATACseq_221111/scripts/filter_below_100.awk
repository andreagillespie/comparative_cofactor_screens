# SIZE is the minimum template length
BEGIN { FS="\t"; SIZE=100; S2=SIZE*SIZE }

# Write the headers 
/^@/ { print $0; next }

# Print only long entries
{ if ($9*$9 < S2) print $0}
