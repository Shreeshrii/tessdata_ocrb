# tessdata_ocrb
traineddata for MRZ using OCR-B fonts

In response to [this post in tesseract-ocr forum](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/tesseract-ocr/zi79vNsiSkg/UT3JwsNeBQAJ)

Update: April 11, 2019

Retrained to add missing `X`
using 4 fonts at 4 exposures and a larger training text compared to previous version.
Both float/best and integer/fast versions are provided.

Trained by plus finetuning tessdata_best/eng.traineddata 
(3000 iterations - char train=0%, word train=0%)

* [Download best version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb.traineddata) - 11.1 MB. use with **`-l ocrb`**.
* [Download fast version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb_int.traineddata) - 1.66 MB. use with **`-l ocrb_int`**.

Trained by replacing top layer of network from tessdata_best/eng.traineddata
(14300 iterations - char train=0.005%, word train=0.2%)

* [Download best version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb_layer.traineddata) - 2.11 MB. use with **`-l ocrb_layer`**.
* [Download fast version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb_layer_int.traineddata) - 287 KB. use with **`-l ocrb_layer_int`**.
