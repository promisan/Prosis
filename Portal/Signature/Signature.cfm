 <HTML><HEAD>
    <TITLE>Attach document</TITLE>
</HEAD><body bgcolor="ffffff" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_param name="url.account" default="" type="string">

<cf_getMID>					

<CFFORM name="attach" 
    	action="../Signature/SignatureSubmit.cfm?account=#account#&mid=#mid#" 
		method="post" 
		target="signaturebox" 
		enctype="multipart/form-data">
		  
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

    <cfoutput>
		
	<tr>
	<td width="100" class="labelit"><cf_tl id="Signature Image" var="1">#trim(lt_text)#:</td>
	<td width="90%">
							
		<table cellspacing="0" cellpadding="0">
		
		<tr>
			<td>
			
			<input type="file" class="button10g" style="width:500px;height:32px;font-size:15px;border:0px solid silver" name="uploadedfile" size="40" accept="image/jpeg"></td>
			
			<cfif FileExists("#SESSION.rootDocumentPath#User/Signature/#account#.jpg")>
			
			<td style="padding-left:3px">
				<cf_button width="85px" style="height: 25; width: 85; border: 1px solid silver; padding-top:3px;font-size:13px;background-color: ButtonFace; color: Black;"
				type="submit" name="Delete" value="Remove">		
			</td>		
			
			</cfif>
						
			<td style="padding-left:2px"><input type="submit" name="Load" value="Load..." class="button10g" style="font-size:15px;height: 32; width: 89; border: 1px inset gray; background-color: ButtonFace; color: Black;">
			</td>
			
		</tr>
		
		</table>
		
		
	</td>
	</tr>
	
	<tr><td class="linedotted" colspan="2"></td></tr>
		
	<tr class="hide"><td colspan="2" align="center" height="200">
	
		 <iframe name="signaturebox"
		        id="signaturebox"
		        width="100%"
		        height="100%"
		        frameborder="0"></iframe>
		
	</td></tr>
	
	<tr><td colspan="2"><i><font color="808080"><cf_tl id="Images should be in JPG format in the size of width 200 * height 80"></font></i></td></tr>
	
	<tr><td colspan="2">
		<cfdiv id="signatureshow">
			<cfinclude template="SignatureView.cfm">
		</cfdiv>	
	</td></tr>
		
	</cfoutput>	

</TABLE>
		
</cfform>
	