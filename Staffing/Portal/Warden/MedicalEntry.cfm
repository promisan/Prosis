<!--
    Copyright © 2025 Promisan

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


<cfajaximport tags="cfdiv,cfform">
<cf_calendarscript>

<script>

    function validateform(frm,act) {	
	    	
	    try {			    
			document.getElementById(frm).onsubmit()
		
			if( _CF_error_messages.length == 0 ) {	    
				ColdFusion.navigate('MedicalEntrySubmit.cfm?action='+act+'&code=#URL.code#&listcode=#url.listcode#','medicalsave','','','POST',frm)
			}   
		
		} catch(e) {		
			ColdFusion.navigate('MedicalEntrySubmit.cfm?action='+act+'&code=#URL.code#&listcode=#url.listcode#','medicalsave','','','POST',frm)
		}
	 

	}

</script>

<cfquery name = "qRefTopic" 
	datasource = "AppsEmployee"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT R.Description, RT.ListValue
	FROM Ref_Topic R INNER JOIN Ref_TopicList RT ON RT.Code = R.Code
	WHERE 
	R.Code = '#URL.Code#'
	AND RT.ListCode = '#URL.ListCode#'
</cfquery>

<cfquery name = "qPersonMedical" datasource = "AppsEmployee"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	SELECT R.Description, RT.ListValue, PMA.DateEffective, PMA.DateExpiration
	FROM PersonMedicalStatus PMS INNER JOIN Ref_Topic R ON
		PMS.Topic = R.Code INNER JOIN Ref_TopicList RT ON RT.Code = R.Code AND RT.ListCode = PMS.ListCode 
		INNER JOIN PersonMedicalAction PMA ON PMA.Topic = PMS.Topic AND PMA.ListCode = PMS.ListCode
	WHERE 
	PMS.Topic = '#URL.Code#'
	AND 
	PMS.ListCode = '#URL.ListCode#'
</cfquery>

<cf_screentop height="100%" scroll="Yes" label="Medical condition" banner="yellow" bannerheight="50" layout="webapp"user="No">	
<cfform name = "MedicalForm">

<cfoutput>
<!--- Existing ones --->

<table width="100%" height="100%" border="0" bgcolor="ffffff" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
  
  <tr>
    <td width="100%" valign="top">
    <table width="96%" border="0" cellspacing="0" cellpadding="0" align="center"  rules="rows">
	<tr height="20">
		<td width = "5%">
		</td>
		<td colspan="2" align = "center">
			<b>#qRefTopic.Description#</b>
		</td>
	</tr>
	
	<tr><td></td><td height="20" colspan = "2"><b>History</b></td></tr>	 
				
	<cfif qPersonMedical.recordcount eq 0>
		<tr><td></td><td height="20" align="center" colspan = "2"><i>No records found</i></td></tr>	 
	<cfelse>
		<cfloop query = "qPersonMedical">
			<tr>
				<td>
				</td>
				<td colspan = "2">
					<table width = "100%">
						<tr>
							<td width ="60%">
								#ListValue#
							</td>	
							<td width = "20%">
								#DateFormat(DateEffective,CLIENT.DateFormatShow)#
							</td>
							<td width = "20%">
								<cfif DateExpiration eq "01/01/1900">
									<i>undefined</i>
								<cfelse>
									#DateFormat(DateExpiration,CLIENT.DateFormatShow)#							
								</cfif>	
							</td>
						</tr>	
					</table>	
				</td>
			</tr>	
		</cfloop>
	</cfif>			

	<tr height="10"><td colspan="3" height="10" align="center"></td></tr>			
	<tr height="1"><td colspan="3" height="1" align="center" bgcolor="##808080"></td></tr>		
	<tr height="10"><td colspan="3" height="10" align="center"></td></tr>			

	<tr height="30">
		<td>
		</td>
		<td width = "20%">
			<b>Episode</b>
		</td>
		<td>
			#qRefTopic.ListValue#
			<input type = "hidden" name="Code" value="#URL.Code#">
			<input type = "hidden" name="ListCode" value="#URL.ListCode#">
		</td>
	</tr>

	<tr height="20">
		<td></td>
		<td>
		Date Effective :
		</td>
		<td>
			<cfset def = Dateformat(now(), CLIENT.DateFormatShow)>	 
		    <cf_intelliCalendarDate9
			FieldName="DateEffective" 
			Default="#def#"
			AllowBlank="False"
			class="regular">
		</td>
	</tr>

	<tr height="20">
		<td></td>
		<td>
		Date Expiration :
		</td>
		<td>
			<cfset def = Dateformat(now(), CLIENT.DateFormatShow)>	 
		    <cf_intelliCalendarDate9
			FieldName="DateExpiration" 
			Default = ""
			AllowBlank="True"
			class="regular">
		</td>
	</tr>
	

	<tr height="20">
		<td></td>
		<td>
		Remarks :
		</td>
		<td>
		<textarea name="Remarks" class="regular" style="height:70;width: 100%;"></textarea>
		</td>
	</tr>
	
	<tr height="10"><td colspan="3" height="10" align="center"></td></tr>			
	<tr height="1"><td colspan="3" height="1" align="center" bgcolor="##808080"></td></tr>		
	<tr height="10"><td colspan="3" height="10" align="center"></td></tr>			
	
	<tr height="20">
		<td colspan="3" height="27" align="center">
		<input type="button" 
		name="cancel" 
		value="Close" 
		style="width:100px" 
		class="button10s" 
		onClick="parent.ColdFusion.Window.hide('MDetails')">
						   
		
		
	    <input class="button10s" 
		   type="button" 
		   name="Submit" 
		   onclick="javascript:validateform('MedicalForm','save')"
		   style="width:100px" 
		   value="Save">		
		</td>
	</tr>		

	</table>
</td>
</tr>

<tr class="hide" height="100"><td id="medicalsave" colspan="3"></td></tr>	
							
</table>

</cfoutput>


</cfform>