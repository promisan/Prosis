
<cfparam name="URL.Mission" default="SAT">

<cf_dialogOrganization>
<cf_dialogProcurement>
<cf_dialogLedger>
<cf_calendarScript>

<script>

  function applyprogram(prg,scope) {
        _cf_loadingtexthtml='';	
        ptoken.navigate('setProgram.cfm?programcode='+prg+'&scope='+scope,'processmanual')
  }  

</script>	

<cfquery name="Parameter" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_ParameterMission
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Vendor" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OrgUnit, OrgUnitName
	FROM  Organization
	WHERE OrgUnit IN (SELECT OrgUnitVendor 
	                  FROM Purchase.dbo.Purchase 
	                  WHERE Mission='#URL.Mission#')
    ORDER BY OrgUnitName
</cfquery>

<cfquery name="Period" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Period
    FROM Purchase
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfquery name="OrderStatus" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT P.ActionStatus, S.Description 
    FROM   Purchase P, Status S
	WHERE  P.ActionStatus = S.Status	
	AND    S.StatusClass = 'Purchase'
	AND    P.Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Class" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT P.OrderClass, S.Description 
    FROM   Purchase P, Ref_OrderClass S
	WHERE  P.OrderClass = S.Code
	AND    P.Mission = '#URL.Mission#'</cfquery>
	
<cfquery name="OrderType" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT P.OrderType 
    FROM   Purchase P
	WHERE  P.Mission = '#URL.Mission#'
</cfquery>	

<script>

 function toggle() {
 
 	se  = document.getElementById("locatebox")
	btn = document.getElementById("togglebutton")
	
    cnt = 0
 	if (se.className == "regular") {
	    se.className = "hide"
		btn.value = "Show Search"
	 } else {
	    se.className = "regular"
		btn.value = "Hide Search"
	 }
	 
 }
  
 	
</script>

<!--- Search form --->
<cfform action="LocatePurchaseDetail.cfm?Mission=#URL.Mission#&Period=#URL.Period#" method="POST" target="detail"  name="locate">
	
<table width="97%" align="center" class="formpadding">

<tr><td id="locatebox" class="regular">

