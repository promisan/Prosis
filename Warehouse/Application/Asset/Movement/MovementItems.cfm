
<cfparam name="URL.Table"        default="2">
<cfparam name="URL.ActionStatus" default="0">
<cfparam name="URL.MovementId"   default="">

<cfparam name="URL.page" default="1">

<cfparam name="URL.view" default="Default">
<cfparam name="URL.sort" default="B.Description">

<cfset currrow = 0>

<cfset condition = "">
 
  <cfquery name="SearchResult" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT  B.*, 
		
		        Per.LastName, 
				Per.FirstName, 
				Per.Birthdate, 
				O.OrgUnitName, 
				P.OrgUnitVendor, 
				Loc.LocationCode, 
				Loc.LocationName
			
		FROM    #SESSION.acc#AssetMove#URL.Table# B INNER JOIN
        	    Organization.dbo.Organization O ON B.OrgUnit = O.OrgUnit LEFT OUTER JOIN
	            Purchase.dbo.Purchase P ON    B.PurchaseNo = P.PurchaseNo LEFT OUTER JOIN
    	        Employee.dbo.Person Per ON    B.PersonNo = Per.PersonNo LEFT OUTER JOIN
        	    Materials.dbo.Location Loc ON B.Location = Loc.Location		
			 
		ORDER BY #URL.Sort#
	
  </cfquery>
   					
<cfset counted = Searchresult.recordcount>
	
