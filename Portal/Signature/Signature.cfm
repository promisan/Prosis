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
		  
<table width="100%" class="formpadding" style="border:0px solid silver">

    <cfoutput>
		
	<tr>
	<td style="min-width:80px" class="labelit"><cf_tl id="Image" var="1">#trim(lt_text)#:</td>
	<td width="90%">
							
		<table cellspacing="0" cellpadding="0">
		
		<tr>				
			
			
			<td>			
			<input type="file" name="uploadedfile" size="40" accept="image/x-png" class="button10g" style="width:300px;height:24px;font-size:15px;">
			</td>
									
			<td style="padding-left:2px">
			
				<input type="submit" name="Load" value="Load..." class="button10g" style="font-size:15px;height:25px; width:89px; background-color: ButtonFace; color: Black;">
				
				<cfif FileExists("#SESSION.rootDocumentPath#/User/Signature/#account#.png") or FileExists("#SESSION.rootDocumentPath#/User/Signature/#account#.jpg")>
							
				<td style="padding-left:3px;padding-bottom:1px">
				
					<input style="height: 25; width: 155; border: 1px solid silver;font-size:15px;background-color: ButtonFace; color: Black;"
					type="submit" 
					name="Delete" 
					value="Remove Image">		
				</td>		
			
			</cfif>
			
			</td>
			
		</tr>
		
		</table>
		
		
	</td>
	</tr>
	
	<tr><td class="line" colspan="2"></td></tr>
		
	<tr class="hide"><td colspan="2" align="center">
	
		 <iframe name="signaturebox"
		        id="signaturebox"
		        width="100%"
		        height="100%"
		        frameborder="0"></iframe>
		
	</td></tr>
	
	<tr><td colspan="2"><font color="808080"><cf_tl id="Images should be in PNG or JPG format in the size of width 200 * height 80"></font></td></tr>
	
	<tr><td colspan="2">
		<cfdiv id="signatureshow" style="width:450px;border:1px solid silver">
			<cfinclude template="SignatureView.cfm">
		</cfdiv>	
	</td></tr>	
		
	</cfoutput>	

</TABLE>
		
</cfform>


	