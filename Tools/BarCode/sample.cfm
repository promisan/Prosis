<!--- Doctye reviewed by Armin, I will leave it for now as it is not PROSIS related 8/7/2013 --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>ColdFusion Barcode Generator by Andy Brookfield</title>
</head>

<body>
<div align="center"><H1>ColdFusion Barcode Generator</H1></div>
This page is dedicated to a simple ColdFusion temlpate that allows for creation of many of the most common barcodes available in industry today.  Of course it's encrypted, the source is available for a nominal fee, failing that, 
<a href="./Barcodegen.zip">Download it now</a> and use it today.  I'm open to suggestions as to how to make it better so please send me an email with requests to <a href="mailto:andyb@webcaterers.com">andyb@webcaterers.com</a>.<br>Please note that within the ZIP file there are a number if GIF graphic files, please make sure these are available in your ./images directory otherwise you will not see a barcode generated!<br><br><br>
<table>
<tr><td colspan="2">
<div align="center"><H3>Interleaved 2 of 5 Barcode</H3></div>
Interleaved 2 of 5 is a simple 2 of 5 system with a few quirks. The barcode has to contain an even number of digits. This is because with a pair of digits, the first digit is encoded in bars and the second in spaces. There are 2 bar widths, with the wide bars/spaces being between 2 and 3 times the width of the narrow bars/spaces.<br>
This code does not validate the number of characters given to the routine, it expects an even number. If you do not supply an even number, expect errors!
</td></tr>
<tr><td>
<font color="#804000">&lt;CF_BarcodeGenerator<br>
  BarCodeType=</font><font color="Blue">"1"</font><br>
  <font color="#804000">BarCode=</font><font color="Blue">"1234567890"</font><br>
  <font color="#804000">Height=</font><font color="Blue">"70"</font><font color="#804000">&gt;</font>
</td>
<td>
Generates :
<CF_BarCodeGenerator BarCodeType="1" BarCode="1234567890" Height="70">
</td>
</tr>
<tr><td colspan="2">
<div align="center"><h3>Code 2 of 5 Barcode</h3></div>
Code 2 of 5 is a simple 2 of 5 system. There are 2 bar widths, with the wide bars being between 2 and 3 times the width of the narrow bars.  The spacing is fixed at the same dimension of the narrow bar
</td></tr>
<tr><td>
<font color="#804000">&lt;CF_BarcodeGenerator<br>
  BarCodeType=</font><font color="Blue">"2"</font><br>
  <font color="#804000">BarCode=</font><font color="Blue">"1234567890"</font><br>
  <font color="#804000">Height=</font><font color="Blue">"70"</font><font color="#804000">&gt;</font>
</td><td>
Generates :
<CF_BarCodeGenerator BarCodeType="2" BarCode="1234567890" Height="70">
</td></tr>
<tr><td colspan="2"><div align="center"><H3>Code 39 Barcode</H3></div>
A more robust barcode that always starts with a * and ends with a *. Standard characters for this barcode are 0-9 and A-Z although other characters can be made using special control codes ( + / % ) allowing for a combination to create lower case characters and regular symbols ( ! @ $ ^  [ ] ) for example<br>
</td></tr>
<tr><td>
<font color="#804000">&lt;CF_BarcodeGenerator<br>
  BarCodeType=</font><font color="Blue">"3"</font><br>
  <font color="#804000">BarCode=</font><font color="Blue">"1234567890"</font><br>
  <font color="#804000">Height=</font><font color="Blue">"70"</font><font color="#804000">&gt;</font>
</td><td>
Generates :
<CF_BarCodeGenerator BarCodeType="3" BarCode="1234567890" Height="70">
</td></tr>
<tr><td colspan="2">
<div align="center"><H3>USPS PostNet  Barcode</H3></div>
A simple barcode scheme that is binary has binary properties (2 tall bars maximum) with a check bar to make an even number of bars.  The noted exception to this is that 7 is <i>Missing</i>.  because that would require 4 tall bars.  For this reason, 7 is represented by the number 8, 8 by 9 and 9 by 10<br>
</td></tr>
<tr><td>
<font color="#804000">&lt;CF_BarcodeGenerator<br>
  BarCodeType=</font><font color="Blue">"4"</font><br>
  <font color="#804000">BarCode=</font><font color="Blue">"1234567890"</font><br>
  <font color="#804000">&gt;</font>
</td><td>
Generates :
<CF_BarCodeGenerator BarCodeType="4" BarCode="1234567890">
</td></tr>
<tr><td colspan="2">
<div align="center"><H3>Codabar  Barcode</H3></div>
A simple barcode scheme employing 2 widths of bars/spaces.  No check digit is reuired BUT there is a start/stop character that should be in the range of A-D, it is your responbility to supply this within the BarCode variable.
</td></tr>
<tr><td>
<font color="#804000">&lt;CF_BarcodeGenerator<br>
  BarCodeType=</font><font color="Blue">"5"</font><br>
  <font color="#804000">BarCode=</font><font color="Blue">"A1234567890B"</font><br>
  <font color="#804000">&gt;</font>
</td><td>
Generates :
<CF_BarCodeGenerator BarCodeType="5" BarCode="A1234567890B">
</td></tr>

</table>

<div align="center">
This page has been viewed<br><img src="../counter.exe?link=barcodes&style=odometer"> times
</div>
</body>
</html>


