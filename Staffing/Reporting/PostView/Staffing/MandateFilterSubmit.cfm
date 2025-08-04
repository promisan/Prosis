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

<!--- check if combination exists --->

<cfset Criteria = ''>
<cfset cache = ''>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfparam name="Form.OccGroup"    default="">	
<cfparam name="Form.Category"    default="">	
<cfparam name="Form.PostType"    default="">	
<cfparam name="Form.Class"       default="">	
<cfparam name="Form.Authorised"  default="">	

<cfset fil = "">

<cf_assignId>
<cfset id = RowGuid>
<cfset CLIENT.Filter_ST = "#id#"> 

<cfquery name="Cache" 
	datasource="AppsTransaction">
	    DELETE FROM stCache
		WHERE  DocumentId = '#id#'
</cfquery>
			
<cfquery name="Cache" 
	datasource="AppsTransaction">
	    INSERT INTO stCache	(DocumentId) 
		VALUES ('#id#') 
</cfquery>

<cfif Form.Category IS NOT "" 
    or Form.OccGroup IS NOT ""
	or Form.PostType IS NOT ""
	or Form.Authorised IS NOT ""
	or Form.Class IS NOT "">

    <cfset fil = "1">
	
	<cfif Form.Category IS NOT "">
	
	   <cfloop index="itm" list="#Form.Category#" delimiters=","> 
	  
	   <cfquery name="StoreFilter" 
		datasource="AppsTransaction">
		    INSERT INTO stCacheFilter
			(DocumentId, FilterField, FilterValue)
			VALUES
			('#id#','Cat','#itm#') 
	   </cfquery>
	   
	   </cfloop>
					  
	</cfif>  
	
	<cfparam name="Form.OccGroup" default="">	
	
	<cfif Form.OccGroup IS NOT "">
	
	   <cfloop index="itm" list="#Form.OccGroup#" delimiters=","> 
	
		   <cfquery name="StoreFilter" 
			datasource="AppsTransaction">
			    INSERT INTO stCacheFilter
				(DocumentId, FilterField, FilterValue)
				VALUES
				('#id#','Occ','#itm#') 
		   </cfquery>
	   
	   </cfloop>
	  	  	   
	</cfif> 
	
	<cfparam name="Form.PostType" default="">	
	
	<cfif Form.PostType IS NOT "">
	
	   <cfloop index="itm" list="#Form.PostType#" delimiters=","> 
	
		   <cfquery name="StoreFilter" 
			datasource="AppsTransaction">
			    INSERT INTO stCacheFilter
				(DocumentId, FilterField, FilterValue)
				VALUES
				('#id#','Pte','#itm#') 
		   </cfquery>
	   
	   </cfloop>
	  	  	   
	</cfif> 
	
	<cfparam name="Form.Authorised" default="">	
	
	<cfif Form.Authorised IS NOT "">
	
	   <cfloop index="itm" list="#Form.Authorised#" delimiters=","> 
	
		   <cfquery name="StoreFilter" 
			datasource="AppsTransaction">
			    INSERT INTO stCacheFilter
				(DocumentId, FilterField, FilterValue)
				VALUES
				('#id#','Aut','#itm#') 
		   </cfquery>
	   
	   </cfloop>
	  	  	   
	</cfif> 
	
	<cfparam name="Form.Class" default="">	
	
	<cfif Form.Class IS NOT "">
	
	   <cfloop index="itm" list="#Form.Class#" delimiters=","> 
	
		   <cfquery name="StoreFilter" 
			datasource="AppsTransaction">
			    INSERT INTO stCacheFilter
				(DocumentId, FilterField, FilterValue)
				VALUES
				('#id#','Cls','#itm#') 
		   </cfquery>
	   
	   </cfloop>
	  	  	   
	</cfif> 

</cfif>

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<script language="JavaScript">
 	window.location = "#SESSION.root#/Staffing/Reporting/PostView/Staffing/PostViewLoop.cfm?acc=#SESSION.acc#&Mission=#URL.Mission#&Mandate=#URL.Mandate#&tree=#URL.Tree#&Unit=#URL.Unit#&filterid=#id#&mid=#mid#"
</script>
	
</cfoutput>

