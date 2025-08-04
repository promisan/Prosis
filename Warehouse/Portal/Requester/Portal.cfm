<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfoutput>

<cfparam name="URL.Mission" default="Promisan">

<!--- check if access has been granted for this mission to request stuff --->

<cfset access = "ALL">

<cfif access eq "NONE">

	<table align="center"><tr><td height="60">
	   <font face="Verdana" size="2">No access was granted to your account to manage stock request and/or taskorder</font>
	      </td></tr>
	</table>
	<cfabort>

</cfif>

<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#session.login#" 
	password="#session.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>
		
<cfajaximport tags="cfform,cfwindow,cfinput-datefield,cfdiv">

<script src="Cart.js"></script>

<script language="JavaScript" type="text/javascript"> 

w = #client.width# - 70;
h = #client.height# - 160;

function mail2(mode,id) {
	  window.open("#session.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.RequisitionTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}	

function mail3(mode,id) {
	  window.open("#session.root#/Tools/Mail/MailPrepareOpen.cfm?id="+mode+"&ID1="+id+"&ID0=#Parameter.DeliveryTemplate#","_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=no")
}	

function process(id) {
	   window.open("#session.root#/Tools/EntityAction/ActionView.cfm?id=" + id, "_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
}

function hl(c1,c2) {				
		document.getElementById(c1).className = "bannerN2"
		document.getElementById(c2).className = "bannerN2"
		}
		
function sl(c1,c2) {
		document.getElementById(c1).className = "regular"
		document.getElementById(c2).className = "regular"
		}

function search() {		 
	 if (window.event.keyCode == "13") {	
		document.getElementById("find").click() }			
    }		
	
function catsel(cat,row) {		
	 		
	 document.getElementById("category").value = cat	 
	 count = 0
	 tot   = document.getElementById("searchgroup").value
					 				 	   
	   while (count <= tot) {
		   try { 
			   rw = document.getElementById("1_"+count)
			   rw.className = "regular"
			   rw = document.getElementById("2_"+count)
			   rw.className = "regular"
		   	   } catch(e) {}
			   count++ 
		   }
		   
		   document.getElementById("1_"+row).className = "highlight"
		   document.getElementById("2_"+row).className = "highlight"		
			    			
	 list('1')
				
    }			

function list(pg) {
		
	cat = document.getElementById("category").value;		
	fnd = document.getElementById("find").value;
	whs = document.getElementById("warehouse").value;		
	ColdFusion.navigate('ItemList.cfm?mission=#URL.mission#&warehouse='+whs+'&find='+fnd+'&category='+cat+'&page='+pg,'reqmain')	 
}

function view(item) {
	window.open("ItemView.cfm?ID=" + item, "DialogWindow", "status=yes, scrollbars=no, resizable=yes, left=40, top=40, width=600, height=500");
}

function mainmenu(menusel,len) {
	 menu=1;len++ 	 
	 document.getElementById("errorbox").className = "hide"	
	 
     while (menu != (len)) {
	 
	  try {
	 	  	 
		  if (menu == menusel) {
		    document.getElementById("menu"+menu).className = "highlight"
		  } else {
		    document.getElementById("menu"+menu).className = "regular"
		  }
		    
		  se = document.getElementsByName("box"+menu)	  
		  cell = 0 	  
		  
		  while (se[cell]) {	 
		  
		     if (menu == menusel) { 
				se[cell].className = "regular"
			 } else {
			    se[cell].className = "hide"
			 }
			 cell++
			 
		  }	 	  
		  
		 } catch(e) {}
		 
		 menu++			    	 
	 }
}

function submenuselect(subm) { 
	      var count=0;
		  var se  = document.getElementsByName('subm')	  	
		  while (se[count]) {    
		    se[count].className = "submenuregular" 
		    count++;
		  }	
	      subm.className = "submenuselected"	    
	  }
</script>

<style>
/*--------------------------------------------------------*/
/*---------------Sub Menu---------------------------------*/
/*--------------------------------------------------------*/
	td.submenuregular { 
		background-repeat:no-repeat; 
		background-Position:left;
		line-height:13px;
		font-family: Calibri;
		font-size: 13px;
		font-weight:bold;
		color:gray;
		width:81px;
		height:32px;
		cursor:pointer;
		padding-top:5px;
	}
		
	td.submenuselected {
		background-image:url('../../Portal/images/menu/button_bg.png'); 
		background-Repeat:no-repeat; 
		background-Position:left;
		color:white;
		cursor:pointer;
		line-height:14px;
		font-family: Calibri;
		font-size: 14px;
		width:81px;
		height:32px;
		cursor:pointer;
		padding-top:3px;
	}

html,
body {
background-color: transparent;
}

</style>
</cfoutput>



<cfquery name="Item" 
datasource="AppsMaterials" 
username="#session.login#" 
password="#session.dbpw#">
	SELECT Count(*) as total
	FROM Item
</cfquery>

<cfparam name="URL.Status" default="1">
<cfparam name="URL.Mode" default="regular">


<cf_screentop html="no" layout="webapp" scroll="yes" user="no" banner="blank">

<table width="100%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="e4e4e4" bgcolor="transparent">
	<tr>
		<td height="39px" valign="bottom" style="padding-left:50px; background-image:url('<cfoutput>#session.root#</cfoutput>/Warehouse/Portal/Images/menu/bar_bg.png'); background-position:bottom; background-repeat:repeat-x">
			<cfinclude template="Portalmenu.cfm">
		</td>
	</tr>
<tr><td valign="top" bgcolor="white">

<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">
<!---
<tr><td>
<cfinclude template="CartBanner.cfm">
</td></tr>

<tr><td height="1" colspan="2" bgcolor="silver"></td></tr>
--->
<tr>
	<td colspan="3" height="30">
	
	<table width="100%" border="0" cellspacing="3" cellpadding="0">
		
	<cfif url.mode eq "CheckOut">

		<tr><td height="1" colspan="3" bgcolor="white">

	    <cfinclude template="CartCheckout.cfm">
	
		</td></tr>

	<cfelse>
		
		<cfquery name="Cart" 
		datasource="AppsMaterials" 
		username="#session.login#" 
		password="#session.dbpw#">
		SELECT *
		FROM WarehouseCart
		WHERE UserAccount = '#session.acc#'
		</cfquery>
		
		<tr height="65">
			
		<td align="left" height="26" style="padding-left:10px">
		&nbsp;Search for Products<br>
		<INPUT style="width:150px;" NAME="find" onkeyup="search()" TITLE="Enter Criteria" MAXLENGTH="255" VALUE="">&nbsp;
		<cf_tl id="Search" var="1">
		
		<button name="go"
	       value="#lt_text#"
	       class="button3"
	       style="height:20;width:26"
	       onClick="javascript:list('1')">
		   <img src="<cfoutput>#session.root#</cfoutput>/images/go1.gif" alt="" border="0">
		</button>
		</td>
		
		<td align="right" width="20%">
			
		<cfquery name="WarehouseSelect" 
		datasource="AppsMaterials" 
		username="#session.login#" 
		password="#session.dbpw#">
			SELECT   * 
			FROM     Warehouse
			WHERE    Mission = '#URL.Mission#'
			ORDER BY WarehouseDefault DESC
		</cfquery>
		
		<cfparam name="URL.Warehouse" default="">
		
		<!---
		<select name="Warehouse">
			<cfoutput query="WarehouseSelect">
			<option value="#Warehouse#" <cfif URL.Warehouse eq Warehouse>selected</cfif>>#WarehouseName#</option>
			</cfoutput>
		</select>		
		--->
		
		<cfoutput>		
		<input type="hidden" name="warehouse" value="#WarehouseSelect.Warehouse#">
		</cfoutput>

		&nbsp;
		</td>
			
		<cfoutput>		
		<input type="hidden" name="mission" value="#URL.Mission#">
		<input type="hidden" name="category" value="all">
		
		<cfinvoke component="Service.Presentation.Presentation"
		    method="highlight" class="highlight3"
		    returnvariable="stylescroll"/>
			
		<cfset menu = 4>
							
		<td id="menu1"			
			align="center"
			width="120"		   
			style="cursor: hand;"
		    onClick="mainmenu('1','#menu#'); cart()"
			#stylescroll#>
			
			<cfif cart.recordcount neq "0">
			
			    <cfinclude template="CartStatus.cfm">
				
			</cfif>
								
		</td>
						
		<cfquery name="Pending" 
		datasource="AppsMaterials" 
		username="#session.login#" 
		password="#session.dbpw#">
		SELECT     top 1 Reference
		FROM       Request R
		WHERE      R.Status IN ('i','1','2','2b')
		  AND      R.OfficerUserId = '#session.acc#'  
		</cfquery>
				
		<cfif Pending.recordcount gte "1">
		
			<td align="center" id="menu2" width="130" onclick="mainmenu('2','#menu#'); reqstatus('pending'); " #stylescroll#  style="cursor: pointer; padding-top:2px">
			<img src="<cfoutput>#session.root#</cfoutput>/images/view_pending.png" align="absmiddle" alt="" border="0"><br>Pending Requests
			</td>
		
		</cfif>
		
		<cfquery name="Shipped" 
		datasource="AppsMaterials" 
		username="#session.login#" 
		password="#session.dbpw#">
			SELECT     top 1 Reference
			FROM       Request R
			WHERE      R.Status IN ('3')
			  AND      R.OfficerUserId = '#session.acc#'  
		</cfquery>
				
		<cfif Shipped.recordcount gte "1">
		
			<td align="center" id="menu3" #stylescroll# onclick="mainmenu('3','#menu#');reqstatus('shipped')" width="130"  style="cursor: pointer;">
			<img src="<cfoutput>#session.root#</cfoutput>/images/view_history.png" align="absmiddle" alt="Shipped Orders" border="0">	<bR>				
			View History
			</td>
		
		</cfif>
		
		<!--- update --->
		<cfquery name="aDD" 
		datasource="AppsMaterials" 
		username="#session.login#" 
		password="#session.dbpw#">
		INSERT INTO ItemTransactionShipping
				(TransactionId,OfficerUserId,OfficerLastName,OfficerFirstName)
		SELECT  TransactionId, '#session.acc#','#session.last#','#session.first#'
		FROM    ItemTransaction
		WHERE   TransactionType = '2'
		AND     TransactionId NOT IN (SELECT TransactionId FROM ItemTransactionShipping)
		</cfquery>		
				
		<cfquery name="Shipping" 
		datasource="AppsMaterials" 
		username="#session.login#" 
		password="#session.dbpw#">
			SELECT     IT.*
			FROM       ItemTransaction IT INNER JOIN
			           ItemTransactionShipping S ON IT.TransactionId = S.TransactionId INNER JOIN
			           ItemUoM U ON IT.ItemNo = U.ItemNo AND IT.TransactionUoM = U.UoM INNER JOIN
			           Request R ON IT.RequestId = R.RequestId INNER JOIN
			           Item ON IT.ItemNo = Item.ItemNo INNER JOIN
			           RequestHeader H ON R.Reference = H.Reference 
			WHERE      1=1
			<cfif Parameter.UnitConfirmation eq "1">
				AND 		(
				            R.OfficerUserId = '#session.acc#' 
							OR
							H.OrgUnit IN (SELECT UserAccount 
							              FROM   Organization.dbo.OrganizationAuthorization 
										  WHERE  UserAccount = '#session.acc#'
										  AND    Role = 'ReqClear')   
							)			      
			<cfelse>
				AND 		R.OfficerUserId = '#session.acc#'
			</cfif>
			
			AND        (S.ActionStatus = '0' or S.ConfirmationDate > getdate()-1)
		</cfquery>
		
		<cfif Shipping.recordcount gte "1">
						
			<td align="center" id="menu4" width="130" #stylescroll# onclick="mainmenu('4','#menu#');shipstatus('#url.mission#')"  style="cursor: hand;">
			<img src="<cfoutput>#session.root#</cfoutput>/images/confirm_delivery.png" 
			     align="absmiddle" 
				 alt="" 
				 border="0">		<br>
				 Confirm Delivery				
			</td>
		
		</cfif>		
				
		</cfoutput>
			
		</tr>
		
		</table>
	
	</tr>
	
	<tr><td height="1" colspan="3" bgcolor="silver"></td></tr>
		
		<tr>
		
		<td align="left" width="40%" valign="top" style="border-bottom: 1px solid Silver;">
		
		 	<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" bordercolor="e4e4e4">
		  	 
		    <tr><td width="200" height="20"><b>&nbsp;&nbsp;<cf_tl id="My">&nbsp;<cf_tl id="top">&nbsp;5&nbsp;<cf_tl id="products">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td></tr>
			<tr><td height="1" bgcolor="silver"></td></tr>
			<tr><td>
		
				<cfquery name="top5" 
				datasource="AppsMaterials" 
				username="#session.login#" 
				password="#session.dbpw#">
					SELECT     TOP 5 Request.ItemNo, Request.UoM, 
					           COUNT(*) AS total, Item.ItemDescription
					FROM       Request INNER JOIN
					           Item ON Request.ItemNo = Item.ItemNo
					WHERE      Request.OfficerUserId = '#session.acc#'
					GROUP BY   Request.ItemNo, Request.UoM, Item.ItemDescription
					ORDER BY   COUNT(*) DESC
				</cfquery>
			
				<table width="100%" height="100%" border="0" cellspacing="1" cellpadding="1" align="left">
				   
				   <tr><td height="1"></td></tr>
					   
				   <cfoutput query="top5">
					    <tr><td height="1" colspan="2"></td></tr>
						<TR>
							<td width="20" align="center"><img src="#session.root#/images/pointer.gif" alt="#ItemDescription#" border="0"></td>
						   	<td height="25" class="regular">
							<A href="javascript:add('#itemno#','#uom#')">#ItemDescription#</td>
						</TR>					
				   </cfoutput>
				 
				</table> 
			
			</td></tr>
				
			</table>  
					       
		</td>
		
		<td width="59%"
		    align="right"
		    valign="top"
		    style="border-left: 1px solid Silver;border-bottom: 1px solid Silver;">
		
		    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="right" bordercolor="e4e4e4">
		   
			    <tr><td height="20"><b>&nbsp;&nbsp;<cf_tl id="List Items"> <cf_tl id="by category"></b></td></tr>
				
				<tr><td height="1" bgcolor="silver"></td></tr>
							
				<cfquery name="SearchGroup" 
				datasource="AppsMaterials" 
				username="#session.login#" 
				password="#session.dbpw#">
					SELECT   DISTINCT C.Category AS Category, C.Description as Description
					FROM     Ref_Category C
					UNION 
					SELECT   DISTINCT 'All' AS Category, 'All categories' as Description
					ORDER BY Description
				</cfquery>
				
				<cfoutput>
					<input type="hidden" name="searchgroup" value="#searchgroup.recordcount#">
				</cfoutput>
				
				<tr><td>
				     <table width="100%" cellspacing="0" cellpadding="0">     		 
			          <cfoutput query="SearchGroup">
					  <cfif CurrentRow Mod 2><TR></cfif>
			            <td id="1_#Currentrow#" class="regular">
							&nbsp;<img src="#session.root#/images/point_small.JPG" align="absmiddle" alt="" width="10" height="11" border="0">
						</td>
			        	<td class="regular"
						    id="2_#Currentrow#"
						    style="cursor: hand;"
						    onClick="javascript:catsel('#Category#','#currentRow#')">
						    #Category#
						</td>
			          <cfif CurrentRow Mod 2><cfelse></tr>
						  <cfif CurrentRow neq Recordcount>
							  <tr><td colspan="4" bgcolor="E5E5E5"></td></tr>
						  </cfif>
					  </cfif>
			          </cfoutput>		
					  </table>     
				 </td></tr>	 
				 
			 </table>
			
		</td>		
		</tr>	
	
	    <tr><td colspan="4"><cfdiv id="reqtop"></td></tr>		
		
		<tr><td colspan="4">	
		
		<cfdiv id="reqmain">	
		
			<cfif URL.Mode eq "history">
			     <cfinclude template="HistoryList.cfm">
			<cfelseif URL.Mode eq "Cart">
			     <cfinclude template="Cart.cfm">   
			</cfif>		
			
		</cfdiv>
		
		</td></tr>
				
</cfif>	

</table>

</td></tr>
<tr id="errorbox" class="hide">
	  <td id="errorcontent" align="center" bgcolor="red"></td>
</tr>
