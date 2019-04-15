#!/bin/bash

 rm -rf ./ocrb_eval
 ~/tesseract/src/training/tesstrain.sh \
   --fonts_dir ~/.fonts \
   --lang eng --linedata_only \
   --noextract_font_properties \
   --langdata_dir ~/langdata \
   --tessdata_dir ~/tessdata_best \
   --exposures "0" \
   --save_box_tiff \
   --fontlist "OCRB" "OCR B MT" "OCR-B 10 BT" \
   --training_text ./eng.MRZ.eval.training_text \
   --workspace_dir ~/tmp \
   --output_dir ./ocrb_eval
 
 rm -rf ./ocrb
 ~/tesseract/src/training/tesstrain.sh \
   --fonts_dir ~/.fonts \
   --lang eng --linedata_only \
   --noextract_font_properties \
   --langdata_dir ~/langdata \
   --tessdata_dir ~/tessdata_best \
   --exposures "0" \
   --save_box_tiff \
   --fontlist "OCRB" "OCR B MT" "OCR-B 10 BT" \
   --training_text ./eng.MRZ.training_text \
   --workspace_dir ~/tmp \
   --output_dir ./ocrb
 
 echo "/n ****** Finetune plus tessdata_best/eng model ***********"
 
 rm -rf  ./ocrb_plus
 mkdir  ./ocrb_plus
 
 combine_tessdata -e ~/tessdata_best/eng.traineddata \
   ~/tessdata_best/eng.lstm
  
lstmtraining \
  --model_output ./ocrb_plus/ocrb_plus \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ~/tessdata_best/eng.lstm \
  --old_traineddata ~/tessdata_best/eng.traineddata \
  --train_listfile ./ocrb/eng.training_files.txt \
  --debug_interval 0 \
  --max_iterations 800
  
lstmtraining \
--stop_training \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ./ocrb_plus/ocrb_plus_checkpoint \
  --model_output ./ocrb_plus/ocrb.traineddata
  
cp ./ocrb_plus/ocrb.traineddata ./
  
time lstmeval \
  --model ./ocrb_plus/ocrb.traineddata \
  --eval_listfile  ./ocrb_eval/eng.training_files.txt 
  
  lstmtraining \
--stop_training \
  --convert_to_int \
  --traineddata ./ocrb/eng/eng.traineddata \
  --continue_from ./ocrb_plus/ocrb_plus_checkpoint \
  --model_output ./ocrb_plus/ocrb_int.traineddata
  
time lstmeval \
  --model ./ocrb_plus/ocrb_int.traineddata \
  --eval_listfile ./ocrb_eval/eng.training_files.txt 

cp ./ocrb_plus/ocrb_int.traineddata ./


time lstmeval \
  --model ~/tessdata_best/eng.traineddata \
  --eval_listfile ./ocrb_eval/eng.training_files.txt 
  