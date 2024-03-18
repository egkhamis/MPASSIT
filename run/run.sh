#!/bin/bash

RUN_DIR=$(pwd) 

echo $RUN_DIR

mkdir -p $RUN_DIR/monan
mkdir -p $RUN_DIR/logs
#cp /mnt/beegfs/monan/MONAN-scripts/egeon_oper/MONAN/testcase/runs/GFS/2024020100/monanprd/diag.2024-02-11_00.00.00.nc monan/
#cp /mnt/beegfs/monan/MONAN-scripts/egeon_oper/MONAN/testcase/runs/GFS/2024020100/monanprd/diag.2024-02-11_00.00.00.nc monan/history.2024-02-11_00.00.00.nc
#cp /mnt/beegfs/monan/MONAN-scripts/egeon_oper/MONAN/testcase/runs/GFS/2024020100/monanprd/x1.1024002.init.nc monan/
#cp ../../wrfinput_d01 monan/

cat > namelist.input <<EOF
&config 
grid_file_input_grid="$RUN_DIR/monan/x1.1024002.init.nc" 
hist_file_input_grid="$RUN_DIR/monan/history.2024-02-11_00.00.00.nc" 
diag_file_input_grid="$RUN_DIR/monan/diag.2024-02-11_00.00.00.nc" 
file_target_grid="$RUN_DIR/monan/wrfinput_d01" 
output_file="$RUN_DIR/monan/out_hist_diag.nc" 
is_regional = .false.
target_grid_type = 'LAT-LON'
interp_diag=.true.
interp_hist=.true.
esmf_log=.false.
nx = 720
ny = 360
ref_lat = -90.0
ref_lon = 0.0
stand_lon = 0.0
/
EOF

cat > mpassit_exe.sh <<EOF0
#!/bin/bash
#SBATCH --nodes=2
#SBATCH --ntasks=256
#SBATCH --tasks-per-node=128
#SBATCH --partition=batch
#SBATCH --job-name=MPASSIT
#SBATCH --time=00:10:00         
#SBATCH --output=$RUN_DIR/my_job_mpassit.o%j   # File name for standard output
#SBATCH --error=$RUN_DIR/my_job_mpassit.e%j    # File name for standard error output
#SBATCH --mem=500000

export executable=mpassit

cd $RUN_DIR
. $RUN_DIR/load_modules.sh

# generic
ulimit -s unlimited

ldd ./mpassit

echo \$SLURM_JOB_NUM_NODES

echo  "STARTING AT \`date\` "
Start=\`date +%s.%N\`
echo \$Start > $RUN_DIR/Timing

time mpirun -np \$SLURM_NTASKS -env UCX_NET_DEVICES=mlx5_0:1 -genvall ./\${executable} namelist.input

End=\`date +%s.%N\`
echo  "FINISHED AT \`date\` "
echo \$End   >> $RUN_DIR/Timing
echo \$Start \$End | awk '{print \$2 - \$1" sec"}' >> $RUN_DIR/Timing

exit 0

EOF0

chmod +x mpassit_exe.sh

sbatch mpassit_exe.sh

#
# move logs
#

#mv $RUN_DIR/my_job_mpassit.* $RUN_DIR/logs/

exit

