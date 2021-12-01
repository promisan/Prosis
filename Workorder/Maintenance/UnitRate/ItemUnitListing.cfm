
<!--- enabled units for a service item --->

<cfquery name="Unit" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   S.*, 	       
			 UC.description as unitClassDescription
	FROM     ServiceItemUnit S,
			 Ref_UnitClass UC
	WHERE 	 S.UnitClass    = UC.code
	AND 	 S.ServiceItem  = '#URL.ID1#'
	ORDER BY S.UnitClass, S.UnitParent, S.ListingOrder
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

	<tr><td height="2"></td></tr> 

	<tr>
		<td colspan="11">
			<cfoutput>
			<input class="button10g" style="width:160" type="Button" name="AddRecord" id="AddRecord" value=" Add New "  onclick="showunit('#URL.ID1#','')">
			</cfoutput>
		</td>
	</tr>

	<tr><td height="7"></td></tr> 

 	<TR class="labelmedium line fixlengthlist" height="18">	 	
	   <td width="2"></td>
	   <td></td>
	   <td><cf_tl id="Unit"></td>	  
	   <td><cf_tl id="Code"></td>
	   <td><cf_tl id="GlAccount"></td>
	   <td><cf_tl id="Description"></td>
	   <td><cf_tl id="Parent"></td>	
	   <td><cf_tl id="Frequency"></td>
	   <td><cf_tl id="Mode"></td>
	   <td><cf_tl id="Ope."></td>
	   <td><cf_tl id="Officer"></td>
	   <td><cf_tl id="Created"></td>	  
	   <td></td>
    </TR>	
	
<cfoutput query="Unit" group="unitClass">	
	
	<TR class="line">		
		<td width="5"></td>
		<td style="height:40px" colspan="11" class="labellarge">
		<cfif unitclassdescription eq "regular">
			<cf_tl id="Miscellaneous - Other">
		<cfelse>
			<cf_tl id="#unitClassDescription#">
		</cfif>
		</td>	  		
   </tr>
          
   <cfoutput>   
   
	   <cfif UnitParent eq "">
		   <tr style="height:22px" class="labelmedium line navigation_row fixlengthlist" bgcolor="ffffdf">
	   <cfelse>
		   <tr style="height:22px" class="labelmedium line navigation_row fixlengthlist" bgcolor="FFFFFF">
	   </cfif>
		
		<td height="20"></td>
		
		<td align="center" style="padding-right:8px">
			<cf_img icon="edit"	navigation="Yes" onclick="showunit('#URL.ID1#','#unit#')">
		</td>
		
		<td>#unit#</td>	  
		<td>#unitCode#</td>
   		<td>#GlAccount#</td>
		<td title="#unitdescription#">#unitDescription#</td>		
		<td>#unitparent#</td>		
		<td>#frequency#</td>
		<td>#billingMode#</td>		
		<td><cfif operational eq "0"><b>No</b><cfelse>Yes</cfif></td>	   		
		<td>#OfficerLastName#</td>
		<td>#dateformat(created,CLIENT.DateFormatShow)#</td>		   	      	   		   
		
		<td align="center" style="padding-right:4px">
		
		   <cfquery name="verifyDeleteIU" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT top 1 *
				FROM   WorkOrderLineBillingDetail
				WHERE  serviceItem = '#URL.ID1#'
				AND    serviceItemUnit = '#unit#'
			</cfquery>	
			
			<cfif verifyDeleteIU.recordCount eq 0>			
				<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?'));_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/workorder/maintenance/unitRate/ItemUnitPurge.cfm?ID1=#URL.ID1#&ID2=#unit#','contentbox2')">
			</cfif>		
						
		</td>	
	 </tr>		   		   
	   
   </cfoutput>
   
   <tr><td height="10"></td></tr>
   
</cfoutput>   

</table>

<cfset ajaxonload("doHighlight")>

<!--- enabled units for a service item --->