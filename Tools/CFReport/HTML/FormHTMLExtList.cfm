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
	
 <cfquery name="SystemParam" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Parameter
		</cfquery>
		
<cfset aut_server = "#SystemParam.AuthorizationServer#">	

 <cfquery name="PK" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT * 
  FROM  Ref_ReportControlCriteria
  WHERE ControlId    = '#URL.ControlId#'
  AND   CriteriaName = '#URL.CriteriaName#' 
 </cfquery>
 
 
 <cfquery name="Fields" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM  Ref_ReportControlCriteriaField 
  WHERE ControlId    = '#URL.ControlId#'
  AND   CriteriaName = '#URL.CriteriaName#'
  AND   Operational  = '1' 
  ORDER BY FieldOrder
 </cfquery>
 
 <cfif fields.recordcount lte "1">
 	
	 <table><tr><td class="labelmedium">
	  <font color="FF0000"><cf_tl id ="Problem">, <cf_tl id ="No selection fields"> <cf_tl id ="have been defined">
	     </td></tr>
	 </table>
	 <cfabort>
	 
 </cfif>
  
 <cfloop query="Fields">
 
	 <cfparam name="fldname#currentrow#" default="#FieldName#">
 
 </cfloop>
 
 <cfif URL.init eq "1">
  
	 <!--- Get "factory" --->
	 <CFOBJECT ACTION="CREATE"
		TYPE="JAVA"
		CLASS="coldfusion.server.ServiceFactory"
		NAME="factory">
		<CFSET dsService=factory.getDataSourceService()>
		<CFSET dsNames=dsService.getNames()>
		<cfset ArraySort(dsnames, "textnocase")>
		
	<CFLOOP INDEX="i" FROM="1" TO="#ArrayLen(dsNames)#">
				
		<cfif findNoCase("appsQuery","#dsNames[i]#")>
	
		    <CF_DropTable dbName="#dsNames[i]#" tblName="#SESSION.acc#_crit_#CriteriaName#"> 
		
		</cfif> 
	
	</cfloop>	
  
 </cfif>
 
    
  <cftry> 
   
	 <cfquery name="Table" 
	  datasource="#PK.LookupDataSource#" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT <cfoutput query="Fields">L.#FieldName#,</cfoutput>
	       <cfif PK.LookupFieldDisplay neq "">
		    #PK.LookupFieldDisplay# as Display, 
		   <cfelse>
		    #PK.LookupFieldValue# as Display,	
		   </cfif>	              
            #PK.LookupFieldValue# as PK
	  INTO  userQuery.dbo.#SESSION.acc#_crit_#CriteriaName#
	  FROM  [#Aut_Server#].System.dbo.UserReportCriteria S, 
	  		#PK.LookupTable# L 
	  WHERE S.ReportId        = '#URL.ReportId#' 
	  AND   S.CriteriaName    = '#URL.CriteriaName#' 
	  AND   S.CriteriaValue   = L.#PK.LookupFieldValue# 
	 </cfquery>
		
	    <cfcatch>
		
			<!--- table already exists, so make it empty --->
				
		     <cfif URL.init eq "1">
			 
				 <cfquery name="Values" 
				  datasource="#PK.LookupDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  DELETE FROM userQuery.dbo.#SESSION.acc#_crit_#CriteriaName# 
				 </cfquery>
			
				 <cfquery name="Table" 
				  datasource="#PK.LookupDataSource#" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  INSERT INTO userQuery.dbo.#SESSION.acc#_crit_#CriteriaName# 
				  SELECT <cfoutput query="Fields">#FieldName#,</cfoutput>
				               #PK.LookupFieldDisplay# as Display, 
				               #PK.LookupFieldValue# as PK
				  FROM  [#Aut_Server#].System.dbo.UserReportCriteria S, #PK.LookupTable# L 
				  WHERE S.ReportId = '#URL.ReportId#' 
				  AND   S.CriteriaName = '#URL.CriteriaName#' 
				  AND   S.CriteriaValue = L.#PK.LookupFieldValue# 
				 </cfquery>
				 
				 <cfset CLIENT.extendedInit = "0">
			 			 			 
			 </cfif>
			
		</cfcatch> 
 
 </cftry> 
  
<cfquery name="Values" 
  datasource="#pk.LookupDatasource#" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM userquery.dbo.#SESSION.acc#_crit_#CriteriaName# 
</cfquery>

<cfparam name="URL.width" default="0">

<cfif values.recordcount gt "0">
 <cfset height = "22">
 <cfset col = "ffffff">
 <cfset bor = "1">
<cfelse>
 <cfset height = "20"> 
 <cfset col = "ffffff">
 <cfset bor = "0">
</cfif>

<!---

<cfif Values.recordcount gt "20">

<cf_divscroll>
	
</cfif>
--->
 
<table cellspacing="0" cellpadding="0">
	
	<tr>
	  <td height="<cfoutput>#height#</cfoutput>" class="<cfoutput>#col#</cfoutput>">
	  
	  <table width="100%" cellspacing="0" cellpadding="0">
	  <tr><td style="padding-left:13px;height:35">
	
	   <cfoutput>
	   	   
	       <input 
		   		name="Select" 
				id="Select"
		   		type="button" 
				class="button10g"
		   		onclick="filtermult('#URL.controlid#','#URL.reportid#','#URL.CriteriaName#','#URL.width#','#url.row#')"
				value="Select"				
				iconheight="15px">
		 
	   </cfoutput>
	  </td> 
	  <cfoutput>
      <td align="right" class="labelsmall">

	  <cfif Values.recordcount gte "1">
		
	  <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/delete5.gif" style="cursor:pointer;" height="13" width="13" title="Remove selection" onclick="filterdelete('#URL.controlid#','#URL.reportid#','#URL.CriteriaName#','#URL.width#','#url.row#','')" border="0" align="absmiddle">

	  </cfif>	  
	  </td>
	  </cfoutput>
	  </table>
	  
	  </td>
	</tr>
		 
<cfif Values.recordcount gt "0">

<tr><td>
		
	<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="<cfoutput>#fields.recordcount*2+3#</cfoutput>" class="linedotted"></td></tr>
	<tr>
	    <td>&nbsp;</td> 
	    <td class="labelit" style="padding-left:4px">Description</td> 
		<cfoutput query="Fields">
		<td>&nbsp;</td>
	    <td class="labelit">#FieldDescription#</td>
		</cfoutput>
	    <td width="5%" align="center">
		<!---
		<input type="checkbox" name="selectall" value="" onClick="javascript:selall(this,this.checked)"></td>
		--->
	</tr>
	<tr><td colspan="<cfoutput>#fields.recordcount*2+3#</cfoutput>" class="linedotted"></td></tr>
	
	<cfoutput query="Values">
	<tr>
	    <td align="center" width="40" class="labelit">#currentRow#</td>
	    <td align="left" style="padding-left:4px" width="250" class="labelit">#Display#</td>		
		<cfloop index="No" from="1" to="#Fields.recordcount#">
		    <td>&nbsp;</td>
		    <td class="labelit">
			<cfset val= Evaluate(Evaluate("fldname"&#No#))>#val#</td>
		</cfloop>
		<td align="center">
		    <cf_img icon="delete" onclick="filterdelete('#URL.controlid#','#URL.reportid#','#URL.CriteriaName#','#URL.width#','#url.row#','#pk#')" alt="" border="0">		
		</td>
		
	</tr>
	<cfif CurrentRow neq Recordcount>
	<tr><td colspan="#Fields.recordcount*2+3#" class="linedotted"></td></tr>
	</cfif>
	</cfoutput>	
	</table>

</td></tr>

</table>

</cfif>

<!---
<cfif Values.recordcount gt "20">

</cf_divscroll>
	
</cfif>
--->
