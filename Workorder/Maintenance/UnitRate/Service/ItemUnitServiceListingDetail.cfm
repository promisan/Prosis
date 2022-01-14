
<cfif url.id2 neq "">

<table width="100%" align="center" class="navigation_table formpadding">
		
	<TR class="line">
		<TD valign="middle" style="height:40px;font-weight:bold" colspan="5" class="labellarge"><cf_tl id="Usage"></TD>	
	
		<td align="right" colspan="3">
			<cfoutput>
			<input class="button10g" style="font-size:11px;width:160px;height:25" type="Button" name="AddRecord" id="AddRecord" value="Add Usage"
			 onclick="edititemservice('', '#URL.ID1#', '#URL.ID2#')">	
			</cfoutput>
		</td>
	</tr>
						
    <TR class="fixlengthlist labelmedium2 line">	
	   <td><cf_tl id="Entity"></td>
	   <td><cf_tl id="Service Domain"></td>  
	   <td align="center"><cf_tl id="Sort"></td>
	   <td align="right"><cf_tl id="Preset"></td>
	   <td align="right"><cf_tl id="Created"></td>	  
	   <td align="right"></td>	
	   <td align="right"></td>	 	 
    </TR>	
			
	<cfquery name="qListing" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   S.*
		FROM     ServiceItemUnitWorkorderService S
		WHERE    S.ServiceItem    = '#URL.ID1#'
		AND      S.Unit           = '#URL.ID2#'
		ORDER BY S.Mission, ListingOrder
	</cfquery>
	
	<cfoutput query="qListing" group="Mission">
	<!---
	<tr><td height="20" colspan="12" class="labelmedium" style="padding-left:7px"><b>#Mission#</td></tr>
	<tr><td colspan="12" style="padding-left:7px" class="line"></td></tr>
	--->
	<cfset row = 1>
	<cfoutput>		
		<TR class="labelmedium navigation_row line fixlengthlist">	
				
		    <td style="padding-left:4px"><cfif row eq "1">#Mission#</cfif></td>	  
			<td><b>#ServiceDomain#</b>: #Reference#</td>				
			<td align="center">#ListingOrder#</td>
			<td align="right"><cfif enablesetdefault eq "1"><b><cf_tl id="Yes"></b><cfelse>--</cfif></td>
			<td align="right">#dateformat(Created,client.dateformatshow)#</td>
						   			   				 
			<td align="center" style="width:20px">			
				<cf_img icon="edit" navigation="Yes" onclick="edititemservice('#usageId#', '#URL.ID1#', '#URL.ID2#')">
			
			</td>				
			<td align="center" style="width:20px">
				<!--- onClick="ptoken.open('ItemUnitServiceEdit.cfm?ID1=#costId#&mode=Edit', 'EditItemUnitMission', 'left=80, top=80, width=1024, height=370, toolbar=no, status=yes, scrollbars=no, resizable=yes');"> --->
				
				<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) ptoken.navigate('#SESSION.root#/workorder/maintenance/unitRate/Service/ItemServicePurge.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#&URL.ID=#usageid#','servicelisting')">
				
			</td>		  					 							   		   
	   </tr>	
	   <cfset row = row+1>		  
		   	
	</cfoutput>
		   							
	</cfoutput>											
	
				
</table>	

<cfset ajaxonload("doHighlight")>

</cfif>	
