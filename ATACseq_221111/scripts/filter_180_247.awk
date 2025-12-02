# SIZE is the minimum template length
BEGIN { FS="\t"; MIN=180; S1=MIN*MIN; MAX=247; S2=MAX*MAX }

# Write the headers 
/^@/ { print $0; next }

# Print only long entries
{ if ($9*$9 >= S1 && $9*$9 <= S2) print $0}
