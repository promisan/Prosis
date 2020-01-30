
<cfquery name="Fields" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  I.*, D.DocumentOrder
     FROM    OrganizationObjectInformation I, 
	         Ref_EntityActionPublishDocument R,
			 Ref_EntityDocument D 
	 WHERE   ObjectId  = '#ObjectId#' 
	 AND     I.DocumentId IN (SELECT DocumentId 
	                          FROM   Ref_EntityActionDocument 
							  WHERE  ActionCode = '#ActionCode#')
	 AND     R.ActionPublishNo = '#ActionPublishNo#'
	 AND     I.DocumentId = R.DocumentId
	 AND     R.ActionCode = '#ActionCode#'		
	 AND     D.DocumentId = I.DocumentId
	 AND     R.Operational = 1	
	 ORDER BY D.DocumentOrder	
	 						
</cfquery>

<cfoutput>
			
	<cfif Fields.recordcount gt "0">
			
		<tr>
		<td colspan="#col#" align="center">		
		<table width="80%" cellspacing="0" cellpadding="0" class="formspacing">
			
			<cfset cnt = 0>	
			<cfloop query="fields">
			
			<cfset cnt = cnt+1>
			<cfif cnt eq "1"><tr></cfif>			
		
			<td class="labelit" style="min-width:300"><font color="gray">#DocumentDescription#:</font></td>
	
			<td width="80%" class="labelit">
			
				<font color="black">
				<cfif DocumentItem eq "amount">
				
				<cftry>			
				   #numberformat(DocumentItemValue,"__,__.__")#
				   <cfcatch>-----</cfcatch>			
				</cftry>
				
				<cfelseif documentitem eq "map">			
				   <cf_getAddress coordinates="#DocumentItemValue#">			
				<cfelse>			
				   #DocumentItemValue#			
				</cfif>					
				
			 </td>
			 
			 <cfif cnt eq "1"></tr><cfset cnt=0></cfif>
					
			</cfloop>
		
		</table>
		</td>
		</tr>		
				
	</cfif>

</cfoutput>			
			