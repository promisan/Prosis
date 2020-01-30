<cfparam name="url.idmenu" default="">

<script language="JavaScript">

function change_multiple (m) {

    se = document.getElementsByName('bMultiple')   
    cnt = 0

	if (m == 1)	{	
			
		while (se[cnt]) {
		  se[cnt].className = "regular"
		  cnt++
		}			   	
		
	} else {
				
		while (se[cnt]) {
		  se[cnt].className = "hide"
		  cnt++
		}				   
      	
	}
	
	}
	
function showTechDetails(value){
	s = document.getElementById('rdetails');
	if (value>8){
		s.className = 'show';
	}else{
		s.className = 'hide';
	}
}

</script>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray" 
			  label="Attachment Configuration" 
			  option="Maintain Attachment Settings" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfparam name="URL.ID1" default="">

<cfquery name="List" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Attachment
	where  DocumentPathName = '#URL.ID1#'
	
</cfquery>

<cfoutput query="List">

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">
							
	<input type="hidden" name="DocumentPathName" id="DocumentPathName" value="<cfoutput>#DocumentPathName#</cfoutput>">

	<table width="95%" align="center" class="formpadding formspacing" cellspacing="0" cellpadding="0">

			 <tr><td height="4"></td></tr>
	
			 <TR>
				 <TD class="labelit" width="25%">Document path:&nbsp;</TD>  
				 <td class="labelit">
				 	<cfinput type = "Text" 
				   	value        = "#DocumentFileServerRoot#" 
					name         = "DocumentFileServerRoot" 
					required     = "No" 
					size         = "30" 
					maxlength    = "80" 
					class        = "regularxl">	#DocumentPathName#\<br>
				 </td>
			</tr>
			 
			<tr>
				 <td class="labelit" >System module:&nbsp;</td>  
				 <td class="labelit">
				 	<cfquery name="Module" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT SystemModule
						FROM  Ref_SystemModule
					</cfquery>
					<select class="regularxl" name="SystemModule" id="SystemModule">
						<option value=""></option>
				 	<cfloop query="Module">
						<option value="#SystemModule#" <cfif SystemModule eq List.SystemModule>selected</cfif>> #SystemModule# </option>
					</cfloop>
					</select>
				 </td>
			</tr>

			<tr>
			 
				 <td class="labelit">Xythos server:</td>  
				 <td class="labelit">
				 	<cfinput type = "Text" 
				   	value        = "#DocumentServer#" 
					name         = "DocumentServer" 
					required     = "No" 
					size         = "15" 
					maxlength    = "80" 
					class        = "regularxl">	
					
				 </td>
			</tr>
			
			<tr>
			 
				 <td class="labelit">Login:</td>  
				 <td class="labelit">
				 	
					<cfinput type = "Text" 
				   	value        = "#DocumentServerLogin#" 
					name         = "DocumentServerLogin" 
					required     = "No" 
					size         = "15" 
					maxlength    = "80" 
					class        = "regularxl">	
					
					&nbsp;&nbsp; Password: &nbsp;&nbsp;
					<cfinput type = "Password" 
				   	value        = "#DocumentServerPassword#" 
					name         = "DocumentServerPassword" 
					required     = "No" 
					size         = "15" 
					maxlength    = "80" 
					class        = "regularxl">	
				 </td>
			</tr>
			 
			<tr>
				 <td class="labelit">Attach multiple:&nbsp;</td>  
				 <td class="labelit">
				 	<select name="attachmultiple" id="attachmultiple" style="width:70px" class="regularxl" onChange = "javascript:change_multiple(this.value)">
						 <option value="1" <cfif attachmultiple eq 1>selected</cfif>>Enabled</option>
						 <option value="0" <cfif attachmultiple eq 0>selected</cfif>>Disabled</option>
					</select>
				 </td>
			</tr>
			 
			<cfif attachmultiple eq 0>
			 	<cfset vClass="hide">
			<cfelse>	
				<cfset vclass="labelit">
			</cfif>				 
			 
			<tr class="#vClass#" name="bMultiple"> 
				 <td height="25" colspan="2" class="labelit">Attach <b>Multiple</b> Files settings:&nbsp;</td>  
			</tr>	 
			
			<tr class="#vClass#" name="bMultiple">
				<td class="labelit" align="right" width="25%" style="padding-left:2px">Number of files:</td>
				<td align="left">
				 	<select name="AttachMultipleFiles" id="AttachMultipleFiles" class="regularxl" style="width:70px">
						<cfloop index="vSelected" from="1" to="20" step="1">
						 <option value="#vSelected#" <cfif AttachMultipleFiles eq vSelected>selected</cfif>>#vSelected#</option>
						</cfloop> 
					</select>						
				</td>
			</tr>			
				
			<tr class="#vClass#" name="bMultiple">
				<td class="labelit" align="right" width="25%">
					Size per file (MB) : 
				</td>
				<td align="left" >
				 	<select name="AttachMultipleSize" id="AttachMultipleSize" style="width:70px" class="regularxl" onChange="javascript:showTechDetails(this.value);">
					<cfloop index="vSize" from="1" to="25" step="1">
					 <option value="#vSize#" <cfif AttachMultipleSize eq vSize>selected</cfif>>#vSize#</option>
					</cfloop> 
					</select>	
				</td>
			</tr>
			
			<tr>
				<td></td>
				<td class="labelit">
					<a href="http://www.promisan.net/wiki/index.php?title=Big_Files_in_PROSIS_under_IIS" target="_blank" >
						<font color="0080C0">[How to Configure IIS File Size - Click here]</font>
					</a>
				</td>
			</tr>
			
			<tr class="#vClass#" name="bMultiple">
				<td class="labelit" align="right" width="25%">File Extension Filter:				
				</td>
				<td align="left">
				
				<cfinput type = "Text" 
				   	value        = "#AttachExtensionFilter#" 
					name         = "AttachExtensionFilter" 
					required     = "No" 
					size         = "40" 
					maxlength    = "60" 
					class        = "regularxl">	
				 						
				</td>
			</tr>			
					 
			<tr>
				 <td class="labelit">Logging:&nbsp;</td>  
				 <td class="labelit">
				 	<select name="attachlogging" id="attachlogging" class="regularxl" style="width:70px">
						 <option value="1" <cfif attachlogging eq 1>selected</cfif>>Enabled</option>
						 <option value="0" <cfif attachlogging eq 0>selected</cfif>>Disabled</option>
					</select>
				 </td>
			</tr>
			 
			<tr>
				 <td class="labelit">Open Mode:&nbsp;</td>  
				 <td class="labelit">
				 	<select name="attachmodeopen" style="width:90px" class="regularxl">
						 <option value="0" <cfif attachModeOpen eq 0>selected</cfif>>Secure copy</option>
						 <option value="1" <cfif attachModeOpen eq 1>selected</cfif>>Streaming</option>
					</select>
				 </td>
			</tr>
			 
			<tr>
				 <td class="labelit">Memo:&nbsp;</td>  
				 <td class="labelit">
				 	<cfinput type = "Text" 
				   	value        = "#Memo#" 
					name         = "Memo" 
					required     = "No" 
					size         = "50" 
					maxlength    = "80" 
					class        = "regularxl">	
				 </td>
			</tr>
			 			
			<tr><td colspan="2" class="line"></td></tr>
				
			<tr>	
				<td align="center" colspan="2">
					<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
					<input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
				</td>
			</tr>
			
			</cfform>
			
</cfoutput>