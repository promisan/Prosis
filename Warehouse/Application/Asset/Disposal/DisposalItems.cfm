
<cf_screentop html="No" height="100%">

<cf_dialogMail>
<cf_dialogProcurement>
<cf_dialogasset>

<cfparam name="URL.Table" default="">
<cfparam name="URL.ActionStatus" default="0">

<cfoutput>
<script>

function reloadForm(sort,view) {
  window.location =  "DisposalItems.cfm?DisposalId=#URL.DisposalId#&Sort="+sort+"&view="+view 
}  
	
function more(box,id,act,mode) {
		
	icM  = document.getElementById(box+"Min")
    icE  = document.getElementById(box+"Exp")
	se   = document.getElementById(box);
	frm  = document.getElementById("i"+box);
		 		 
	if (act=="show") {
	   	 icM.className = "regular";
	     icE.className = "hide";
    	 se.className  = "regular";
	 } else {
	     icM.className = "hide";
	     icE.className = "regular";
     	 se.className  = "hide"	 
	 }
		 		
  }
	
function delass(ass) {
if (confirm("Do you want to remove this item ?")) {       
	   	window.location = "DisposalItemsDelete.cfm?id=#URL.DisposalID#&id1="+ass+"&actionStatus=#URL.ActionStatus#&table=#URL.Table#"	
    	}	
   return false
}

	
</script>	
</cfoutput>

<cfparam name="URL.page" default="1">

<cfparam name="URL.view" default="Default">
<cfparam name="URL.sort" default="B.Description">

<cfset currrow = 0>

<cfset condition = "">
 
<cfquery name="SearchResult" 
	datasource="AppsMaterials" 
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
			
	FROM    userQuery.dbo.#SESSION.acc#Asset#url.table# B INNER JOIN
            Organization.dbo.Organization O ON B.OrgUnit = O.OrgUnit LEFT OUTER JOIN
            Purchase.dbo.Purchase P ON B.PurchaseNo = P.PurchaseNo LEFT OUTER JOIN
            Employee.dbo.Person Per ON B.PersonNo = Per.PersonNo LEFT OUTER JOIN
            Location Loc ON B.Location = Loc.Location 		
	
	WHERE   B.AssetId IN (SELECT AssetId FROM AssetItemDisposal WHERE DisposalId = '#URL.DisposalId#')
		
	ORDER BY #URL.Sort#
	
  </cfquery>
   					
<cfset counted = Searchresult.recordcount>
	
<!--- Query returning search results --->

<cfset cnt = "0">

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<tr>

<td colspan="3">
		
</td>
<td colspan="4" align="right">

		<select name="view" id="view" size="1" class="regularxl" style="background: #FfFfFf; color: gray;"
          onChange="javascript:reloadForm(sort.value,this.value)">
			 <option value="Default" <cfif URL.View eq "Default">selected</cfif>><cf_tl id="Item listing"></option>
			 <option value="Purchase" <cfif URL.View eq "Purchase">selected</cfif>><cf_tl id="Purchase Information"></option>
			 <option value="Location" <cfif URL.View eq "Location">selected</cfif>><cf_tl id="Location information"></option>
        </SELECT>
        
		<select name="sort" id="sort" size="1" class="regularxl" style="background: #FfFfFf; color: gray;"
          onChange="javascript:reloadForm(this.value,view.value)">
			 <option value="B.Description" <cfif URL.Sort eq "B.Description">selected</cfif>><cf_tl id="Description"></option>
			 <option value="Make" <cfif URL.Sort eq "Make">selected</cfif>><cf_tl id="Make"></option>
			 <option value="Status" <cfif URL.Sort eq "Status">selected</cfif>><cf_tl id="Status"></option>
			 <option value="DepreciationBase" <cfif URL.Sort eq "DepreciationBase">selected</cfif>><cf_tl id="Value"></option>
        </SELECT>
</td>

</tr>

<tr><td colspan="7">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<cfquery name="SearchTotal" dbtype="query">
    SELECT  count(AssetId) as Items,
	        sum(DepreciationBase) as Total
	FROM SearchResult
	</cfquery>

<cfoutput>

<cfset cnt = cnt+21>

<TR class="linedotted">
    <td class="labelmedium" height="20" colspan="2">&nbsp;<cf_tl id="Items">: <b>#SearchTotal.Items#</td>
	<td class="labelmedium" colspan="4" align="right">Value: <b>#numberFormat(SearchTotal.Total,"_,__.__")#&nbsp;</td>
</TR>
</cfoutput>

<TR>
	<td height="20" width="5%"></td>
	<td width="34%" class="labelit"><cf_tl id="Description"></td>
    <td width="10%" class="labelit"><cf_tl id="Barcode"></td>
	<td width="15%" class="labelit"><cf_tl id="SerialNo"></td>
	<td width="15%" class="labelit"><cf_tl id="Make"></td>
	<td width="20%" align="right" class="labelit"><cf_tl id="Value"></td>
</TR>

<cfset cnt = cnt+22>

