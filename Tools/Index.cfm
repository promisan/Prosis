<HTML>
<cfif #isDefined("uploadfile")#>
	
	<cfset #curPath# = GetTemplatePath()>
	<cfset #curDirectory# = GetDirectoryFromPath("#curPath#")>
	
	<cf_FileUpload
	directory="#curDirectory#"
	weight="5,3"
	nameofimages="image,image2"
	nameConflict="overwrite"
	accept="image/gif"
	default="na">
	
	<cfoutput>
	<font face="arial" size="2">
	#image#<br>
	#image2#</font><br>
	</cfoutput>
</cfif>
	

<HEAD>
<TITLE>&lt;cf_FileUpload&gt;</TITLE>
</HEAD>

<BODY bgcolor="#ffffff">

<div align="center">
<br>
<form action="Index.cfm?uploadfile=true" enctype="multipart/form-data" method="post">
<table width="450" cellpadding="0" cellspacing="0" class="formpadding">
<tr bgcolor="#cccccc">
	<td colspan="2"><font face="arial" size="3">
	<p><b><i>Tag Syntax-</i></b><br>
	<p><b>&lt;cf_FileUpload</b><br>
	<b>directory="</b>C:\myfiles\<b>"</b><br>
	<b>weight="</b>5,7<b>"</b><br>
	<b>nameofimages="</b>image,image1<b>"</b><br>
	<b>nameConflict="</b>overwrite<b>"</b><br>
	<b>default="</b>na<b>"</b><br>
	<b>accept="</b>image/gif<b>"&gt;</b>
	</font></td>
</tr>
<tr>
	<td colspan="2"><font face="arial" size="2">
	<p><font size="3"><b><i>Overview-</i></b></font><br>
	<p>This tag can handle multiple file uploads and maximum weights for each file.
	Once an uploaded file is detected that exceeds the maximum allowed KB, the file
	is removed and notice to end user is delivered. In addition: the value of the images
	will be returned relative to the name of the input field for insertion into db.
	
	<p><b><i>Notice:</i></b> This tag does not dynamically evaluate the size of a file before
	it uploads it, sorry.
	</td>
</tr>
<tr bgcolor="#cccccc">
	<td colspan="2">
	<font face="arial" size="2">
	<p><font size="3"><b><i>Attributes & Values-</i></b></font><br>
	<p><b>directory:</b> required. Specifies full path to directory that files are to be uploaded to.<br>
	<p><b>weight:</b> required. Comma delimited list of max KB size of files. Single entries allowed. List must
	be relative to "nameofimages" list.<br>
	<p><b>nameofimages:</b> required. Comma delimited list of input names of images. Single entries allowed. List must
	be relative to "weight" list.<br>
	<p><b>nameConflict:</b> optional. See CFFILE's nameconflict values. Default is "overwrite".<br>
	<p><b>default:</b> optional. If image field is blank then this default value will be returned instead of
	image name. Default is "unavailable".<br>
	<p><b>accept:</b> optional. See CFFILE accept values. Default is "text/*, image/*, application/*"
	</font>
	
	</td>
</tr>
<tr>
	<td colspan="3"><font face="arial" size="3">
	<p><b><i>Example application-</i></b><br></font>
	</td>
</tr>
<tr>
	<td><font face="arial" size="2">Select file:</font></td>
	<td><input type="file" name="image" id="image" size="20"></td>
</tr>
<tr>
	<td><font face="arial" size="2">Select file:</font></td>
	<td><input type="file" name="image2" id="image2" size="20"></td>
</tr>
<tr>
	<td colspan="2"><input type="submit" id="submit" value="upload"></td>
</tr>
</table>
</form>

</div>


</BODY>
</HTML>
