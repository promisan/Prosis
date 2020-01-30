<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<cfloop index="itm" list="#url.ajaxid#" delimiters="_"></cfloop>

	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT L.*
	    FROM RequisitionLine L
		WHERE RequisitionNo = '#itm#'
	</cfquery>
				 
	 <TR><TD id="collaboration" class="labelit">
		
			<cfif Line.entityClass eq "">				
			
				<cfquery name="Class"
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT DISTINCT R.*
					FROM  Ref_EntityClass R, 
					      Ref_EntityClassPublish P
					WHERE R.Operational = '1'
					AND  R.EntityCode   = P.EntityCode 
					AND  R.EntityClass  = P.EntityClass
					AND  R.EntityCode = 'ProcReq'			
				</cfquery>		
				
				<table class="formspacing"><tr><td>
			
				 <cf_tl id="Collaboration schema">:&nbsp;		
				<select name="entityclass" id="entityclass" class="regularxl">			
			    	<cfoutput query="Class">
						<option value="#EntityClass#">#EntityClassName#</option>				
					</cfoutput>			
				</select>
				
				</td>
				<td>			
				<button class="button10g" name="workflow" id="workflow" onclick="flowload(entityclass.value)">
					<cf_tl id="Initiate">
				</button>	
				</td>
				</tr></table>
			
			<cfelse>	
				
				<cfinclude template="RequisitionEditFlowShow.cfm">		
				
			</cfif>							
		</TD>	
	</TR>		
			
</table>