<table width="97%" cellspacing="0" align="center" class="formpadding">
	
	<TR class="labelmedium2">
	<TD><cf_tl id="Purchase">:</TD>
	<td colspan="1">	
	<table cellspacing="0" cellpadding="0">
	<tr class="labelmedium2">
	<td><input type="text" class="regularxxl" name="purchaseno" id="purchaseno" value="" size="8"></td>
	<td width="6"></td>
	<TD><cf_tl id="Type">:</TD>
	<td width="6"></td>			
	<td align="left" valign="top">
	<select name="ordertype" id="ordertype" size="1" class="regularxxl">
	    <option value="" selected>All</option>
	    <cfoutput query="ordertype">
		<option value="#Ordertype#">#Ordertype#</option>
		</cfoutput>
    </select>
	</td>	
			
	<cfquery name="tPeriod" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	      SELECT R.*, M.MandateNo 
	      FROM   Ref_Period R, Organization.dbo.Ref_MissionPeriod M
	      WHERE  IncludeListing = 1
	      AND    M.Mission = '#URL.Mission#'
		  AND    R.Period IN (SELECT Period FROM Purchase.dbo.Purchase WHERE Mission = '#URL.Mission#')
	      AND    R.Period = M.Period 
	</cfquery>
		
	</tr>
	</table>
	</td>
	<TD><cf_tl id="Issued after">:</TD>
	<TD>	
	 <cf_intelliCalendarDate9
		FieldName="orderdate" 
		class="regularxxl"
		Default=""		
		AllowBlank="True">	
	</TD>
	</tr>
	
	</TR>
	
	<TR class="labelmedium2">
	<TD><cf_tl id="Requisition">:</TD>
	<TD><input type="text" name="requisitionno" id="requisitionno" class="regularxxl" value="" size="20"></TD>	
	<TD><cf_tl id="Period">:</TD>
	
	<td align="left" valign="top">	
	<select name="Period" id="Period" size="1" class="regularxxl">
	    <option value="" selected><cf_tl id="All"></option>
	    <cfoutput query="tPeriod">
		<option value="#Period#" <cfif URL.Period eq Period>selected</cfif> >#Period#</option>
		</cfoutput>
	</select>			
	</td>						
	</tr>
		
	<TR class="labelmedium2">
	<td><cf_tl id="Program">/<cf_tl id="Project"></td>
	<td>
	  
	  <cfoutput>
	  <table>			  
	  <td>
	  <input type="text" name="programdescription" id="programdescription" class="regularxxl" value="" size="40" maxlength="80" readonly 
	  onclick="this.value='';programcode.value=''">
	  <input type="hidden" name="programcode" id="programcode" value="" size="20" maxlength="20" readonly>
	  </td>
	  
	  <td> 
	  	  
	     <img src="#SESSION.root#/Images/select6.jpg"			     
			     id          = "img1"
				 style       = "height:28;border:0px solid silver"			     
				 align       = "absmiddle"
			     style       = "cursor: pointer;"
			     onClick     = "selectprogram('#URL.mission#','','applyprogram','')"
			     onMouseOver = "document.img1_src='#SESSION.root#/Images/select6b.jpg'"
			     onMouseOut  = "document.img1_src='#SESSION.root#/Images/select6.jpg'">	
				 
	  </td>	  
	  <td style="width:25px;height:25px;border:0px solid gray" align="center">
	  	<img src="#SESSION.root#/Images/delete5.gif" style="height:18;border:0px solid silver" align="absmiddle" alt="" border="0" onclick="programdescription.value='';programcode.value=''">
	  </td>	  
	  <td id="processmanual"></td>
	  
	  </tr>
	  </table>
	  </cfoutput>
	  	
	</td>
		
	<TD><cf_tl id="Order Class">:</TD>
			
	<td align="left" valign="top">
	<select name="orderclass" id="orderclass" size="1" class="regularxxl">
	    <option value="" selected><cf_tl id="All"></option>
	    <cfoutput query="class">
		<option value="#OrderClass#">#Description#</option>
		</cfoutput>
	    </select>
	</td>	
	<TD>
	
	</TR>
	
	
	<TR class="labelmedium2">
	<TD title="Vendor Code" style="cursor:pointer"><cf_tl id="Vendor Code">:</TD>
			
	<td align="left"> 
		<cfinput type="Text" class="regularxxl" name="orgunit" validate="integer" required="No" size="10">	
	</td>	
				
	<td align="left"><cf_tl id="Vendor Name">:</td>	
	<td>
	
	  <select name="orgunitvendor" id="orgunitvendor" style="width:160px" size="1" class="regularxxl">
		<option value="" selected><cf_tl id="All"></option>
	    <cfoutput query="Vendor">
			<option value="#OrgUnit#">#OrgUnitName#</option>
		</cfoutput>
	  </select>
	<TD>
		
	</tr>
	
	<cfquery name="Employee" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  Person
		WHERE PersonNo IN (SELECT PersonNo 
		                   FROM   Purchase.dbo.Purchase 
		                   WHERE  Mission='#URL.Mission#')
	    ORDER BY LastName
	</cfquery>
	
	<cfif employee.recordcount gte "1">
	
		<TR class="labelmedium2">
		<TD><cf_tl id="IndexNo">:</TD>
				
		<td align="left"> 
		<cfinput type="Text" class="regularxxl" tooltip="IndexNo" name="indexNo" required="No" size="10">	
		</td>	
						
		<td align="left" class="labelmedium2"><cf_tl id="Employee">:</td>	
		<td>
		  <select name="personno" id="personno" style="width:200px" size="1" class="regularxxl">
			<option value="" selected><cf_tl id="All"></option>
		    <cfoutput query="Employee">
				<option value="#PersonNo#">#FirstName# #LastName#</option>
			</cfoutput>
		    </select>
		<TD>
			
		</tr>
	
	</cfif>
			
	<TR class="labelmedium2">
	<TD><cf_tl id="Order amount">:</TD>
	<TD><SELECT name="amountoperator" id="amountoperator" class="regularxxl">
			<OPTION value="="><cf_tl id="is">
			<option value=">=" selected><cf_tl id="greater than">
			<OPTION value="<="><cf_tl id="smaller than">
		</SELECT>
		<input type="text" name="amount" id="amount" class="regularxxl" value="0" size="10" style="text-align: right;">
		<cfoutput>#APPLICATION.BaseCurrency#</cfoutput>
	</TD>
	
	<TD><cf_tl id="Descriptive">:</TD>
	<TD>	
	<input type="text" name="orderitem" id="orderitem" value="" size="30" class="regularxxl">
	<cfoutput>
	  <img src="#SESSION.root#/Images/delete5.gif" align="absmiddle" alt="" border="0" onclick="document.getElementById('orderitem').value=''">
	</cfoutput> 
	
	</TD>
	
	</TR>
		
	<TR class="labelmedium2">
	<TD><cf_tl id="Obligation Status">:</TD>
	<td align="left" valign="top" class="labelmedium2">
	    <cfif Parameter.InvoicePriorIssue eq "1">
	    <select name="actionstatus" id="actionstatus" size="1" class="regularxxl">
		<option value="">All</option>
	    <cfoutput query="OrderStatus">
			<option value="#ActionStatus#" <cfif ActionStatus eq "3">selected</cfif>>#Description#</option>
		</cfoutput>
	    </select>
		<cfelse>
		<select name="actionstatus" id="actionstatus" size="1" class="regularxxl">
		<cfoutput query="OrderStatus">
			<cfif ActionStatus gte "3">
			<option value="#ActionStatus#" <cfif ActionStatus eq "3">selected</cfif>>#Description#</option>
			</cfif>
		</cfoutput>
	    </select>
		</cfif>
		<font size="2" color="808080">---> <cf_tl id="Closed Obligations may not be selected"></font>
	</td>	
	<TD class="labelmedium2"><cf_tl id="Delivery Status">:</TD>
	<TD><SELECT name="deliverystatus" id="deliverystatus" class="regularxxl">
	       <OPTION value="" selected><cf_tl id="All"> 
	       <OPTION value="0"><cf_tl id="Outstanding">
		   <OPTION value="3"><cf_tl id="Completed"> 
		</SELECT>
		
	</TD>
	</tr>
	
</TABLE>
</td>
</tr>

<tr id="locatebox"><td class="line"></td></tr>

<tr id="locatebox"><td align="center">
   <cfoutput>
   <cf_tl id="Reset" var="rlabel">
	<input type="reset"  class="button10g" style="font-size:14px;width:180px;height:30" value="#rlabel#">
	<cf_tl id="Find" var="slabel">
	<input type="submit" name="search" id="search" style="font-size:14px;width:180px;height:30" value="#slabel#" class="button10g">
	</cfoutput>
</td></tr>

</table>

</cfform>
