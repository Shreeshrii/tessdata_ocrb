#!/bin/bash

time ~/tesseract/src/training/tesstrain.sh \
  --fonts_dir ~/.fonts/win \
  --lang eng --linedata_only \
  --noextract_font_properties \
  --langdata_dir ~/langdata \
  --tessdata_dir ~/tessdata_best \
  --exposures "-1 0 1" \
  --save_box_tiff \
  --fontlist "OCR B MT" "OCR-B 10 BT" \
  --training_text ./eng.MRZ.training_text \
  --workspace_dir ~/tmp \
  --output_dir ~/tesstutorial/ocrb

# https://github.com/tesseract-ocr/tesseract/wiki/TrainingTesseract-4.00#fine-tuning-for-impact

echo "/n ****** Finetune one of the fully-trained existing models: ***********"

rm -rf  ~/tesstutorial/ocrb_from_full
mkdir  ~/tesstutorial/ocrb_from_full

combine_tessdata -e ~/tessdata_best/eng.traineddata \
  ~/tesstutorial/ocrb_from_full/eng.lstm
  
lstmtraining \
  --model_output ~/tesstutorial/ocrb_from_full/ocrb_plus \
  --traineddata ~/tesstutorial/ocrb/eng/eng.traineddata \
  --continue_from ~/tesstutorial/ocrb_from_full/eng.lstm \
  --old_traineddata ~/tessdata_best/eng.traineddata \
  --train_listfile ~/tesstutorial/ocrb/eng.training_files.txt \
  --debug_interval -1 \
  --max_iterations 600
  
  lstmtraining \
--stop_training \
  --traineddata ~/tesstutorial/ocrb/eng/eng.traineddata \
  --continue_from ~/tesstutorial/ocrb_from_full/ocrb_plus_checkpoint \
  --model_output ~/tesstutorial/ocrb_from_full/ocrb.traineddata
  
  lstmtraining \
--stop_training \
  --convert_to_int \
  --traineddata ~/tesstutorial/ocrb/eng/eng.traineddata \
  --continue_from ~/tesstutorial/ocrb_from_full/ocrb_plus_checkpoint \
  --model_output ~/tesstutorial/ocrb_from_full/ocrb_int.traineddata
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --model ~/tesstutorial/ocrb_from_full/ocrb.traineddata \
  --eval_listfile ~/tesstutorial/ocrb/eng.training_files.txt
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --model ~/tesstutorial/ocrb_from_full/ocrb_int.traineddata \
  --eval_listfile ~/tesstutorial/ocrb/eng.training_files.txt
  
OMP_THREAD_LIMIT=1 time lstmeval \
  --verbosity 0 \
  --model ~/tessdata_best/eng.traineddata \
  --eval_listfile ~/tesstutorial/ocrb/eng.training_files.txt


