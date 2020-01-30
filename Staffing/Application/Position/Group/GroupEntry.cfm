<HTML><HEAD>
<TITLE>Position group - Entry Form</TITLE>
</HEAD><body bgcolor="#FFFFFF">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<script>

function showfile(name)
{
	window.open("GJP/" + name + ".doc", "DialogWindow", "width=800, height=600, status=yes,toolbar=yes, scrollbars=yes, resizable=yes");
}


ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight4";
	 }else{
		
     itm.className = "regular";		
	 }
  }

</script>

<script language="JavaScript">
javascript:window.history.forward(1);
</script>

<cfquery name="GroupAll" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
SELECT F.*, S.PositionNo
FROM PositionGroup S RIGHT OUTER JOIN Ref_Group F ON S.PositionGroup = F.GroupCode
   AND S.PositionNo = '#Form.PositionNo#'
   AND S.Status <> '9'
 WHERE F.GroupCode IN (SELECT GroupCode FROM Ref_Group WHERE GroupDomain = 'Position')
</cfquery>
 
<form action="GroupEntrySubmit.cfm" method="POST" name="groupentry">

<cfinclude template="../Position/PositionViewHeader.cfm">
 
<table width="99%" border="1" cellspacing="0" cellpadding="0" align="center">

<tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
				
<cfoutput query="GroupAll">

<cfif #CurrentRow# MOD 2><TR></cfif>
		<td width="50%" class="regular">
		<table width="100%">
						
<cfif #PositionNo# eq "">
          <TR class="regular">
<cfelse>  <TR class="highlight4">
</cfif>
    <td width="2"></td>
	<TD width="60%">#Description#</TD>
	<td width="20%" align="right">
	<cfif PositionNo eq "">
	<input type="checkbox" name="positiongroup" value="#GroupCode#" onClick="hl(this,this.checked)"></td>
	<cfelse>
	<input type="checkbox" name="positiongroup" value="#GroupCode#" checked onClick="hl(this,this.checked)"></TD>
    </cfif>
	
	</table>
	</td>
	
	<cfif #CurrentRow# MOD 2><cfelse></TR></cfif> 	

</CFOUTPUT>

</table>
  
</td></tr>

<tr><td height="25" align="right">

    <input type="submit" name="Submit" value=" Submit " class="button7">
    <input type="reset"  name="reset" value="  Reset  " class="button7">
	<input type="hidden" name="positionno" value="<cfoutput>#URL.ID#</cfoutput>">&nbsp;
	
</td></tr>

</table>
 
</form>

</BODY></HTML>