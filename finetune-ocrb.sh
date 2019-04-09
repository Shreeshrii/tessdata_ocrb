#!/bin/bash

###rm -rf ./ocrb_eval
###~/tesseract/src/training/tesstrain.sh \
###  --fonts_dir ~/.fonts \
###  --lang eng --linedata_only \
###  --noextract_font_properties \
###  --langdata_dir ~/langdata \
###  --tessdata_dir ~/tessdata_best \
###  --exposures "-1 0 1 2" \
###  --save_box_tiff \
###  --fontlist "Arial Unicode MS" "OCRB" "OCR B MT" "OCR-B 10 BT" \
###  --training_text ./eng.MRZ.eval.training_text \
###  --workspace_dir ~/tmp \
###  --output_dir ./ocrb_eval

###rm -rf ./ocrb
###~/tesseract/src/training/tesstrain.sh \
###  --fonts_dir ~/.fonts \
###  --lang eng --linedata_only \
###  --noextract_font_properties \
###  --langdata_dir ~/langdata \
###  --tessdata_dir ~/tessdata_best \
###  --exposures "-1 0 1 2" \
###  --save_box_tiff \
###  --fontlist "Arial Unicode MS" "OCRB" "OCR B MT" "OCR-B 10 BT" \
###  --training_text ./eng.MRZ.training_text \
###  --workspace_dir ~/tmp \
###  --output_dir ./ocrb
###
###echo "/n ****** Finetune plus tessdata_best/eng model ***********"
###
###rm -rf  ./ocrb_from_eng
###mkdir  ./ocrb_from_eng
###
###combine_tessdata -e ~/tessdata_best/eng.traineddata \
###  ~/tessdata_best/eng.lstm
  
lstmtraining \
  --model_output ./ocrb_from_eng/ocrb_plus \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ~/tessdata_best/eng.lstm \
  --old_traineddata ~/tessdata_best/eng.traineddata \
  --train_listfile ./ocrb/eng.training_files.txt \
  --eval_listfile ./ocrb_eval/eng.training_files.txt \
  --debug_interval -1 \
  --max_iterations 3600
  
  lstmtraining \
--stop_training \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ./ocrb_from_eng/ocrb_plus_checkpoint \
  --model_output ./ocrb_from_eng/ocrb.traineddata
  
cp ./ocrb_from_eng/ocrb.traineddata ./
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --model ./ocrb_from_eng/ocrb.traineddata \
  --eval_listfile  ./ocrb_eval/eng.training_files.txt 
  
  lstmtraining \
--stop_training \
  --convert_to_int \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ./ocrb_from_eng/ocrb_plus_checkpoint \
  --model_output ./ocrb_from_eng/ocrb_int.traineddata
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --model ./ocrb_from_eng/ocrb_int.traineddata \
  --eval_listfile ./ocrb_eval/eng.training_files.txt 

cp ./ocrb_from_eng/ocrb_int.traineddata ./

echo "/n ****** Replace top layer in tessdata_best/eng model ***********"

###rm -rf  ./ocrb_layer
###mkdir  ./ocrb_layer

lstmtraining \
  --model_output ./ocrb_layer/ocrb_layer \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ~/tessdata_best/eng.lstm \
  --append_index 5 --net_spec '[Lfx128 O1c1]' \
  --train_listfile ./ocrb/eng.training_files.txt \
  --eval_listfile ./ocrb_eval/eng.training_files.txt  \
  --debug_interval -1 \
  --max_iterations 20000
  
  lstmtraining \
--stop_training \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ./ocrb_layer/ocrb_layer_checkpoint \
  --model_output ./ocrb_layer/ocrb_layer.traineddata
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --model ./ocrb_layer/ocrb_layer.traineddata \
  --eval_listfile ./ocrb_eval/eng.training_files.txt 

  lstmtraining \
--stop_training \
--convert_to_int \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ./ocrb_layer/ocrb_layer_checkpoint \
  --model_output ./ocrb_layer/ocrb_layer_int.traineddata
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --model ./ocrb_layer/ocrb_layer_int.traineddata \
  --eval_listfile ./ocrb_eval/eng.training_files.txt 
  
cp ./ocrb_layer/*layer*.traineddata ./
