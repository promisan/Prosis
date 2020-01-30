
<cfquery name="Prior" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT   OA.*, A.ActionDescription
	   FROM     OrganizationObjectAction OA, Ref_EntityAction A
	   WHERE    OA.ActionId      = '#memoactionid#'
	   AND      OA.ActionStatus >= '2'
	   AND      A.ActionCode = OA.ActionCode
	   ORDER BY OA.CREATED DESC 
	</cfquery>

<cfoutput>

 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding"  style="height:100%">
					        
   		    <tr><td height="19" align="center" bgcolor="0D86FF" class="labelmedium"><font color="FFFFFF">Prepared Documents under step <b>#Prior.ActionDescription#</b> (#Prior.OfficerFirstName# #Prior.OfficerLastName#)</td></tr>				  
										
			<tr><td>
												
				<cfinclude template="ProcessActionPriorDocument.cfm">
					
			</td></tr>								
			
	</table>	
	
</cfoutput>	