
	
<table class="fileupload" style="width:500px">
	<tr>
		<td>
		</td>
	</tr>
	<tr>
		<td>
			<cfoutput>
			<form name="attach" action="Widgets/FileShelf/FileUploadSubmit.cfm?account=#SESSION.acc#" method="post" target="filebox" enctype="multipart/form-data">
			<table width="100%">
				<tr>
					<td style="padding-left:15px; font-family:tahoma; font-size:15px; padding-top:20px" align="left">
						<cf_tl id="Upload File" class="message">:*
						<input type="file" name="UploadedFile" id="UploadedFile" size="20" accept="image/jpeg" style="border:1px solid silver; background-color:white">
						<input type="submit" name="Load" id="Load" value="Load..." class="photoupload">
					</td>
				</tr>

			</table>
			</form>
			</cfoutput>
		</td>
	</tr>
	
	<tr>
		<td style="height:1px; border-top:1px dotted silver; color:green; font-family:calibri" id="fileuploadsuccess" align="center">
		</td>
	</tr>

	<tr class="hide">
		<td align="center" height="50px">	
			<iframe name="filebox"
				id="filebox"
				width="100%"
				height="100%"
				frameborder="0">
			</iframe>	
		</td>
	</tr>
	
	<tr>
		<td style="font-family:tahoma; font-size:14px; color:#808080" align="center">
			<i>
			<cf_tl id="Each file you upload cannot exceed 10MB in size" class="message">
			<!---<br>
			<cf_tl id="Valid file types:" class="message">ppt, pptx, doc, docx, xls, xlsx, pdf, jpg, png--->
			</i>
		</td>
	</tr>
	
	<tr>
		<td style="height:1px; border-top:1px dotted silver">
		</td>
	</tr>
	
	<tr>
		<td align="center">
			<input class="photoupload" type="button" value="Close" onclick="filedialogclose()"> 
		</td>
	</tr>
	
</table>
