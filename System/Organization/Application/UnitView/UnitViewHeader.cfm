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
<cf_DialogOrganization>

<cfparam name="url.scope" default="backoffice">
<cfparam name="url.systemfunctionid" default="">

<script LANGUAGE = "JavaScript">

	function reload() { 
		   opener.location.reload();
		   window.close();
	}

</script>

<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Organization
	WHERE  OrgUnit = '#URL.ID#'
</cfquery>

<cfinvoke component="Service.Access" 
      method="org"  
	  orgunit="#URL.ID#" 
	  returnvariable="access">	
		  
<cfquery name="Root" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Organization
	WHERE  OrgUnitCode = '#Org.HierarchyRootUnit#'
	  AND  Mission   = '#Org.Mission#'
	  AND  MandateNo = '#Org.MandateNo#'
</cfquery>

<table width="100%">

  <tr class="noprint">
  
    <td height="40" style="height:45px;font-size:25px;padding-left:4px" class="labelmedium fixlength">
	<cfoutput>
	#Org.OrgUnitName#
	</cfoutput>
    </td>
	
	<td align="right" bgcolor="ffffff" style="height:34;padding-right:10px">	
		
	    <cfif access eq "EDIT" or access eq "ALL">
		
			<cfoutput>
			
				<button name="Edit" id="Edit" style="height:25;width:150px" class="button10g" type="button" onClick="editOrgUnit('#URL.ID#')">
					<cf_tl id="Settings">
	    		</button>
	   
		    </cfoutput>		
					
		</cfif>
		
		
	</td>
  </tr> 	
 
  <tr><td colspan="2" style="padding-left:5px;padding-right:5px">
  
  	<table width="100%"><tr><td style="border:1px solid silver">
  
    <table width="100%" align="center">
	 		 
	 <tr>
	 <td valign="top">
		 
		 <table width="100%" class="formpadding">
		
			 <cfoutput query="Org"> 		 
							  		
		     <tr style="height:20px" class="fixlengthlist">
		        <td bgcolor="E6E6E6" style="padding-left:5px;width:15%" class="labelit"><cf_tl id="Name"></td>
				<cfif URL.scope eq "Portal">
		        	<td  style="padding-left:5px;font-size:14px" class="labelit">#OrgUnitName# (#OrgUnitCode#)</td>
				<cfelse>
					<td  style="padding-left:5px;font-size:14px" title="#OrgUnitName#" class="labelit"><a href="javascript:editOrgUnit('#URL.ID#')">#OrgUnitName# <cfif OrgUnitNameShort neq "">[#OrgUnitNameShort#]</cfif></a></td>
				</cfif>
		     </tr>
					  		
			 <tr style="height:20px">
		        <td bgcolor="E6E6E6"  style="width:10%;padding-left:5px;" class="labelit"><cf_tl id="Part of"></td>
		        <td>
				
					<table cellspacing="0" cellpadding="0">
					<tr class="fixlengthlist">
					<td style="padding-left:5px;font-size:14px" class="labelit">#Root.OrgUnitName#</td>
					 <cfif URL.scope neq "Portal">
				          <td  style="padding-left:5px;font-size:14px" class="labelit">&nbsp;#Mission# [#MandateNo#]</td>
			      	</cfif>
					</tr>
					</table>
							
				</td>
		     </tr>
				  
		  </table>
		  
	  </td>
		  
	  <td valign="top" style="height:100%">
		  
			 <cfif URL.scope neq "Portal">
			 
			 <table height="100%" width="100%" class="formpadding">			 
				
			    <tr class="fixlengthlist">
		        	<td bgcolor="E6E6E6" style="padding-left:5px;" class="labelit"><cf_tl id="Effective"></td>
		        	<td class="labelit"  style="padding-left:5px;font-size:14px">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
		      	</tr>
			  
			    <tr class="fixlengthlist">
		        	<td bgcolor="E6E6E6" style="padding-left:5px;" class="labelit"><cf_tl id="Expiration"></td>
		        	<td class="labelit" style="padding-left:5px;font-size:14px">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>
		      	</tr>		  
	      	</table>
		  	</cfif>	  

	  </td>
	  
	  </cfoutput> 
	  	  
	  </tr>
	  
	 
	  	 					
    </table>
	
	</td></tr>
	
	 <tr><td style="height:10px"></td></tr>
	
	</table>
	
    </td>
  </tr>
  
   <cfif URL.scope neq "Portal">
	  <tr><td colspan="2" class="linedotted"></td></tr>
	  </cfif>
</table>
