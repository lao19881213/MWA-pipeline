#!/bin/bash -l

# Trivial example template for the MWA DR workshop

#SBATCH --export=NONE
#SBATCH --account=courses02
#SBATCH --reservation=courseq
#SBATCH --time=00:03:00
#SBATCH --nodes=1
#SBATCH --mem=64gb

module swap PrgEnv-cray PrgEnv-gnu

n=88
animal=oo
m=1

# If we define aprun as a variable, then it's easy to template/redefine to nothing for non-Cray systems
aprun="aprun -n 1 -d 20 -q "

if [[ $n -gt 100 ]]
then
    n=100
    echo "Nice try -- I'm not going to run for numbers greater than 100."
fi

if [[ -e $HOME/trivial_job_result.txt ]]
then
    rm $HOME/trivial_job_result.txt
fi

if [[ "$animal" =~ .onke* ]]
then
    echo "You found the monkey! You win a prize." >> $HOME/trivial_job_result.txt
fi

while [[ $m -lt $n ]]
do
# It's actually pointless to aprun something this easy, but this shows the method
    $aprun echo "$m $animal" >> $HOME/trivial_job_result.txt
    ((m+=1))
done

exit 0
