<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Generic Logon</proDes>
25sep07 - changed input button to use class="input.button1".
 <proCom>Changed release no</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!---
	Travel/Maintenance/Access/UserActionAdd.cfm
	
	Add user action profile records

	Calls:  UserActionAddSubmit.cfm
	
	Modification history:
	25sep07 - changed input button to use class="input.button1".
--->			
<HTML><HEAD>
	<TITLE>User Action Profile - Entry Form</TITLE>
</HEAD>
<link href="../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<CFOUTPUT>	

<script>

function selectall(chk,val)
{

var count=1;

var itm = new Array();
while (count < 99)
      
   {    
				 
	 itm2  = 'Selected_'+count
	 var fld = document.getElementsByName(itm2)
  	 var itm = document.getElementsByName(itm2)
	 fld[val].checked = true;
	 			
     if (ie){
	      itm1=itm[val].parentElement; 
		  itm1=itm1.parentElement; 
		  }
     else{
          itm1=itm[val].parentElement; 
		  itm1=itm1.parentElement; }		
	
	 if (val == "1"){
		
	 itm1.className = "highLight";
	 }
	 
 	 if (val == "2"){
		
	 itm1.className = "deny";
	 }
	 
	 if (val == "0"){
		
	 itm1.className = "regular";
	 }	
	
	
    count++;
   }	

}

function reloadForm(mission)
{

     window.location="UserActionAdd.cfm?ID=#URL.ID#&IDMission=" + mission;
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,val){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 if (val == "1"){
		
	 itm.className = "highLight";
	 }
	 
 	 if (val == "2"){
		
	 itm.className = "deny";
	 }
	 
	 if (val == "0"){
		
	 itm.className = "regular";
	 }
  }

</script>
</CFOUTPUT>

<body onload="javascript: window.focus(); document.forms.action.mission.focus();">

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Mission 
    FROM Ref_Mission
	WHERE MissionStatus = '1'
</cfquery>

<cfif Mission.recordcount gt "0">
   <cfoutput query="Mission" maxrows=1>
    <cfparam name="URL.IDMission" default="All Missions">
   </cfoutput>
<cfelse>
    <cfparam name="URL.IDMission" default="All Missions">   
</cfif>   

<CF_DropTable dbName="#CLIENT.DataSource#" tblName="tmp#SESSION.acc#Action">

<cfquery name="ActionUser" 
datasource="#CLIENT.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT ActionId as CurrentAssigned, AccessLevel 
INTO tmp#SESSION.acc#Action
FROM ActionAuthorization U
WHERE U.UserAccount = '#URL.ID#'
AND U.Mission = '#URL.IDMission#'
</cfquery>

<cfquery name="Action" 
datasource="#CLIENT.DataSource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

SELECT DISTINCT A.*, T.*, C.Description as ActionClassDescription
FROM FlowAction A, 
LEFT JOIN tmp#SESSION.acc#Action T ON  A.ActionId = T.CurrentAssigned
LEFT JOIN FlowClass C ON A.ActionClass = C.ActionClass
WHERE    
A.Operational = 1
ORDER BY A.ActionClass, A.ActionOrder



--SELECT DISTINCT A.*, T.*, C.Description as ActionClassDescription
--FROM FlowAction A, tmp#SESSION.acc#Action T, FlowClass C
--WHERE    A.ActionId *= T.CurrentAssigned
--AND      A.ActionClass = C.ActionClass
--AND      A.Operational = 1
--ORDER BY A.ActionClass, A.ActionOrder
</cfquery>

<CF_DropTable dbName="#CLIENT.DataSource#" tblName="tmp#SESSION.acc#Action">

