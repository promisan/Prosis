
<cfset fcolor = "002350">

<cf_dialogStaffing>
<cf_listingscript>
<cf_submenuleftscript>

<cfinclude template="../../Organization/Access/UserAccessListingScript.cfm">

<cfoutput>

<script>

// function accessSet(acc) {
// 	window.open("UserAccessSet.cfm?ID=" + acc, "right");
// }						

function resetpw() {    
	ptoken.navigate('#SESSION.root#/System/UserPasswordView.cfm?ID=#URL.ID#', 'contentbox');
}	

function audit(acc) {
     ptoken.open("Audit/UserAuditView.cfm?ts="+new Date().getTime()+"&ID=" + acc, "right");
}

function activity(acc) {
    ptoken.navigate('Audit/UserAuditView.cfm?ID=#URL.ID#','contentbox');     
}

function portal(acc) {
    ptoken.navigate('UserPortal.cfm?ID=#URL.ID#','contentbox');     
}

function group(acc) {  
    ptoken.navigate('#SESSION.root#/System/Access/Membership/UserMember.cfm?ID=#URL.ID#','contentbox');  
}

function variant() {
    ptoken.navigate('../Variant/ReportVariant.cfm?ID=#URL.ID#','contentbox');         
}

function purge(off) {
		if (confirm("Do you want to remove access as granted by this administrator ?")) {
			ptoken.navigate('#SESSION.root#/system/organization/access/UserAccessListingPurge.cfm?id=#URL.ID#&officeruserid='+off,'contentbox1')
		}
}

<!--- ----------- --->
<!--- open report --->
<!--- ----------- --->

function schedule(id) {
	    w = #CLIENT.width# - 35;
	    h = #CLIENT.height# - 30;
		ptoken.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?id=" + id + "&context=embed", id);
	}

function orgrole(acc) {  
    ptoken.navigate('../../Organization/Access/UserAccessListing.cfm?ID=#url.id#','contentbox');      
}
	
<!--- ----- --->	
<!--- audit --->
<!--- ----- --->
	
function month(mode,date) {
     Prosis.busy('yes')
	 _cf_loadingtexthtml='';	
	 ptoken.navigate('#SESSION.root#/System/Access/User/Audit/UserOnLine.cfm?id=#url.id#&mode='+mode+'&date='+date,'contentbox1')
}
	
function maximize(itm) {
	 	
	 se   = document.getElementsByName(itm)
	 icM  = document.getElementById(itm+"Min")
	 icE  = document.getElementById(itm+"Exp")
	 count = 0
			 
	 if (icM.className == "regular") {
			
		 icM.className = "hide";
		 icE.className = "regular";
		 
		 while (se[count]) {
		   se[count].className = "hide"
		   count++ }
		 
		 } else {
		 	 
		 while (se[count]) {
		 se[count].className = "regular"
		 count++ }
		 icM.className = "regular";
		 icE.className = "hide";	
		 }		
 }	
		
function clearno() { 
		document.getElementById("find").value = "" 
	}

function search() {

	se = document.getElementById("find")
	 if (window.event.keyCode == "13")
		{	document.getElementById("locate").click() }				
    }
  

<!--- ------------- --->
<!--- membership--- --->
<!--- ------------- --->		
				
	function mhl(itm,fld,row){
		
		 itm = document.getElementById(row)
					 	 		 	
		 if (fld != false){
			 itm.className = "highLight2 labelmedium";		 
		 }else{	 
			 itm.className = "labelmedium";		
	  	 }
	  }
	  
	function memberpurge(grp) {
	  
		if (confirm("Do you want to revoke membership ?")) {
		    ptoken.navigate('#SESSION.root#/System/Access/Membership/MemberPurge.cfm?acc=#URL.ID#&ID1='+grp+'&mode=user','member')
		   	} 
		}

			
	function searchgroup() {
				 
		 if (window.event.keyCode == "13") {	
		     filterme()				    
		 }
		} 
		 
	function filterme() {
		   
		 se = document.getElementById("criteria")				 		 			
		 if (se.value != "") {					 	
		     ptoken.navigate('#SESSION.root#/System/Access/Membership/MemberSelectDetail.cfm?id=#URL.id#&find='+se.value,'myfilter')				 
		 } else {		     
			 ptoken.navigate('#SESSION.root#/System/Access/Membership/MemberSelect.cfm?id=#URL.id#','myfilter') 
		 }
		 }	 						
   		
</script>

<table height="98%" width="100%" border="0" cellspacing="0" cellpadding="0">

</cfoutput>

<cfquery name="User" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   UserNames
    WHERE  Account = '#URL.ID#'
</cfquery>


<cfif User.AccountType eq "Individual">

	<tr><td height="10px">
		<cfset heading = "Group">
		<cfset module = "'System'">
		<cfset selection = "'UserMaintain'">
		<cfset menuclass = "'Group'">
		<cfinclude template="../../../Tools/SubmenuLeft.cfm">
	</td></tr> 

</cfif>

<tr><td height="10px">

<cfset heading = "Authorization">
<cfset module = "'System'">
<cfset selection = "'UserMaintain'">
<cfset menuclass = "'Access'">
<cfinclude template="../../../Tools/SubmenuLeft.cfm">

</td></tr> 

<tr><td height="10px">
<cfset heading = "Audit Trail">
<cfset module = "'System'">
<cfset selection = "'UserMaintain'">
<cfset menuclass = "'Logging'">
<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr> 

<tr><td height="10px">
<cfset heading = "Utilities">
<cfset module = "'System'">
<cfset selection = "'UserMaintain'">
<cfset menuclass = "'Utility'">
<cfinclude template="../../../Tools/SubmenuLeft.cfm">
</td></tr> 

<tr>
	<td>
	</td>
</tr>

</table>