<cfif URL.View eq "Purchase">
	
	<tr><td height="1" colspan="6" class="linedotted"></td></tr>
	
	<TR bgcolor="f4f4f4">
	    <td height="20" width="5%"></td>
		<td width="34%" class="labelit"><cf_tl id="Add. description"></td>
	    <td width="10%" class="labelit"><cf_tl id="Model"></td>
		<td width="15%" class="labelit"><cf_tl id="PurchaseNo"></td>
		<td width="15%" class="labelit"><cf_tl id="Requisition"></td>
		<td width="20%" class="labelit"></td>
	</TR>
	<cfset cnt = cnt+22>

</cfif>

<cfif URL.View eq "Location">

<TR>
    <td height="20" width="5%"></td>
	<td width="34%" class="labelit"><cf_tl id="Unit"></td>
    <td width="10%" class="labelit"><cf_tl id="Location"></td>
	<td width="15%" class="labelit"><cf_tl id="Building"></td>
	<td width="15%" class="labelit" colspan="2"><cf_tl id="Description"></td>
</TR>

<cfset cnt = cnt+22>

</cfif>

<cfif SearchResult.recordcount eq "0">

	<tr><td colspan="6" height="20" align="center" class="labelit"><font color="gray"><cf_tl id="There are not items to show in this view"></b></td></tr>
	<cfset cnt = cnt+22>

<cfelse>
	
<cfoutput query="SearchResult">
        <cfset cnt = cnt+24>
	    <tr><td height="1" colspan="7" class="linedotted"></td></tr>

     			<cfif ParentAssetId neq "">
				<TR bgcolor="yellow">
				<cfelse>
				<tr>
				</cfif>
				
			    <TD width="7%" height="18" align="center">
				
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  
				  <tr><td align="center" style="padding-top:2px">
                  	
				  <cfif URL.ActionStatus eq "0">	
				  
				  <cf_img icon="delete"	onClick="delass('#AssetId#','#url.disposalid#')">
				 
				  </cfif>
				 				  
				  </td><td>
				  <!---
				  <cfif #URL.View# neq "Purchase" and #PurchaseNo# neq "">
														
					<img src="#SESSION.root#/Images/arrowright.gif" alt="" 
						id="d#currrow#Exp" border="0" class="regular" 
						align="middle" style="cursor: pointer;" 
						onClick="more('d#currrow#','#receiptId#','show','receipt')">
							
					<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="d#currrow#Min" alt="" border="0" 
						align="middle" class="hide" style="cursor: pointer;" 
						onClick="more('d#currrow#','#receiptId#','hide','receipt')">
						
					</cfif>
					--->
					
					</td></tr></table>	
									
				</td>
			    <TD class="labelit"><a href="javascript:AssetDialog('#AssetId#','edit')">#ParentDescription#</a></td>
			    <TD class="labelit">#AssetBarCode#</td>
			    <TD class="labelit">#SerialNo#</TD>
				<TD class="labelit">#Make#</TD>
				<td class="labelit" align="right">#numberFormat(DepreciationBase,"__,_.__")#&nbsp;</td>
				
			</TR>
			
			<cfif URL.View eq "Purchase" and PurchaseNo neq "">
			  <cfset p = "regular">
			  <tr><td class="linedotted" colspan="7"></td></tr>
			<cfelse>
			  <cfset p = "hide">
			</cfif>
					
				<cfif p eq "regular">
				    <cfset cnt = cnt+20>
				</cfif>		 	  
				<tr class="#p#" id="d#currrow#" bgcolor="f4f4f4">
				<td height="16"></td>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
						<td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
						<td>#Description#</td>				
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
			  <tr><td colspan="7" class="linedotted"></td></tr>
			<cfelse>
			  <cfset p = "hide">
			</cfif>
						
				<cfif p eq "regular">
				    <cfset cnt = cnt+20>
				</cfif>		  
				<tr class="#p#" id="d#currrow#" bgcolor="f4f4f4">
				<td height="16"></td>
				<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
					<td labelit>#OrgUnitName#</td>				
				</tr>
				</table>
				</td>
				<td>#LocationCode#</td>
				<td></td>
				<td colspan="2">#LocationName#</td>
				</tr>	
				
				<cfif PersonNo neq "">
				
					<cfif p eq "regular">
					    <cfset cnt = cnt+20>
					</cfif>		
					<tr bgcolor="FBFDDF" class="#p#" id="d#currrow#">
					<td height="16"></td>
					<td colspan="6">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr><td width="25"><img src="#SESSION.root#/images/join.gif" alt="" border="0"></td>
					<td width="99%">
					<table width="100%">
					<tr>
					 <td width="50%">&nbsp;&nbsp;#LastName#, #FirstName#</td>
					 <td width="50%">#DateFormat(DateEffective,CLIENT.DateFormatShow)#
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

</tr>

</table>

<cfoutput>
<script language="JavaScript">
	{	
	frm  = parent.document.getElementById("items");
	he = 35+#cnt#;
	frm.height = he;
	}
</script>
</cfoutput>

</BODY></HTML>

