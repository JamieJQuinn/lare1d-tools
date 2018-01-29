#!/usr/bin/env bash
ls /nas/1101974q/kink_instability/mid-res/v-*/Data/*.sdf | sed -e 's/ /\\n/g' >> filename_list
