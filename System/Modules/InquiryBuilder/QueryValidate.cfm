
<cfquery name="Header" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'
	AND   FunctionSerialNo = '#url.FunctionSerialNo#'	
</cfquery>


<!---
<cfset queryscript = urldecode(form.QueryScript)> : this remove the + sign and that was not good for Field + field2 queries
--->
<cfset queryscript = form.QueryScript>


<cfif len(QueryScript) gte 10>
			
	<cfif findNoCase("UPDATE",Form.QueryScript) or findNoCase("DELETE",Form.QueryScript) and getAdministrator("*") eq "1">
		
		<cfquery name="Header" 
			datasource="#Form.QueryDatasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    #preservesinglequotes(queryscript)#
		</cfquery>
				
		 <script>
		 alert("Applied")
		 </script>	
		 <cfabort>
	
	<cfelseif findNoCase("UPDATE",Form.QueryScript) or findNoCase("DELETE",Form.QueryScript)>
	
		 <script>
		 alert("Problem, you may not process an UPDATE/DELETE query")
		 </script>	
		 <cfabort>
		 
	</cfif>		
			
	<cfset st = len(queryscript)-50>
	<cfif st gt 0>
	
	     <cfset ct = 50>

		<cfset subscript = mid(queryscript,st,ct)>
		
		<cfif FindNoCase("ORDER BY", subscript)>
		
			<script>
			alert("ORDER BY may not be used in the query")
			</script>
			<cfabort>
		
		</cfif>		
	
	</cfif>		
	
	
	<cftry>
	
	    <cfset sc = replaceNoCase(QueryScript, "SELECT",  "SELECT TOP 1")> 
		
		<!--- added 6/9/2021 --->
		<cfset sc = replaceNoCase(sc, "--Condition","")> 
				
		<cfoutput>
		<cfsavecontent variable="sc">	
			SELECT *
			FROM (#preservesinglequotes(sc)#) as D
			WHERE 1=0		
		</cfsavecontent>		
		</cfoutput>

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
							
		<cfquery name="Save" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    UPDATE  Ref_ModuleControlDetail
			SET     QueryScript      = '#QueryScript#', 
			        QueryDataSource  = '#Form.QueryDatasource#'
			WHERE   SystemFunctionId = '#URL.SystemFunctionId#'
			AND     FunctionSerialNo = #url.FunctionSerialNo#	
		</cfquery>
		
		<cfoutput>		
		
			<script language="JavaScript">		
			
				_cf_loadingtexthtml='';	    
				
				ptoken.navigate('../InquiryBuilder/InquiryEditFields.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','fields')
				// ptoken.navigate('../InquiryBuilder/SubDrill.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','drill')
				ptoken.navigate('../InquiryBuilder/SubTable.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','table')
				ptoken.navigate('../InquiryBuilder/SubBottom.cfm?systemfunctionid=#url.systemfunctionid#&functionserialno=#url.functionserialno#','bottom')
							
			</script>
		
			<table class="formpadding" style="height:10px">			
			<tr>		
			<td class="labelmedium2" style="padding-left:4px"><font color="008000">Query validated and saved #timeformat(now(),"HH:MM:SS")#.</td></tr>				
			<script>		
				document.getElementById('testing').className = "button10g"
			</script>							
			</table>
		</cfoutput>
			
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
				<tr><td width="100%" style="padding:5px;background-color:FF8080;border:1px solid silver">				
				#preservesinglequotes(sc)#								
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
