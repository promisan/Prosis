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
<cf_screentop height="100%" scroll="no" html="No" jquery="Yes">
	
	<cfparam name="URL.Status" default="9">
	
	<cfajaximport tags="cfform">

	<cf_textareascript>
			
	<script>
	
	function sel(id,lan,row) {
	
	  ptoken.navigate('ProfileDetail.cfm?id='+id+'&languagecode='+lan,'profile');
	  se = document.getElementsByName('language');
	  count = 0
	  while (se[count]) {
	      if (row == count) {
			  se[count].checked=true
			  } else {
			  se[count].checked=false
			  }
		  count++
		  }
	}
	
	</script>
	
	<cfquery name="LanguageList" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM Ref_SystemLanguage
		 WHERE Operational IN ('1','2')
	</cfquery> 

<form method="post" name="profileform" id="profileform">

<cf_divscroll>		

	<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td height="10" style="padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
		
	<tr><td height="100%" style="padding:9px">
				
			   <table width="100%" height="100%" class="formpadding">
			   
			   <tr><td height="20">
				   <table cellspacing="0" cellpadding="0" width="100%">
					  <tr>
					  <cfoutput query="LanguageList">
					  <td style="cursor: pointer;" onclick="sel('#url.id#','#code#','#currentrow-1#')" class="labelmedium">
					  
					    <table><tr><td style="padding-left:10px">
					  	     <input type="radio" class="radiol" id="language" name="language"	 
							 value="#Code#" <cfif Code eq CLIENT.LanguageId>checked</cfif>>
							 </td>
							 <td style="padding-left:4px" class="labelmedium">
							 #LanguageName#
							 </td>
							 </tr>
						 </table>
							 
					  </td>	 
					  </cfoutput>
					  <td align="right" width="90%">
					  <cfoutput>
					  
						  <input type="button" 
					         	name="Save" 
							 	style="width:200px;height:25px" 
							 	class="button10g" 
							 	value="Save" 
							 	onclick="updateTextArea();_cf_loadingtexthtml='';ptoken.navigate('ProfileDetail.cfm?id=#url.id#&languagecode='+document.getElementById('lanselect').value,'profile','','','POST','profileform')">
							 
					  </cfoutput>		 
					  </td>
					  <td>&nbsp;</td>
					  </tr>
				   </table>
				   </td>
				</tr>
				
				<cfoutput>
				
				<cfset url.languagecode = CLIENT.LanguageId>	
					
				<tr valign="top">
					<td height="99%" width="100%" style="PADDING-TOP:10PX;padding:5px">
						  <cfdiv bind="url:ProfileDetail.cfm?id=#url.id#&languagecode=#url.languagecode#" id="profile"/>						  
					</td>
				</tr>
				
				</cfoutput>
				 
				</table> 
						
		</td>
		
	</tr>	
		
	</td></tr>
</table>

</cf_divscroll>
</form>



