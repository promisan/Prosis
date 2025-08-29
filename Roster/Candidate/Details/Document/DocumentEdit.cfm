<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="URL.entryScope" default="">

<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cf_CalendarScript>

<!--- Query returning search results --->
<cfquery name="Parameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM Parameter
</cfquery>

<cfquery name="Document" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ApplicantDocument S, 
	       Employee.dbo.Ref_DocumentType R
	WHERE  S.DocumentType = R.DocumentType
	AND    PersonNo   = '#URL.ID#'
	AND    DocumentId = '#URL.ID1#'
</cfquery>

<cfoutput>

<script>
	
	function formpurge() {		
	
	    _cf_loadingtexthtml='';
		Prosis.busy('yes')
		ptoken.navigate('DocumentEditSubmit.cfm?action=delete&owner=#url.owner#&entryScope=#URL.entryScope#&section=#url.section#&ApplicantNo=#URL.ApplicantNo#','process','','','POST','documentedit')	 		 
		
	}		
	
	function formvalidate(action) {    
				
		document.documentedit.onsubmit() 
			
		if (_CF_error_messages.length == 0 ) {       
			_cf_loadingtexthtml='';	
			Prosis.busy('yes')			
			ptoken.navigate('DocumentEditSubmit.cfm?action=edit&owner=#url.owner#&entryScope=#URL.entryScope#&section=#url.section#&ApplicantNo=#URL.ApplicantNo#','process','','','POST','documentedit')
		 } 	 
	}		

</script>

</cfoutput>

<cfform onsubmit="return false" name="documentedit">

<table><tr><td height="1"></td></tr></table>	

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
 
  <tr><td>

	<cfoutput query = "Document">
	
	<input type="hidden" name="PersonNo"   value="#PersonNo#"   class="regular">
	<input type="hidden" name="DocumentId" value="#DocumentId#" class="regular">
	
		<table width="93%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		  <tr>
		    <td style="padding-left:10px;font-size:30px;height:60px;padding-top:10px" width="100%" height="21" align="left" valign="middle" class="labellarge" >
			   	<cf_tl id="Amend issued document"></b>
			 </td>
		  </tr> 	
		       
		  <tr>
		    <td width="100%" class="header" style="padding-left:20px">
		    <table  width="100%" border="0" cellpadding="0" cellspacing="0" class="formpadding formspacing">
				
			<tr><td height="2" colspan="1" class="header"></td></tr>
			
			<TR>
		    <TD width="10%" class="labelmedium"><cf_tl id="Document type">:<cf_space spaces="50"></TD>
		    <TD width="90%">
			<INPUT type="text" class="regularxl enterastab"  value="#Document.DocumentType#" name="Documenttype" maxLength="20" size="20" readonly>		
			</TD>
			</TR>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Document No">:</TD>
		    <TD>
				<INPUT type="text" class="regularxl enterastab" value="#Document.DocumentReference#" name="DocumentReference" maxLength="30" size="30">
			</TD>
			</TR>
			  
		    <TR>
		    <TD class="labelmedium"><cf_tl id="Effective date">:</TD>
		    <TD>
			
				  <cf_intelliCalendarDate9
				FormName="DocumentEdit"
				Tooltip=""
				FieldName="DateEffective" 
				class="regularxl enterastab" 
				DateFormat="#APPLICATION.DateFormat#"
				Default="#Dateformat(Document.DateEffective, CLIENT.DateFormatShow)#">	
			
			</TD>
			</TR>
				
			<TR>
		    <TD class="labelmedium"><cf_tl id="Expiration date">:</TD>
		    <TD>
			
				  <cf_intelliCalendarDate9
				FormName="DocumentEdit"
				Tooltip=""
				FieldName="DateExpiration" 
				class="regularxl enterastab" 
				DateFormat="#APPLICATION.DateFormat#"
				Default="#Dateformat(Document.DateExpiration, CLIENT.DateFormatShow)#">	
				
					
			</TD>
			</TR>
			
			<!---
				
			<TR>
		    <TD class="labelmedium"><cf_tl id="Issued by">:</TD>
		    <TD><cf_textInput
					  form      = "documententry"
					  type      = "ZIP"
					  mode      = "regular"
					  name      = "IssuedPostalCode"
				      value     = "#Document.IssuedPostalCode#"
			          required  = "0"
					  prefix    = ""
					  size      = "2"
					  maxlength = "2"
					  label     = ""
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
			   	<select name="Country" class="regularxl enterastab" >
				<option value=""></option>
			    <cfloop query="Nation" >
				<option value="#Code#" <cfif Document.IssuedCountry eq Code>selected</cfif>>
				#Name#
				</option>
				</cfloop>
			    
		   	</select>		
			</TD>
			</TR>
				
			<TR>
		        <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
		        <TD><textarea style="width:90%;font-size:13px;padding:3px;border-radius:3px" class="regular enterastab" name="Remarks">#Document.Remarks#</textarea></TD>
			</TR>
				
			<tr>
			<td colspan="2" style="padding-left:30px;padding-right:30px">
			
						<cf_filelibraryN
						DocumentPath="#Parameter.DocumentLibrary#"
						SubDirectory="#URL.ID#" 
						Filter="#left(URL.ID1,8)#"
						Insert="yes"
						Remove="yes"
						Listing="yes">
			</td>
			
			</tr>
			
			<tr><td height="1" colspan="2" class="linedotted"></td></tr>
		
			<tr><td align="center" colspan="2">
		   <input type="button"  name="cancel" value="Cancel" class="button10g" onClick="history.back()">
		   
		   <cfif Document.enableRemove eq "1">
		   <cf_tl id="Delete" var="1">
		   <input class="button10g" type="button" name="Delete" value="#lt_text#" onclick="formpurge()">
		   </cfif>
		   <cf_tl id="Submit" var="1">
		   <input class="button10g" type="button" name="Submit" value="#lt_text#" onclick="formvalidate()">
		   </td></tr>
		   
		   <tr><td colspan="2" id="process"></td></tr>
		   </table>
		      
		</cfoutput>
	
	</td>
	</tr>
	
	</table>
	
	</td>
	</tr>
	
	</table>

</CFFORM>
