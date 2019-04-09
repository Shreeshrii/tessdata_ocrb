# tessdata_ocrb
traineddata for MRZ using OCR-B fonts

In response to [this post in tesseract-ocr forum](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/tesseract-ocr/zi79vNsiSkg/UT3JwsNeBQAJ)

Update: April 2019

Retrained to add missing `X`
using 3 fonts at 3 exposures and a larger training text compared to previous version.

Both float/best and integer/fast versions are provided.

* [Download best version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb.traineddata) - 11.1 MB. use with `-l ocrb`
* [Download fast version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb_int.traineddata) - 1.66 MB. use with `-l ocrb-int`.
