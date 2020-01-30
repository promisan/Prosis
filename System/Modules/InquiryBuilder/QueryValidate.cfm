
<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND   FunctionSerialNo = '#url.FunctionSerialNo#'	
</cfquery>

<cfset queryscript = urldecode(form.QueryScript)>

<cfif len(QueryScript) gte 10>
	
	<cfif findNoCase("UPDATE",Form.QueryScript) or findNoCase("DELETE",Form.QueryScript)>
		 <script>
		 alert("Problem, you may not process an UPDATE/DELETE query")
		 </script>
		 <cfabort>
	</cfif> 
	
	<cfif FindNoCase("ORDER BY", QueryScript)>
	
		<script>
		alert("ORDER BY may not be used in the query")
		</script>
		<cfabort>
	
	</cfif>	
	
	
	<cftry>
	
	    <cfset sc = replace(QueryScript, "SELECT",  "SELECT TOP 1")> 

		<!--- -------------------------- --->
		<!--- preparation of the listing --->
		<!--- -------------------------- --->
			
		<cfset fileNo = "#Header.DetailSerialNo#">					
		<cfinclude template="QueryPreparation.cfm">				
		<cfinclude template="QueryValidateReserved.cfm">
																				
		<cfquery name="SelectQuery" 
		datasource="#Form.QueryDatasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">				
		   #preservesinglequotes(sc)# 
		</cfquery>			
		
		<cfset client.listingquery = preservesinglequotes(QueryScript)>
			
		<cfquery name="Save" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    UPDATE Ref_ModuleControlDetail
			SET    QueryScript      = '#QueryScript#', 
			       QueryDataSource  = '#Form.QueryDatasource#'
			WHERE  SystemFunctionId = '#URL.SystemFunctionId#'
			AND    FunctionSerialNo = #url.FunctionSerialNo#	
		</cfquery>
		
		<cfoutput>		
		
		<script language="JavaScript">		
		
			_cf_loadingtexthtml='';	    
			
			ColdFusion.navigate('../InquiryBuilder/InquiryEditFields.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','fields')
			// ColdFusion.navigate('../InquiryBuilder/SubDrill.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','drill')
			ColdFusion.navigate('../InquiryBuilder/SubTable.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','table')
			ColdFusion.navigate('../InquiryBuilder/SubBottom.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','bottom')
						
		</script>
		
		<table cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr>		
		<td class="labelmedium" style="padding:3px"><font color="008000">Query validated and saved.</td></tr>		
		<script>		
			document.getElementById('testing').className = "button10g"
		</script>					
		
		</table>
		</cfoutput>
		<cfabort>
	
		<cfcatch>
		
											
				<cfoutput>
				<table width="100%">
				<tr class="labelmedium" style="font-size:20px"><td>
				<font color="red">Invalid query 
				</td></tr>
				<tr class="labelmedium"><td bgcolor="FFFFCF" style="padding:3px;font-size:13px;border: 1px solid Silver;">
				#CFCatch.Message# - #CFCATCH.Detail#
				</td></tr>
				<tr class="labelmedium"><td>#Form.QueryDatasource#</td></tr>
				<tr><td width="100%">
				
				<textarea class="regular"
		          style="width:100%; height:100%; color: FFA07A;">#preservesinglequotes(sc)#</textarea>
				
				</td></tr>
				</table>		       
				</cfoutput>
				
				<script>
					show('hide')
					document.getElementById('testing').className = "hide"
				</script>
				
			<cfabort>
			
			
		</cfcatch>
	
	</cftry>

</cfif>