<!--- Query returning search results --->

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>
	
	<td colspan="3"></td>
	<td colspan="4" height="30" align="right">
	
	<cfoutput>
	
			<select name="view" id="view" class="regularxl" size="1" style="background: FfFfFf; color: gray;"
	          onChange="reloadForm('#url.movementid#',sort.value,this.value)">
				 <option value="Default" <cfif  URL.View eq "Default">selected</cfif>><cf_tl id="Item listing"></option>
				 <option value="Purchase" <cfif URL.View eq "Purchase">selected</cfif>><cf_tl id="Purchase Information"></option>
				 <option value="Location" <cfif URL.View eq "Location">selected</cfif>><cf_tl id="Location information"></option>
	        </SELECT>
	        
			<select name="sort" id="sort" class="regularxl" size="1" style="background: FfFfFf; color: gray;"
	          onChange="reloadForm('#url.movementid#',this.value,view.value)">
				 <option value="B.Description"    <cfif URL.Sort eq "B.Description">selected</cfif>><cf_tl id="Description"></option>
				 <option value="Make"             <cfif URL.Sort eq "Make">selected</cfif>><cf_tl id="Make"></option>
				 <option value="ActionStatus"     <cfif URL.Sort eq "ActionStatus">selected</cfif>><cf_tl id="Status"></option>
				 <option value="DepreciationBase" <cfif URL.Sort eq "DepreciationBase">selected</cfif>><cf_tl id="Value"></option>
	        </SELECT>
			
	</cfoutput>
			
	</td>
	
	</tr>
	
	<tr><td colspan="7">
	
	<table width="100%" border="0" 
	  cellspacing="0" cellpadding="0" align="left" class="navigation_table">
	
	
	<cfquery name="SearchTotal" dbtype="query">
	    SELECT count(AssetId) as Items,
		       sum(DepreciationBase) as Total
		FROM   SearchResult
	</cfquery>
	
	<cfoutput>
	
	<TR><td height="25" colspan="2" class="labelmedium"><cf_tl id="Items">: <b>#SearchTotal.Items#</td>
		<td colspan="4" align="right" style="padding-right:5px" class="labelmedium"><cf_tl id="Value">: <b>#numberFormat(SearchTotal.Total,"_,__.__")#</td>
	</TR>	
	<tr><td height="1" colspan="6" class="linedotted"></td></tr>
	
	</cfoutput>
	<tr class="labelmedium">
		<td height="20" width="5%"></td>
		<td width="34%"><cf_tl id="Description"></td>
	    <td width="10%"><cf_tl id="Barcode"></td>
		<td width="15%"><cf_tl id="SerialNo"></td>
		<td width="15%"><cf_tl id="Make"></td>
		<td width="20%" align="right"><cf_tl id="Value"></td>
	</TR>
	
	<cfif SearchResult.recordcount eq "0">
		
		<cfif URL.View eq "Purchase">
		
			<TR class="labelmedium" bgcolor="f4f4f4">
			    <td height="20" width="5%"></td>
				<td width="34%"><cf_tl id="Add. description"></td>
			    <td width="10%"><cf_tl id="Model"></td>
				<td width="15%"><cf_tl id="PurchaseNo"></td>
				<td width="15%"><cf_tl id="Requisition"></td>
				<td width="20%"></td>
			</TR>
			
		</cfif>
		
		<cfif URL.View eq "Location">
		
			<TR class="labelmedium">
			    <td height="20" width="5%"></td>
				<td width="34%"><cf_tl id="Unit"></td>
			    <td width="10%"><cf_tl id="Location"></td>
				<td width="15%"><cf_tl id="Building"></td>
				<td width="15%" colspan="2"><cf_tl id="Description"></td>
			</TR>
				
		</cfif>
	
	</cfif>
	
	<cfif SearchResult.recordcount eq "0">
	
		<tr><td colspan="6" height="30" align="center"><font color="808080"><cf_tl id="There are no items to show in this view">.</b></td></tr>
		
	<cfelse>
		
	<cfoutput query="SearchResult">
	
		    											
				<cfif ParentAssetId neq "">
				<TR bgcolor="ffffaf" class="navigation_row labelmedium">
				<cfelse>
				<tr class="navigation_row labelmedium">
				</cfif>
	
			    <TD width="7%" height="18" align="center">
				
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				 
					  <tr><td align="center">
	                  	
					  <cfif URL.ActionStatus eq "0">	
					  
					  	<cf_img icon="delete" onClick="movedel('#url.movementid#','#AssetId#','#url.actionstatus#','#url.table#')">	
							
					  </cfif>
					 				  
					  </td>
					  <td></td>
					  </tr>
				  
				  </table>	
									
				</td>
			    <TD><a href="javascript:AssetDialog('#AssetId#','edit')"><font color="0080C0">#ParentDescription#</a></td>
			    <TD>#AssetBarCode#</td>
			    <TD>#SerialNo#</TD>
				<TD>#Make#</TD>
				<td align="right">#numberFormat(DepreciationBase,"__,_.__")#&nbsp;</td>
					
			</TR>
				
			<cfif ParentAssetId neq "">
				<TR bgcolor="ffffaf" class="labelmedium"><td align="center"><img src="#SESSION.root#/images/join.gif" border="0"></td><td colspan="7">Dependent item</td></tr>
			</cfif>
				
			<cfif URL.View eq "Purchase" and PurchaseNo neq "">			
				  
				  <cfset p = "regular">			  
				  <tr><td height="1" colspan="7" class="linedotted"></td></tr>
				  
			<cfelse>
				
				  <cfset p = "hide">
				  
			</cfif>
				  
			<tr class="#p#" id="d#currrow#" name="d#currrow#" bgcolor="f4f4f4" class="labelmedium">
				<td height="16"></td>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
				<td class="labelmedium">#Description#</td>				
				</tr>
				</table>
				</td>
				<td>#Model#</td>
				<td><a href="javascript:ProcPOEdit('#Purchaseno#','view')" ref="">#PurchaseNo#</a></td>
				<td>#RequisitionNo#</td>
				<td align="right"></td>
			</tr>	
								
			<cfif URL.View eq "Location">
				  <cfset p = "regular">
			    <tr><td height="1" colspan="7" class="linedotted"></td></tr>
			<cfelse>
				  <cfset p = "hide">
			</cfif>
				
			<tr class="#p#" id="d#currrow#" bgcolor="f4f4f4" name="d#currrow#" class="labelmedium">
				<td height="16"></td>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
				<td class="labelmedium">#OrgUnitName#</td>				
				</tr>
				</table>
				</td>
				<td>#LocationCode#</td>
				<td></td>
				<td colspan="2">#LocationName#</td>
			</tr>	
					
			<cfif PersonNo neq "">
								
				<tr bgcolor="FBFDDF" class="#p#" id="d#currrow#" name="d#currrow#">
				
				<td height="16"></td>
				<td colspan="6">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
					<td width="99%">
					<table width="100%">
					<tr>
					 <td class="labelmedium" width="50%">&nbsp;&nbsp;#LastName#, #FirstName#</td>
					 <td class="labelmedium" width="50%">#DateFormat(DateEffective,CLIENT.DateFormatShow)#
					</tr>
					</table>
					</td>
					</tr>
					</table>
				</td>
				</tr>	
			
			</cfif>
				 	      
	</cfoutput>   
	
	</cfif>
	
	</TABLE>			 
	
	</td>
	</tr>
	
</table>

<cfset ajaxonload("doHighlight")>

