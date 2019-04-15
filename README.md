# tessdata_ocrb
traineddata for MRZ using OCR-B fonts

This is a `proof of concept` traineddata 
in response to [this post in tesseract-ocr forum](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!msg/tesseract-ocr/zi79vNsiSkg/UT3JwsNeBQAJ)

Feel free to clone the repo and rerun training with your own custom training_text and fonts.

## Update: April 15, 2019

Retrained to add missing `X`
using 3 OCRB fonts and a [larger training text](eng.MRZ.training_text) compared to previous version.
Both float/best and integer/fast versions are provided.

### Trained by plus finetuning tessdata_best/eng.traineddata 

(800 iterations - 	char train=0.273%, word train=3.47%, word train=0%)

* [Download best version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb.traineddata) - 10.8 MB. use with **`-l ocrb`**.
* [Download fast version](https://github.com/Shreeshrii/tessdata_ocrb/raw/master/ocrb_int.traineddata) - 1.38 MB. use with **`-l ocrb_int`**.

### Evaluation

`ocrb_eval` folder has synthetic MRZ samples in the same 3 fonts for evaluation. The box/tiff pairs are also saved.

* lstmeval of the files with `tessdata_best/eng` gives **Eval Char error rate=44.954738, Word error rate=89.583333**.
* lstmeval of the files with `ocrb` and `ocrb_int` gives **Eval Char error rate=0, Word error rate=0**.

### Test



```
tesseract ./ocrb_eval/eng.OCR-B_10_BT.exp0.tif - -l ocrb --tessdata-dir ./

Failed to load any lstm-specific dictionaries for lang ocrb!!
Page 1

P<EURJOSE<<POLLY<<<<<<<<<<<<<<<<<<<<<<<<<<<<
IDAUT10000999<6<<<<<<<<<<<<<<<
3178087440GBR6502230M1810301<<<<<<<<<<<<<<02
IDCHE123456789C791217C891201CC
L898902C<3UZB6908061F9406236ZE184226B<<<<<14
D231458907WLF7408122F1204159<<<<<<<6
V<KQTPAPANDROPOULOUS<<STEPHEN<TREVOR<<<<<<<<
P<INDVARMA<<NATHU<RAO<GODSE<SHARMA<<<<<<<<<<
P<GUYGLADYS<ALMETA<<<<<<<<<<<<<<<<<
IDEBD<ALEZYZ<BN<MTEB<<<<<<<<<<<<<<<<<<<<<
6754505660GBR6006163M2012296<<<<<<<<<<<<<<08
0504933705ITL7307144F1601013<<<<<<<<<<<<<<06
AA00000000POL6002084F1412314<<<<<<<<<<<<<<<4
7553279419RUS8712242M2104131<<<<<<<<<<<<<<02
P<ROMJOHNSON<<ANNE<QUEEN<<<<<<<<<<<<<<<<<<<<
P<IRNKHOSRAVANI<<MAHBOD<<<<<<<<<<<<<<<<<<<<<
```

# Other projects

There are other github repos with MRZ solutions (I have not tried them).

* https://github.com/konstantint/PassportEye
* https://github.com/Exteris/tesseract-mrz
