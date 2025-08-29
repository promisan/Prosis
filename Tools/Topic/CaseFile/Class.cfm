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
<cfparam name="url.scopetable"  default="">
<cfparam name="url.checked"     default="">

<cfif url.scopetable eq "Ref_TopicElementClass">

	<cfset refTable     = "Ref_ElementClass">
	<cfset refField     = "ElementClass">
	
<cfelse>

	<font color="red">Sorry, I am not able to determine the scope of this topic.</font>
	<cfabort>
	
</cfif>


<cfif url.checked neq "">

	<cfif url.checked eq "true">
	
		<cfquery name="Update" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
	    	INSERT INTO #url.scopetable# 
				(Code,
				 #refField#,
				 Created)
			VALUES(
				'#url.topic#',
				'#url.class#',
				getdate()
			)
			
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Delete" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    	DELETE FROM #url.scopetable#
			WHERE  Code       = '#url.topic#'
			AND    #refField# = '#url.class#'
		</cfquery>
		
	</cfif>
	
</cfif>

<cfquery name="Select" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	
	SELECT C.Code, C.Description, C.ClaimType, EC.Code as Selected
	FROM   #refTable# C
	LEFT   JOIN #url.scopetable# EC
		   ON C.Code = EC.#refField# AND EC.Code = '#url.topic#'
	ORDER  BY C.ClaimType, C.ListingOrder

</cfquery>

<cfset columns = 3>
<cfset cont    = 0>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td colspan="#columns#" height="15" align="center"></td></tr>
		
	<cfoutput query="Select" group="ClaimType">
	
	<tr><td colspan="#columns#" height="15" class="labelmediumcl"><b>#ClaimType#</td></tr>
	
		<cfoutput>
		
			<cfif cont eq 0> <tr> </cfif>
			<cfset cont = cont + 1>
			
			<td style="height:20px;padding-left:5px" bgcolor="<cfif selected neq "">ffffbf</cfif>">
			 	<input type="checkbox" value="#code#" <cfif Selected neq "">checked="yes"</cfif> onClick="_cf_loadingtexthtml='';ColdFusion.navigate('#SESSION.root#/Tools/Topic/CaseFile/Class.cfm?scopetable=#url.scopetable#&Topic=#URL.Topic#&class=#code#&checked='+this.checked,'#url.topic#_class')">
			</td>
			<td bgcolor="<cfif selected neq "">ffffbf</cfif>" style="padding-left:5px;font-size:9pt;" class="labelit">#Code# #Description#</td>
					 
			 <cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
	
		</cfoutput>

	</cfoutput>	 
 
	 <tr class="hide">
	 	<td colspan="#columns#" height="25" align="center" class="labelit"><cfif url.checked neq "">  <font color="##0080C0"> Saved! <font/> </cfif>  </td>
	 </tr>
	 
</table>