<!--- Entry form --->
<cfoutput>
<form action="UserActionAddSubmit.cfm?ID=#URL.ID#&IDMission=#URL.IDMission#" method="POST" enablecab="No" name="action">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr>
  	<td height="30" valign="middle" class="label">&nbsp;
	
    <select name="mission" 
	style="background: #6688aa; font-style: normal; border: thin none; font-family: Tahoma; font-stretch: normal; font-weight: bold; color: ButtonHighlight; font-size: larger;" accesskey="P" 
	title="Parent Selection" 
	onChange="javascript:reloadForm(this.value)">
	
	<option value="All Missions" <cfif "All Missions" is '#URL.IDMission#'>selected</cfif>>
	[Access all Missions]
	</option>
		  
    <cfoutput query="Mission">
	<option value='#Mission#' <cfif #Mission# is '#URL.IDMission#'>selected</cfif>>
	#Mission#
	</option>
	</cfoutput>
    </select>
	&nbsp;
	
	<td class="label" align="right">
	<INPUT class="input.button1" type="submit" value="Submit">
	<CF_DialogHeaderSub 
MailSubject="Access" 
MailTo="" 
MailAttachment="" 
ExcelFile=""
CloseButton="Yes"> 
	
	</td>
	
  </tr>
  </td>
	
  </tr> 	
 
  <tr>
    <td width="100%" colspan="2">
    <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
	
    <TR bgcolor="6688aa">
      
	   <td width="35" height="15" class="top">&nbsp;View

	   <input type="radio" name="ShowSelect" value="0" onClick="javascript:selectall(this.value,'0');"> 
	   </td>
	   <TD width="35" height="15" class="top">Edit
	   <input type="radio" name="ShowSelect" value="1" onClick="javascript:selectall(this.value,'1');"> 
	   </TD>
	   <TD width="35" height="15" class="top">Hide
	   <input type="radio" name="ShowSelect" value="9" onClick="javascript:selectall(this.value,'2');"> 
	   </TD>
       <TD class="top">Action description</TD>
       <TD class="top">Area</TD>
   </TR>

   <cfset module = "">
   <cfset CLIENT.recordNo = 0>
  
   <cfoutput query="Action" group="ActionClass">
   
   <tr><td colspan="5" class="header">
   
   #ActionClassDescription#</td></tr>
   <cfoutput>
   
   <cfset CLIENT.recordNo = #Client.recordNo# + 1>
   <input type="hidden" name="actionid_#CLIENT.recordNo#" value="#ActionId#">
	   
   <cfif #AccessLevel# is '' or #AccessLevel# is '0'>
        <cfset status = "0">
   <cfelse>
       	<cfset status = #AccessLevel#>	
   </cfif>
   
   <cfif #status# eq '' or #Status# eq "0">
      <TR bgcolor="white">
   <cfelseif #Status# eq "9">
      <TR class="deny">
   <cfelse>
      <tr class="highLight">
   </cfif>   
     
   <cfif Status eq "0">
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="0" checked onClick="hl(this,this.checked,this.value)"></td>
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="1" onClick="hl(this,this.checked,this.value)"></td>
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="9" onClick="hl(this,this.checked,'2')"></td>
   <cfelseif Status eq "1">
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="0" onClick="hl(this,this.checked,this.value)"></td>
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="1" checked onClick="hl(this,this.checked,this.value)"></td>
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="9" onClick="hl(this,this.checked,'2')"></td>
   <cfelseif Status eq "9">  
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="0" onClick="hl(this,this.checked,this.value)"></td>
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="1" onClick="hl(this,this.checked,this.value)"></td>
      <td><input type="radio" name="Selected_#CLIENT.recordNo#" value="9" checked onClick="hl(this,this.checked,'2')"></td>
   </cfif>
  	  
      </TD>
      <TD><font face="Tahoma" size="1">#ActionDescription#</font></TD>
      <TD><font face="Tahoma" size="1">#ActionArea#</font></TD>
   </TR>
   
   </cfoutput>

   </CFOUTPUT>

</TABLE>
</td>
</table>

<hr>

<input class="input.button1" type="button" value="   Cancel  " onClick="window.close()">
<INPUT class="input.button1" type="submit" value="Submit Data">
	
</FORM>

</BODY></HTML>