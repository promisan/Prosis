
<cfparam name="URL.Mode" default="Event">

<cfif url.mode eq "Bucket">	
	<cfset html= "Yes">
<cfelse>
	<cfset html = "No">
</cfif>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  html="#html#" 
			  label="Retrieve a candidate" 
			  layout="webapp" 
			  jQuery="Yes" 
			  close = "parent.ColdFusion.Window.hide('CandidateSearchWindow')">

<cfparam name="URL.Id" default="">

<cf_dialogStaffing>

<cfoutput>
<script language="JavaScript">

function documentadd(per){
    w = #CLIENT.width# - 100;
    h = #CLIENT.height# - 150;
	_cf_loadingtexthtml='';		
	ptoken.open("DocumentEdit.cfm?mode=add&refer=workflow&personno="+per, "eventdialog", "left=30, top=30, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=no");	
} 

</script>
</cfoutput>

<!--- Search form --->

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfquery name="Nationality" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Nation
	WHERE  Name != ''
</cfquery>
	
<tr><td height="60" style="padding:10px" valign="top">

<cfform style="height:100%" name="myform" method="POST" target="detail" >

	<table height="100%" width="98%" align="center" class="formpadding formspacing">
			
		<TR>
		<TD class="labelmedium"><cf_tl id="Last name">:</TD>
		<TD>	
		<input type="text" class="regularxl" name="LastName" value="" size="20">
		</TD>
		<TD class="labelmedium"><cf_tl id="First name">:</TD>
		<td colspan="1">	
		<input type="text" class="regularxl" name="FirstName" value="" size="20">
		</td>
		
		</tr>
		
		</TR>
			
		<TR>
		<TD class="labelmedium"><cf_tl id="Nationality">:</TD>
				
		<td align="left">
		<select name="nationality" class="regularxl" size="1">
		    <option value="" selected>All</option>
		    <cfoutput query="Nationality">
			<option value="#Code#">#Name#</option>
			</cfoutput>
	    </select>
		</td>	
			
		<TD class="labelmedium"><cf_tl id="Gender">:</TD>
				
		<td align="left" class="labelmedium">
			<table>
			<tr class="labelmedium">
			<td style="padding-left:0px"><input type="radio" name="Gender" value="M"></td>
			<td style="padding-left:3px"><cf_tl id="Male"></td>
			<td style="padding-left:4px"><input type="radio" name="Gender" value="F"></td>
			<td style="padding-left:3px"><cf_tl id="Female"></td>
			<td style="padding-left:4px"><input type="radio" name="Gender" value="" checked></td>
			<td style="padding-left:3px"><cf_tl id="Either"></td>
			</tr>
			</table>
		</td>	
		<TD>
		
		</TR>
		
		<TR>
		<TD class="labelmedium"><cf_tl id="Age">:</TD>
				
		<td align="left" valign="top" class="labelmedium">
		between
		<cfinput type="Text" class="regularxl" name="agefrom" value="20" validate="integer" style="text-align: center;" required="No" size="2"> -
		<cfinput type="Text" class="regularxl" name="ageto" value="65" validate="integer" style="text-align: center;" required="No" size="2"> years
		</td>	
		<TD class="labelmedium"><cf_tl id="Index No">:</TD>
				
		<td align="left" valign="top">
		   <cfinput type="Text" class="regularxl" name="IndexNo" style="text-align: center;" required="No" size="10">
		</td>	
			
		</tr>
			
		<tr><td class="line" colspan="4"></td></tr>
	
	<tr><td colspan="4">
	
<cfoutput>
	<input type="reset" value=" Reset" class="button10g" >
	<input type="button" name="Submit" value="Search" class="button10g"
		onclick="Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Roster/Candidate/Events/LocateCandidateDetail.cfm?id=#URL.Id#&mode=#URL.Mode#','result','','','POST','myform')">
</cfoutput>

</td></tr>

<tr><td height="100%" colspan="4" valign="top" style="padding:3px">
	<cf_divscroll>
	<cfdiv id="result">
	</cf_divscroll>
</td></tr>
	
</TABLE>

</td></tr>

</table>

</cfform>
