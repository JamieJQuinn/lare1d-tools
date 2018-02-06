#!/usr/bin/env bash
ls /nas/1101974q/kink-instability-str8/v-4r-4-isotropic-mid-res-B1/Data/*.sdf | sed -e 's/ /\\n/g' >> filename_list
