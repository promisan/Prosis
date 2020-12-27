
<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ModuleControlDetail
	WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
	AND   FunctionSerialNo = #url.FunctionSerialNo#		
</cfquery>

<cfif Check.QueryScript neq "">
	
	<cftry>
	
	    <cfset sc = replace(Check.QueryScript, "SELECT",  "SELECT TOP 1")> 
		
		<cfset fileNo = "#Check.DetailSerialNo#">		
		<cfinclude template="QueryPreparationVars.cfm">		
		<cfinclude template="QueryValidateReserved.cfm">
	
		<cfquery name="SelectQuery" 
		datasource="#Check.QueryDataSource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#"> 
		   #preservesinglequotes(sc)# 
		</cfquery>	
		
		<!---
		<cfoutput>
		#cfquery.executiontime#	
		</cfoutput>
		--->
		
		<cfoutput>			
				
				
			<script>
				try {show('regular')} catch(e) {}
			</script>
						
			<table>
			<tr>				
														
			<cf_distributer>			
									
			<cfquery name="productionsite" 
				  datasource="AppsControl">
					SELECT  DISTINCT DatabaseServer as dbserver
					FROM    ParameterSite
					WHERE   ServerLocation = 'Local'
					AND     ServerRole     = 'Production'	
					AND     Operational    = 1
					AND     DatabaseServer > ''		
			</cfquery>	
					
			<cfif check.queryDataSource neq "" and check.queryScript neq ""
			    and master eq "1" and productionsite.recordcount gte "1">
			
				<td>
				<button type="button"
					class="button10g"
					style="width:145;height:25"
					onclick="ptoken.navigate('#SESSION.root#/tools/process/entityaction/FunctionDeploy.cfm?controlid=#URL.SystemFunctionId#','deploy')">
					<img src="#SESSION.root#/Images/deploy.gif" height="12" align="absmiddle" alt="" border="0"> Deploy
				</button>
				</td>
				
				<!---
				
				<td>
				<button type="button"
					class="button10g"
					style="width:145;height:25"
					onclick="ColdFusion.navigate('#SESSION.root#/tools/mobile/FunctionDeploy.cfm?controlid=#URL.SystemFunctionId#&FunctionSerialNo=#URL.FunctionSerialNo#','deploy')">
					<img src="#SESSION.root#/Images/deploy.gif" height="12" align="absmiddle" alt="" border="0"> Deploy Mobile
				</button>
				</td>
				
				--->						
							
			</cfif>
						
			<td onMouseOver="document.getElementById('save').focus()">
			
			<button name="save" id="save" class="button10g" style="width:145;height:25" type="button"
				onclick="ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditSubmit.cfm?systemfunctionid=#URL.SystemFunctionId#&FunctionSerialNo=#URL.FunctionSerialNo#','result','','','POST','inquiryform');document.getElementById('testing').className='button10g'">
				 Save
			</button>
			
			</td>
			
						
			</tr>
			</table>
						
		</cfoutput>
		
		<cfcatch>
			
			<input class="button10g" style="height:25px" type="button" name="Cancel" id="Cancel" value="Close" onclick="window.close();returnvalue=9">
				
		</cfcatch>
	
	</cftry>

<cfelse>

	<script>
		show('hide')
	</script>
		
</cfif>

		
	
		