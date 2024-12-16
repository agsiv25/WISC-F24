//low corner case
lbi r1, 0
lbi r2, 1
stu r2, r1, 0      // saves r2 to mem[r1 + i], and saves (r1 + i) to r1
ld r2, r1, 0
halt