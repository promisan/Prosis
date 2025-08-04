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
<!--- create subset --->

<cfquery name="Fields" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserPivotDetail
		WHERE  ControlId    = '#URL.ControlId#'
		AND    Presentation = 'Details'
		AND    FieldName    = 'Details'  
		ORDER BY ListingOrder 
</cfquery>
 
<cf_droptable 
  dbname="#alias#" 
  tblname="#URL.Table#_summary_detail">		

 <cfquery name="details" 
  datasource="#alias#"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	 SELECT  *  
	 INTO   #URL.Table#_summary_detail   
	 FROM   #URL.Table#_summary T 
	 WHERE 1=1
	 <cfif #URL.af# neq "">
		   AND  T.#URL.af# = '#URL.av#'
	 </cfif>	  
	 <cfif #URL.bf# neq "">
		   AND  T.#URL.bf# = '#URL.bv#'
	 </cfif>
	 <cfif #YValue.FieldValue# neq "">
	 	AND T.#URL.ff# = '#YValue.FieldValue#' 
	 </cfif>
	 <cfif #XValue.FieldValue# neq "">
		AND T.#URL.xf# = '#XValue.FieldValue#'
	 </cfif>
	
	 <cfif #client.pvtFilter# neq "">
	    #preserveSingleQuotes(client.PvtFilter)#
	 </cfif>
	 
	 <cfif #URL.srt# neq "">
	    ORDER BY #URL.srt# 
	 </cfif> 
 </cfquery>
   
  <cfloop query="Fields">
	
	   <cfif currentRow eq "1">
	       <cfset value   = "#FieldValue#">
	   <cfelse>
	       <cfset value   = "#value#,#FieldValue#">
	   </cfif>	
					
 </cfloop>
      
<cfquery name="details" 
   datasource="#alias#"
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT  DetailId,#value# 
	 FROM    #URL.Table#_summary_detail 
</cfquery>
