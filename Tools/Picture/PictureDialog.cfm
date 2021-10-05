 
<table cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	
	<tr class="hide"><td colspan="2" align="center">
	
	 <iframe name="picture"
        id="picture"
        width="100%"
        height="100%"
        frameborder="0"></iframe>
		
	</td></tr>
	
	<cfajaximport>
	
	<tr><td style="padding-left:30px" colspan="2" id="pictureshow">
	    
		<cfset url.scope="view">
				
		<cfinclude template="PictureView.cfm">
	
	</td></tr>

</TABLE>	

<cfoutput>	


	  
<form name   = "attach" 
	action   = "#session.root#/Tools/Picture/PictureSubmit.cfm?path=#URL.path#&dir=#url.dir#&filter=#url.filter#&height=#url.height#&width=#url.width#"
	enctype  = "multipart/form-data"
	method   = "post" 
	target   = "picture"
	onSubmit = "return checkfile()">
	
	<table width="98%" align="center" class="formpadding">
	
	    <tr><td height="12"></td></tr>	
	
		<tr>
		<td colspan="2" align="center">
		<input type="file" name="uploadedfile" id="uploadedfile" style="border:0px solid silver;height:30px;font-size:15px" size="50" accept="image/jpeg" class="regular">
		</td>
		</tr>
		
		<cf_tl id="Upload" var= "1">
			
		<tr><td colspan="2" align="center" style="padding-top:10px">
		<cfif FileExists("#SESSION.rootDocumentPath#\#url.path#\#url.dir#\#URL.filter##url.dir#.jpg")>
			<input class="button10g" style="width:160;height:29px;font-size:14px"  type="submit" name="Delete" id="Delete" value="Remove">
		</cfif>
						
		<input class="button10g" style="width:160;height:29px;font-size:14px" type="submit" name="Upload" id="Upload" value="#lt_text#">
		
		</td></tr>
	</table>

</form>

</cfoutput>