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
