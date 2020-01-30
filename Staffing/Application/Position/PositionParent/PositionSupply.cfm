<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT *
	 FROM  PositionParent		 
	 WHERE PositionParentId = '#URL.ID2#'	 
</cfquery>

<cfif PositionParent.recordcount eq "0">
    <cf_message message="Problem, Position could not be located. Please contact your administrator.">
    <cfabort>
</cfif>

<cfquery name="Current" 
datasource="AppsOrganization" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
   FROM Ref_Mandate
   WHERE Mission = '#PositionParent.Mission#'
   AND MandateNo = '#PositionParent.MandateNo#'
</cfquery>

<cfquery name="PositionChild" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	 *
	FROM 	 Position
	WHERE 	 PositionParentId = '#URL.ID2#' 
	ORDER BY DateEffective DESC
</cfquery>

<cfquery name="Posttype" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	 *
	FROM 	 Ref_PostType
	WHERE 	 PostType = '#PositionChild.PostType#' 	
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td height="10"></td></tr>

	<tr class="noprint" class="line">
   
    <td height="24" style="padding-right:4px">
	
		<cfoutput>	
		<table cellspacing="0" cellpadding="0" class="formpadding">
		<tr>
		    <td class="labelit" style="padding-left:5px">Current PostNumber:</td>
			<td class="labelmedium" style="padding-left:5px"><b>#PositionChild.SourcePostNumber#</font></b></td>
			<td class="labelit" style="padding-left:10px">Mandate:</td>
			<td class="labelmedium"><b>#Current.Description#</b></td>
			<td class="labelit" style="padding-left:10px">Period:</td>
			<td class="labelmedium" style="padding-left:5px"><b>#DateFormat(Current.DateEffective, CLIENT.DateFormatShow)# - #DateFormat(Current.DateExpiration, CLIENT.DateFormatShow)#</b></td>
		</tr>
		</table>	
		</cfoutput>
		
    </td>
	
	<td align="right">
	
   <cfinvoke component="Service.Access"  
		  method="position" 
		  orgunit="#PositionParent.OrgUnitOperational#" 
		  role="'HRPosition'"
		  posttype="#PositionParent.PostType#"
		  returnvariable="accessPosition">
  
   <cfinvoke component="Service.Access"  
		  method="position" 
		  orgunit="#PositionParent.OrgUnitOperational#" 
		  role="'HRLoaner'"
		  posttype="#PositionParent.PostType#"
		  returnvariable="accessLoaner">
	
	<cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
	
		<!--- remove only from the the other tab can be access 
		
		        <table cellspacing="0" cellpadding="0">
				
				
				<tr>
				
					<cfoutput>
				
					<td style="padding-top:1px">
					<cf_img icon="edit" onclick="EditParentPosition('#PositionParent.Mission#','#PositionParent.MandateNo#','#PositionParent.PositionParentId#')">
					</td>
								
					<td style="padding-left:7px" class="labelmedium">			
					<cf_tl id="Parent Position" var="1">  
					<a href="javascript:EditParentPosition('#PositionParent.Mission#','#PositionParent.MandateNo#','#PositionParent.PositionParentId#')">
					<font color="6688AA">#lt_text#</font>
					</a>
					</td>
					
					</cfoutput>
				
				</tr>
				
				</table>
				
				--->

	</cfif>
			
	</td>
  </tr> 	
 
		
	<cfoutput> 
	
	<tr><td style="font-size:25px;height:45px;padding-left:3px;font-weight:200" class="labellarge">Program/Fund and object</td></tr>
	
	<cf_verifyOperational 
         module    = "Program" 
		 Warning   = "No">		 
		
	<cfif operational eq "1">
	
	
		<tr><td style="padding-left:4px"><font size="1">usage:<b> Budget Planning</td></tr>
		<tr><td height="1" class="line" colspan="2"></td></tr>
	
		<tr><td colspan="2" style="padding-left:20px">
			<cfdiv bind="url:../Funding/PositionFunding.cfm?ID=#url.id2#" id="fundbox">
		</td></tr>
		
		<cfif PostType.Procurement eq "1">
		
		<tr><td height="4"></td></tr>
		
		<tr><td style="padding-left:4px"><font size="1">usage:<b> Obligation driven</td></tr>
		<tr><td height="1" class="line" colspan="2"></td></tr>
		
		<tr><td colspan="2" style="padding-left:20px">
			<cfdiv bind="url:../Funding/PositionObligation.cfm?ID=#url.id2#" id="obligbox">
		</td></tr>
		
		</cfif>
					  
	</cfif>	
	
		
	<tr><td height="10"></td></tr>
	<tr><td style="font-weight:200;font-size:25px;height:45px;padding-left:3px" class="labellarge"><cf_tl id="Workforce class"></td></tr>
	<tr><td style="padding-left:4px"><font size="1">usage:<b> Workforce Classification and Planning</td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	
	<cf_verifyOperational 
         module    = "Program" 
		 Warning   = "No">
	
	<cfif operational eq "1">
	
		<tr><td colspan="2" style="padding-left:20px">
			<cfdiv bind="url:WorkforceEntry.cfm?ID=#url.id#" id="workbox">
		</td></tr>
		
	<cfelse>
	
		<tr><td align="center"><font color="808080">Function not operational</td></tr>	
			  
	</cfif>	
	
	
	<tr><td height="10"></td></tr>
	<tr><td style="font-weight:200;font-size:25px;height:45px;padding-left:3px" class="labellarge"><cf_tl id="Roster"> <font size="3">from which candidates for this position will be sourced</td></tr>
	<tr><td style="padding-left:4px"><font size="1">usage:<b> <cf_tl id="Roster Forecasting"></td></tr>
	<tr><td height="1" class="line" colspan="2"></td></tr>
	
	<cf_verifyOperational 
         module    = "Roster" 
		 Warning   = "No">
	
	<cfif operational eq "1">
	
		<tr><td colspan="2" style="padding-left:20px">
			<cfdiv bind="url:../Edition/Edition.cfm?ID=#url.id2#" id="editionbox">
		</td></tr>
		
	<cfelse>
	
		<tr><td align="center"><font color="808080">Function not operational</td></tr>	
			  
	</cfif>	
	
	</cfoutput>	
	
	
</table>