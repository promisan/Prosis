 <HTML><HEAD>
    <TITLE>Signature</TITLE>
</HEAD><body bgcolor="ffffff">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<cf_screentop height="100%" html="No" jquery="Yes" Signature="Yes">
<cf_param name="url.account" default="" type="string">

<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">

<script language="JavaScript">
	
	function checkfile() {
		var uController = new systemcontroller();
		document.attach.action = document.attach.action + '&mid='+ uController.GetMid();						   
	}
		
</script>


<table class="formpadding" style="border:0px solid silver">

    <cfoutput>
	
	<tr class="labelmedium2">
	<td colspan="2" style="height:40px;font-size:20px">Upload your signature</td>
	<tr><td colspan="2">
	
	    <CFFORM name      = "attach" 
	    	action    = "../Signature/SignatureSubmit.cfm?account=#account#" 
			method    = "post" 
			target    = "signaturebox" 
			enctype   = "multipart/form-data"
			onSubmit  = "return checkfile();">
		
		<table width="100%">
		
		<tr>
		<!---
		<td style="min-width:80px" class="labelit"><cf_tl id="Image" var="1">#trim(lt_text)#:</td>
		--->
		<td width="100%" colspan="2">
								
			<table class="formpadding" width="100%">
			
			<tr>		
			   		
				<td>			
				<input type="file" name="uploadedfile" accept="image/x-png" class="button10g" style="width:300;height:24px;font-size:15px;">
				</td>									
				
				
			</tr>
			
			</table>
			
		</td>
		</tr>
		
		<tr><td class="line" colspan="2"></td></tr>
		
		<tr>	
		     <td  style="padding-left:2px;width:155px;">
				
				<input type="submit" name="Load" value="Upload" class="button10g"
				   style="font-size:15px;height:25px; width:155px; background-color: ButtonFace; color: Black;">					
				
			</td>	
				
		    <cfif FileExists("#SESSION.rootDocumentPath#/User/Signature/#account#.png") or FileExists("#SESSION.rootDocumentPath#/User/Signature/#account#.jpg")>
							
			<td align="right" style="width:155px;padding-left:3px;padding-bottom:2px;padding-top:3px">
			
				<input style="height: 25; width: 155; border: 1px solid silver;font-size:15px;background-color: ButtonFace; color: Black;"
				type="submit" 
				name="Delete" 
				value="Remove Image">		
			</td>	
			 </cfif>
				
		 </tr>		
	   
		
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
	
		
		</table>
		
		</cfform>
	
	</td></tr>
	
	<tr class="labelmedium2">
	<td style="font-size:20px;height:40px"><b>or</td>
	</tr>
		
	<tr class="labelmedium2">
	<td style="font-size:20px;height:34px">write your signature</td>
	</tr>
	
	<td>
	
		 <CFFORM name      = "write" 
	    	action    = "../Signature/SignatureWrite.cfm?account=#account#" 
			method    = "post">

			 <cfquery name="GetLast"
					 datasource="AppsSystem"
					 username="#SESSION.login#"
					 password="#SESSION.dbpw#">
					 SELECT    *
					 FROM      UserNames
					 WHERE     Account = '#session.acc#'
			 </cfquery>

			 <table width="100%">
			<tr>
				<td colspan="2" style="background-color:f4f4f4;border:1px solid silver;padding:7px" align="center" valign="middle">
					<!--- This is going to generate a field name SignatureContent --->
					<table>
					<tr><td style="border:1px solid silver">
					<CF_UISignatureView class="button10g" buttons="No" width="280" height="90" 
					   style="border:0px;background-color:white" value="#GetLast.Signature#">
					</td></tr></table>
			</td>
			</tr>
			
			<cfif getlast.SignatureModified neq "">
				<tr class="labelmedium2"><td colspan="2">
				The above signature was last update on : #dateformat(GetLast.SignatureModified,client.dateformatshow)#
				</td></tr>
			</cfif>
		
		<tr>						
							
			<td>
					
				<input style="border: 1px solid silver;font-size:15px;background-color: ButtonFace; color: Black;"
				type="submit" 
				onclick="saveSignature()"
				class="button10g"
				name="SaveWrite" 
				value="Submit">		
			</td>		
				
		</tr>
			
		</table>	
		
		</cfform>
		
	</td>
		
	</tr>  
	
	</cfoutput>	

</TABLE>