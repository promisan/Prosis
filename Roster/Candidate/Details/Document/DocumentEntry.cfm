
<cf_param name="URL.entryScope" 	 default="backoffice" type="string">
<cf_param name="URL.DocumentType" 	 default="" 		  type="string">
<cf_param name="URL.ID" 	 		 default="" 		  type="string">
<cf_param name="URL.section" 		 default="" 		  type="string">
<cf_param name="URL.applicantno"	 default="" 		  type="string">
<cf_param name="URL.owner" 	 		 default="" 		  type="string">
<cf_param name="URL.personno" 		 default="" 		  type="string">

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfoutput>
<script>

function formvalidate() {
		
	document.documententry.onsubmit() 
		
	if (_CF_error_messages.length == 0 ) {       
		_cf_loadingtexthtml='';	
		ptoken.navigate('DocumentEntrySubmit.cfm?entryScope=#URL.entryScope#&ApplicantNo=#URL.ApplicantNo#&Owner=#URL.Owner#&Section=#URL.Section#','process','','','POST','documententry')
	 } 
	 
}	 
	
function editthis(persno, no) {	    
		ptoken.location("DocumentEdit.cfm?entryscope=#url.entryscope#&Section=#URL.Section#&ApplicantNo=#URL.ApplicantNo#&owner=#url.owner#&ID=" + persno + "&ID1=" + no)		
}

</script>

</cfoutput>

<cf_CalendarScript>

<cfquery name="DocumentType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  * 
    FROM    Ref_DocumentType
    WHERE   DocumentUsage in ('2','3')
    ORDER BY Description
</cfquery>

<cf_assignId>

<cfform onsubmit="return false" name="documententry">
  
<table width="96%" align="center" border="0" cellspacing="0" cellpadding="0">
    
	<tr><td style="padding:10px">
  
		<cfoutput>
		<input type="hidden" name="PersonNo"   value="#URL.ID#">
		<input type="hidden" name="DocumentId" value="#rowguid#">
		</cfoutput>

		<table width="93%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
		    <td width="100%" align="left" class="labellarge" style="font-size:28px;height:52px;padding-top:10px">
				<cf_tl id="Register a document">
		    </td>
		  </tr> 	
		  
		 <tr><td class="linedotted"></td></tr>
		 
		  <tr>
		    <td>
		    <table width="98%" align="center" border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding formspacing">
		
		    <tr><td height="5"></td></tr>				
			<TR>
		    <td class="labelmedium"><cf_tl id="Document type">:<cf_space spaces="40"></td>
		    <td width="80%" class="label">
			  	<select name="documenttype" size="1" class="regularxl enterastab">
					<cfoutput query="DocumentType">
						<option value="#DocumentType#" <cfif DocumentType eq URL.DocumentType>selected</cfif>>#Description#</option>
					</cfoutput>
			    </select>
			</td>
			</TR>
			
			<TR>
		    <TD class="labelmedium">
			<table cellspacing="0" cellpadding="0">
			<tr><td class="labelmedium"><cf_tl id="Document No">:</td>
			<td>
			<cf_securediv bind="url:getDocumentReference.cfm?doctype={documenttype}" id="ref">
			</td>
			</tr></table>
			
			</TD>
		    <TD>
						
				<cfinput type="Text" 
			     name="DocumentReference" 					 				 				
				 size="30" 
				 maxlength="30" 
				 class="regularxl enterastab" >
				
			  
			</TD>
			</TR>
						
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
		    <TD>	
				<cf_intelliCalendarDate9
				FieldName="DateEffective" 
				class="regularxl enterastab"
				Tooltip="" 
				DateFormat="#APPLICATION.DateFormat#"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False"
				Message="Enter a document effective date">	
					
			</TD>
			</TR>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
		    <TD>	
				<cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					DateFormat="#APPLICATION.DateFormat#"
					Default=""
					Tooltip=""
					class="regularxl enterastab" 
					AllowBlank="True">				
			</TD>
			</TR>					
						
			<!---
			<TR>
		    <TD class="labelmedium"><cf_tl id="Issued by">:</TD>
		    <TD><cf_textInput
					  form      = "documententry"
					  type      = "ZIP"
					  mode      = "regularh"
					  name      = "IssuedPostalCode"
				      value     = ""
			          required  = "0"
					  prefix    = ""
					  size      = "2"
					  maxlength = "2"
					  label     = "&nbsp;"
					  style     = "text-align: center;">
				  	
		    </TD>
			</TR>
			
			--->
						
			<cfquery name="Nation" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_Nation
			</cfquery>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Country">:</TD>
		    <TD>
			   	<select name="country" style="font:10px" class="regularxl enterastab" >
					<option value=""><cf_tl id="n/a"></option>
			    	<cfoutput query="Nation">
					<option value="#Code#">#Name#</option>
					</cfoutput>
			   	</select>		
			</TD>
			</TR>
				   
			<tr>
		        <td class="labelmedium"><cf_tl id="Remarks">:</td>
		        <td><textarea class="regular" style="font-size:13px;padding:4px;height:40px;width:90%" name="Remarks"></textarea> </TD>
			</tr>
														
			<cf_filelibraryscript mode="standard">
												
			<tr>
				<td class="labelmedium"><cf_tl id="Attachment">:</td>
				<td><cf_securediv bind="url:DocumentEntryAttachment.cfm?personno=#url.id#&id=#rowguid#&doctype={documenttype}" id="att"></td>			
			</tr>	
									
			<tr><td height="1" colspan="2" class="line"></td></tr>
		
			<tr><td align="center" colspan="2">
			
			<cfif url.entryscope eq "validation">
			
			<cfoutput>
				<cf_tl id="Close" var="1">
		   	   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="parent.window.close()">
		   		<cf_tl id="Reset" var="1">
			   <input class="button10g" type="reset"  name="Reset" value="#lt_text#">
		   		<cf_tl id="Save" var="1">   
			   <input class="button10g" type="button" name="Submit" value="#lt_text#" onclick="formvalidate()">
			</cfoutput>	  
			
			<cfelse>
			
			<cfoutput>
				<cf_tl id="Cancel" var="1">
		   	   <input type="button" name="cancel" value="#lt_text#" class="button10g" onClick="history.back()">
		   		<cf_tl id="Reset" var="1">
			   <input class="button10g" type="reset"  name="Reset" value="#lt_text#">
		   		<cf_tl id="Save" var="1">   
			   <input class="button10g" type="button" name="Submit" value="#lt_text#" onclick="formvalidate()">
			</cfoutput>	  
			
			</cfif>
			 
		   </td>
		   
		   </tr>
		   
		   <tr><td height="1" colspan="2" id="process"></td></tr>
		  	  
		   </table>
		  </td>
		  </tr> 
		   
		</table>
		
</td></tr>

</table>

 </CFFORM>
