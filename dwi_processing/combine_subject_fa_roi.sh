# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# this script requires arguments... use the batch_fmri.batch to call this shell script
# example >> combine_subject_gmv.sh '1002,1004,1007,1009,1010,1011,1012,1013,1017,1018,1019,1020,1022,1024,1025,1026,1027,2002,2007,2008,2012,2013,2015,2017,2018,2020,2021,2022,2023,2025,2026,2027,2033,2034,2037,2038,2039,2042,2052,3024,3029,3004,3006,3007,3008,3010,3021,3023,3025,3026,3030,3036' 08_DWI 

argument_counter=0
for this_argument in "$@"; do
	if	[[ $argument_counter == 0 ]]; then
		subjects=$this_argument
	elif [[ $argument_counter == 1 ]]; then
		dwi_processed_folder_name=$this_argument
	fi
	(( argument_counter++ ))
done

Study_dir=/blue/rachaelseidler/share/FromExternal/Research_Projects_UF/CRUNCH/MiM_Data
cd $Study_dir

ml fsl/6.0.3
d=$(date +"%b_%d_%Y")
outfile=${dwi_processed_folder_name}_${d}_dti_roi_fa.csv
if [[ -e ${dwi_processed_folder_name}_${d}_dti_roi_fa.csv ]]; then
	rm ${dwi_processed_folder_name}_${d}_dti_roi_fa.csv
fi

subject_index=0
while IFS=' ' read -ra subject_list; do
    for this_subject in "${subject_list[@]}"; do
       	cd ${Study_dir}/$this_subject/Processed/MRI_files/${dwi_processed_folder_name}
		this_subject_header=$(cat subj_${this_subject}_dti_roi_fa.csv | sed -n 1p)
       	this_subject_data=$(cat subj_${this_subject}_dti_roi_fa.csv | sed -n 2p)
		
		cd ${Study_dir}
       	this_subject_header_outfile=$(cat $outfile | sed 1d)
   		row1=$this_subject_header
		existing_section=$this_subject_header_outfile
		new_row=$this_subject_data
		if [[ subject_index == 0 ]]; then
			echo -e "$row1\n$new_row" >> "$outfile"
		else
			rm $outfile
			echo -e "$row1\n$existing_section\n$new_row" >> "$outfile"
		fi
		(( subject_index++ ))
	done
 done <<< "$subjects"