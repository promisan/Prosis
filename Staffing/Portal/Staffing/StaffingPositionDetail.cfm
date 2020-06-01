
<cfoutput>
<table style="border:1px solid silver;width:100%">
	
	<tr><td valign="top" style="width:100%;padding-top:5px;padding-left:5px">
	
		<table style="width:100%">
		  <tr><td colspan="2" style="width:100%;font-size:15px;font-weight:bold">#FunctionDescription#</td></tr>
		  <tr>
		  <td colspan="2" style="width:100%">#SourcePostNumber# #PostGrade# 
		  <cfif ApprovalPostGrade neq PostGrade and ApprovalPostGrade neq "">#ApprovalPostGrade#</cfif>
		  <!--- check if there is an active classification flow --->
		  
		  
		  </td>
		  </tr>
		  <tr><td colspan="2" style="width:100%">#PostType# / #PostClass#</td></tr>
		  <tr><td style="min-width:90px"><cf_tl id="Expiry">:</td><td style="width:100%">#DateFormat(DateExpiration,client.dateformatshow)#</td></tr>
		</table>
		
	</td></tr>
	
	<cfquery name="AssignDetail" dbtype="query">
		SELECT     *
		FROM       Assignment
		WHERE      PositionNo = '#PositionNo#' 
		ORDER BY   Incumbency DESC		
    </cfquery>	
	
	<cfif AssignDetail.recordcount eq "0">
	
	<cfelse>
	
		<cfloop query="AssignDetail" startrow="1" endrow="2">
		
		<cfquery name="getContract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT     *
				FROM       PersonContract
				WHERE      PersonNo = '#PersonNo#' 	
				AND        Mission IN ('UNDEF','#url.mission#')	
				AND        ActionStatus IN ('0','1')
				AND        DateEffective <= '#url.selection#'
				ORDER BY DateEffective DESC					
		  </cfquery>	
		
		<tr><td style="padding:5px;height:130px;width:100%">
		     <table style="width:100%;height:100%">
			 <tr>
			 <td valign="top" style="border:1px solid silver;width:100%;padding:2px">
				 <table style="width:100%">
				 <tr class="line"><td style="width:85px">
				  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
				  <img src='#vPhoto#' class="img-circle clsRoundedPicture" style="height:75px; width:75px;">	
				  </td>
				  <td valign="top" style="padding:3px">
				  	<table>
					   <tr><td>#IndexNo#</td></tr>
					   <tr><td>#LastName#, #FirstName#</td></tr>
					   <tr><td>#getContract.ContractLevel#/#getContract.ContractStep#</td></tr>
					   <tr><td>#Nationality#</td></tr>
					 </table>
				  </td>		  
				  </tr>	 
				 </table> 
			 </td>
			 
			 </tr>
			 </table>
		</td></tr>
		</cfloop>
		
	</cfif>	
	
	<tr><td valign="top" style="padding-left:4px;height:120px;width:100%">Candidate</td></tr>
	
</table>
</cfoutput>