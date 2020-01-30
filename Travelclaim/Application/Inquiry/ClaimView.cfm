<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML><HEAD>
    <TITLE>Claim - Search Form</TITLE>
</HEAD>
<cf_dialogStaffing>
<cf_systemscript>
<cfoutput>

<script type="text/javascript">

        function reload(fld,val) {
		
		se = document.getElementById(fld)
		se.value = val
		search()
		}

        function more(line)	{
			se = document.getElementById(line)
			
			if (se.className == "regular") {
			se.className = "hide"
			} else {
			se.className = "regular"
			}
		}

		function check() {

		if (window.event.keyCode == "13") { search() }
			}	

		w = #CLIENT.width# - 70;
		h = #CLIENT.height# - 160;

		function showclaim(id0,id1,id2)	{
			   window.open("../FullClaim/FullClaimView.cfm?home=close&ClaimId="+id1+"&RequestId="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
			}
			
		function showclaimother(id1,id2) {
 	    window.open("../ClaimEntry/ClaimEntry.cfm?home=close&PersonNo=#URL.PersonNo#&ClaimId="+id1+"&RequestId="+id2,"_blank", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=yes, scrollbars=yes, resizable=yes");
        }	
			 			   
		function search() {
				
				unt = document.getElementById("orgunit")
				out = document.getElementById("exportno")
				trv = document.getElementById("autno")
				clm = document.getElementById("claimno")
				doc = document.getElementById("documentno")
				emp = document.getElementById("employee")
				des = document.getElementById("description")
				se1 = document.getElementById("selectiondate1")
				se2 = document.getElementById("selectiondate2")
				tr1 = document.getElementById("traveldate1")
				tr2 = document.getElementById("traveldate2")
				sta = document.getElementById("status")
				exc = document.getElementById("claimexception")
				url = 'ClaimViewDetails.cfm?ts='+new Date().getTime()+
				             '&trv='+trv.value+
				             '&clm='+clm.value+
							 '&doc='+doc.value+
							 '&unt='+unt.value+
							 '&emp='+emp.value+
							 '&des='+des.value+
							 '&se1='+se1.value+
							 '&out='+out.value+
							 '&se2='+se2.value+
							 '&tr1='+tr1.value+
							 '&tr2='+tr2.value+
							 '&exc='+exc.value+
							 '&sta='+sta.value
							 
				ColdFusion.navigate(url,'details')			 			
										
				}
			
			
			
	
</script>

</cfoutput>

<div class="screen">

<cfform action="" method="POST" name="locate">

<body bgcolor="#FFFFFF" leftmargin="3" topmargin="4" rightmargin="3" bottommargin="3">

<table width="100%" border="0" frame="hsides" cellspacing="1" cellpadding="0" align="left" bordercolor="e4e4e4">
    <tr>
	<td width="100%" align="center">
	<table width="100%" cellspacing="1" cellpadding="1">
	<td width="2"></td>
	<td><b>
	<cf_helpfile code       = "TravelClaim" 
		    id          = "Inquiry" 
			display     = "Both"	
			color       = "black">
			<!--- displayText = "Travel request and Claim Inquiry " --->
	</td>
	<script language="JavaScript">
	
	function toggle(itm,act) {
	 se = document.getElementById("search")
	if (act == "hide") {
	   
		se.className = "hide"
		se = document.getElementById("img1")
		se.className = "hide"
		se = document.getElementById("img2")
		se.className = "regular"
	} else {
	  	se.className = "regular"
		se = document.getElementById("img2")
		se.className = "hide"
		se = document.getElementById("img1")
		se.className = "regular"
	}
	}
		
	</script>
	<td align="right">
	<cfoutput>
	<img src="#SESSION.root#/Images/up6.gif" alt="Filter options" name="img1" id="img1" border="0" align="absmiddle" class="regular" style="cursor: hand;" onClick="toggle(this,'hide')">
	<img src="#SESSION.root#/Images/down6.gif" alt="Filter options" onclick="toggle(this,'show')" class="hide" style="cursor: hand;" align="absmiddle" id="img2" border="0">
	</cfoutput>
	</td>
	</table>	
</tr>

<tr><td height="1" bgcolor="C0C0C0"></td></tr>

<tr>

<cfquery name="Status" 
	 datasource="AppsTravelClaim" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM Ref_Status
	 WHERE StatusClass = 'TravelClaim'
</cfquery>


<cfquery name="Unit" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Organization
	 WHERE  Mission = '#Parameter.TreeUnit#'	
	 AND    DateEffective < getdate()
	 AND    DateExpiration > getDate()
	 AND    ParentOrgUnit = ''	
</cfquery>

<cf_dialogOrganization>

<td colspan="2">	

<table width="99%" align="center" cellspacing="2" cellpadding="2" id="search">

	<TR>
	<TD>&nbsp;Travel Requested by:</TD>
	<TD>	
	<select name="orgunit">
	
	<cfinvoke component="Service.AccessGlobal"  
	      method="global" 
		  role="AdminTravelClaim" 
		  returnvariable="ManagerAccess">
	
	<cfif ManagerAccess eq "EDIT" or ManagerAccess eq "NONE" or ManagerAccess eq "READ" or ManagerAccess eq "ALL">
		<option value="">All</option>
	</cfif>
	
	<cfoutput query="Unit">
		
		<cfinvoke component="Service.Access"  
		   method="travelclaimofficer" 
		   orgunit="#OrgUnit#" 
		   role="'SSTravelClaim','InqTravelClaim'"
		   returnvariable="access">	
		   
		<cfif access neq "NONE">   
			<option value="#OrgUnit#">#OrgUnitName#</option>
		</cfif>
		
	</cfoutput>
	</select>
		 
	</TD>
		
	<TD>&nbsp;Travel Authorization No (TVRQ):</TD>
	<TD>	
		 	<input type="text" name="autno" size="7"  onKeyUp="check()">
	</TD>
	
	<TD></TD>
	<TD>
			
	</TD>
	</tr>

	<TR>
	<td>&nbsp;Travel Claim status:</td>
	<td>
	 <select name="status" size="1">
		<option value=":2:" selected>TCP Submitted Claims</option>
		<option value=":3:">Cleared for IMIS upload</option>
		<option value=":0:">Pending, NOT in preparation</option>
		<option value=":1:">Pending, IN preparation</option>
		<option value=":4:,:4c:,:5:,:6:">Claim in IMIS</option>
		<option value=":4i:">Rejected by Portal Interface</option>
		<option value=":6:">Processed outside Portal</option>
		<option value=":9:">Removed from IMIS</option>
		<option value="">All</option>
		<!---
		<cfoutput query="Status">
	    <option value="#Status#">#Description#</option>
		</cfoutput>
		--->
	  </select>
		
	</td>
		
	<TD>&nbsp;IMIS Travel Voucher No:</TD>
	<TD>	
		 	<input type="text" name="claimno" size="7" onKeyUp="check()">
	</TD>
	
	<TD></TD>
	<TD>
			
	</TD>
	</tr>
	
	<TR>
	<TD width="200">
	&nbsp;Staff member (Index or Name):	 
	</TD>
	<TD>	
		 <cfinput type="text" tooltip="You may enter a firstname, lastname, indexNo or part of it" name="employee" size="24" maxlength="30" onKeyUp="check()">
		
	</TD>
	
	<TD>&nbsp;TCP Number:</TD>
	<TD>	
		 	<input type="text" name="documentno" size="7" onKeyUp="check()">
	</TD>
	
	</tr>
	
	<TR>
	<TD>&nbsp;Authorization remarks (full search):</TD>
	<TD>	
		 	<input type="text" name="description" size="24" maxlength="30" onKeyUp="check()">
	</TD>
	
	<td>&nbsp;Validation status:</td>
	<td>
	 <select name="claimexception" size="1">
		<option value="" selected>All</option>
		<option value="0">Complete</option>
		<option value="1">Incomplete</option>
	  </select>
		
	</td>
			
	</TD>
	</tr>

	
	<!---
		
	<TR>
	
		<TD>&nbsp;Unit:</TD>
				
		<td>
		
		<cfparam name="URL.ID2" default="m">
		<cfparam name="URL.ID3" default="m">
		
			<cfoutput>
			
				<input type="text" name="orgunitname" value="" class="regular" size="50" maxlength="60" readonly>
				<input type="button" class="button7" name="search" value=" ... " 
				onClick="selectorgmis('locate','orgunit','orgunitcode','mission','orgunitname','orgunitclass','#URL.ID2#','#URL.ID3#','')"> 
				<input type="hidden" name="orgunit" value="">
				<input type="hidden" name="orgunitcode"  value=""> 
				<input type="hidden" name="orgunitclass" value=""> 
				<input type="hidden" name="mission"      value=""> 
				
			</cfoutput>	
		
		</td>	
		
		<TD>Location:</TD>
				
					
	</TR>
	
	--->
			
	</tr>
	
	<TR>
	<td>&nbsp;Submission between:&nbsp;</td>
	   <td>
	   <table cellspacing="0" cellpadding="0">
		<tr><td>
	 	<cf_intelliCalendarDate
			FieldName="selectiondate1" 
			Default=""
			Class="regularH"
			AllowBlank="True">	
			</td>
			<td> - &nbsp;</td>
			<td>
			<cf_intelliCalendarDate
			FieldName="selectiondate2" 
			Default=""
			Class="regularH"
			AllowBlank="True">	
			</td>
		</tr>	
	   </table>
	</td>
	
	<td colspan="1">	&nbsp;Export No:</td>
	<td>
	 	<input type="text" name="exportNo" size="4" maxlength="4" onKeyUp="check()">
		
	</td>
	
	</tr>
	
	<TR>
	<td>&nbsp;Travelling between:&nbsp;</td>
	   <td>
	   <table cellspacing="0" cellpadding="0">
		<tr><td>
	 	<cf_intelliCalendarDate
			FieldName="traveldate1" 
			Default=""
			Class="regularH"
			AllowBlank="True">	
			</td>
			<td> - &nbsp;</td>
			<td>
			<cf_intelliCalendarDate
			FieldName="traveldate2" 
			Default=""
			Class="regularH"
			AllowBlank="True">	
			</td>
		</tr>	
	   </table>
	</td>
	
	<td colspan="1">	</td>
	<td>
	 	
		
	</td>
	
	</tr>
		
<tr><td colspan="5" bgcolor="e4e4e4"></td></tr>
<tr>
<td colspan="5" HEIGHT="25" align="center">
<input type="reset"  class="button10g" value="Reset">
<input type="button" name="Submit" value="Search" class="button10g" onclick="javascript:search()">
</td></tr>

</TABLE>
</td>
<tr>
  <td><cfdiv id="details"></td>
</tr>
</tr>

</table>

</cfform>

</div>

</BODY></HTML>

