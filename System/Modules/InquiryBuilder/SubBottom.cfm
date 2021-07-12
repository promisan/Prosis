
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
		
		<cfoutput>
		<cfsavecontent variable="sc">	
			SELECT *
			FROM (#preservesinglequotes(sc)#) as D
			WHERE 1=0		
		</cfsavecontent>		
		</cfoutput>
		
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
					style="width:245;height:27"
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
			
			 <cf_tl id="Save" var="1">
			
			<button name="save" id="save" class="button10g" style="border:1px solid gray;width:245;height:27" type="button"
				onclick="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/System/Modules/InquiryBuilder/InquiryEditSubmit.cfm?systemfunctionid=#URL.SystemFunctionId#&FunctionSerialNo=#URL.FunctionSerialNo#','result','','','POST','inquiryform');document.getElementById('testing').className='button10g'">
				 #lt_text#
			</button>
			
			</td>
			
						
			</tr>
			</table>
						
		</cfoutput>
		
		<cfcatch>
			
			<input class="button10g" style="height:27px" type="button" name="Cancel" id="Cancel" value="Close" onclick="window.close();returnvalue=9">
				
		</cfcatch>
	
	</cftry>

<cfelse>

	<script>
		show('hide')
	</script>
		
</cfif>

		
	
		