<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" html="No" line="no" jQuery="yes" scroll="no" title="Result">

<cfajaximport tags="CFFORM">

<cf_dialogstaffing>
<cf_calendarscript>

<!--- Create Criteria string for query from data entered thru search form --->

<CFSET Criteria = ''>
<CF_Search_AppendCriteria
    FieldName="#Form.Crit1_FieldName#"
    FieldType="#Form.Crit1_FieldType#"
    Operator="#Form.Crit1_Operator#"
    Value="#Form.Crit1_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit2_FieldName#"
    FieldType="#Form.Crit2_FieldType#"
    Operator="#Form.Crit2_Operator#"
    Value="#Form.Crit2_Value#">
<CF_Search_AppendCriteria
    FieldName="#Form.Crit4_FieldName#"
    FieldType="#Form.Crit4_FieldType#"
    Operator="#Form.Crit4_Operator#"
    Value="#Form.Crit4_Value#">	
	
<cfparam name="Form.Nationality" default="">	

<cfif Form.Nationality IS NOT "">
     <cfif Criteria is ''>
	 <CFSET Criteria = "Nationality IN (#PreserveSingleQuotes(Form.Nationality)# )">
	 <cfelse>
	 <CFSET Criteria = #Criteria#&" AND Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
     </cfif>
</cfif> 

<!--- assignment --->

<CFSET Assignment = ''>

<cfif Form.Mission IS NOT "">
    <CFSET Assignment = "Mission LIKE '%#Form.Mission#%'">
</cfif> 

<cfif Form.OrgUnitClass IS NOT "">
     <cfif Assignment is ''>
	 <CFSET Assignment = "OrgUnitClass LIKE '%#Form.OrgUnitClass#%'">
	 <cfelse>
	 <CFSET Assignment = "#Assignment# AND OrgUnitClass LIKE '%#Form.OrgUnitClass#%'">
     </cfif>
</cfif> 

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 100 * 
    FROM Person	
	<cfif PreserveSingleQuotes(Criteria) neq "">
	WHERE #PreserveSingleQuotes(Criteria)# 
	<cfelse>
	WHERE PersonNo is not NULL
	</cfif>
    	
	<cfif #Form.OnBoard# eq "1">
	AND PersonNo IN (SELECT PersonNo 
	                 FROM PersonAssignment 
					 WHERE DateExpiration > getDate()
					 AND AssignmentStatus IN ('0','1'))
	
	<cfelseif Form.OnBoard eq "0">
	AND PersonNo NOT IN (SELECT PersonNo 
	                 FROM PersonAssignment 
					 WHERE DateExpiration > getDate()
					 AND AssignmentStatus IN ('0','1'))
	
	</cfif>
	<cfif Assignment neq "">
	AND PersonNo IN (SELECT PersonNo
	                 FROM PersonAssignment A, Organization.dbo.Organization O
					 WHERE A.OrgUnit = O.OrgUnit
					 AND #PreserveSingleQuotes(Assignment)#
					 AND AssignmentStatus IN ('0','1'))
	</cfif>
	ORDER BY LastName, FirstName</cfquery>
		
		
<cfoutput>	

<cfparam name="url.personno" default="">
<cfparam name="url.mode" default="lookup">

<script>
	
	function selected(personno,indexno,lastname,firstname,full,birthdate,nationality) {
					       
			var per = "#Form.fldPersonNo#";							
			var ind = "#Form.fldIndexNo#";
			var lst = "#Form.fldLastName#";
			var fst = "#Form.fldFirstName#";
			var nme = "#Form.fldFull#";
			var dob = "#Form.fldDob#";
			var nat = "#Form.fldNationality#";
			
		    parent.opener.document.getElementById(per).value = personno				
			parent.opener.document.getElementById(lst).value = lastname				
			parent.opener.document.getElementById(fst).value = firstname
			
			try {				
			parent.opener.document.getElementById(ind).value = indexno } catch(e) {}									
			
			try {	
				if (nme != '') { 
				    parent.opener.document.getElementById(nme).value = firstname+' '+lastname 
				} 
			} catch(e) {}	
			
			try {
			parent.opener.document.getElementById(dob).value = birthdate } catch(e) {}
			
			try {
			parent.opener.document.getElementById(nat).value = nationality } catch(e) {}
			
			parent.window.close();		
		
			
	}
	
	function search() {
		ptoken.location('LookupSearchSelect.cfm?#Form.link#')
	}
		
	function addrecord() {
	    ptoken.navigate('#session.root#/Staffing/Application/Employee/PersonEntryForm.cfm?mode=#url.mode#','tablecontent')	
	}		
				
	function validate() {
		document.formperson.onsubmit() 
		if( _CF_error_messages.length == 0 ) {
           	ptoken.navigate('#session.root#/Staffing/Application/Employee/PersonEntrySubmit.cfm?personno=#url.personNo#&mode=#url.mode#','result','','','POST','formperson')
	    }   
    }
	
	
</script>

</cfoutput>	

<cf_dialogStaffing>

<table style="width:98%;height:98%" align="center"> 

<tr><td colspan="2" align="center" height="30">
	<input type="button" class="button10g" style="width:140px;height:28px" name="Search" value="Search" onClick="search()">
	</td>
</tr>
 
<tr><td height="1" colspan="7" class="line"></td></tr>

<tr>
   <td height="28" class="labelmedium" colspan="7">
	   <table width="100%">
		   <tr>
			   <td class="labelmedium" style="padding-left:20px"><cfoutput>#SearchResult.recordcount#</cfoutput> <cf_tl id="employees listed"></td>
			   <cfif form.showadd eq "1">
				   <td>|</td>
				   <td class="labelmedium2" align="right">
				      <a href="javascript:addrecord()"><cf_tl id="Register a new person"></a>
				   </td>
			   </cfif>
		   </tr>
	   </table>
   </td>
   <td align="right"></td>
</tr> 	
  
<tr><td colspan="2" valign="top" style="height:100%" id="tablecontent">

`	<cf_divscroll>

	<table class="navigation_table" style="width:98%">
			
	<TR class="line labelmedium fixrow">
	    <td height="20"></td>
	    <TD><cf_tl id="Name"></TD>
		<TD><cf_tl id="IndexNo"></TD>
	    <TD><cf_tl id="Nat."></TD>
		<TD><cf_tl id="Sex"></TD>
		<TD><cf_tl id="DOB"></TD>
		<TD><cf_tl id="Org. start"></TD>
	</TR>
		
	<CFOUTPUT query="SearchResult">
		
		<cfset lname = Replace(rtrim(LastName),"'","",'ALL')>
		<cfset lname = Replace(rtrim(lname),",","",'ALL')>
		<cfset lname = Replace(rtrim(lname),'"',"",'ALL')>
		<cfset fname = Replace(rtrim(FirstName),"'","",'ALL')>
		<cfset fname = Replace(rtrim(fname),",","",'ALL')>
		<cfset fname = Replace(rtrim(fname),'"',"",'ALL')>
					
		<TR class="navigation_row line labelmedium" style="height:20px" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f7f7f7'))#">
					
			<cfset vSelected = "selected('#PersonNo#','#IndexNo#','#lname#','#fname#','#lname#, #fname#','#dateformat(birthdate,client.dateformatshow)#','#nationality#')">
			<cfif form.fnselected neq "">
				<cfset vSelected = "#form.fnselected#('#PersonNo#', parent)">
			</cfif>
			
			<TD width="30" align="center" class="navigation_action" style="padding-left:10px;padding-top:3px" onclick="#vSelected#">		 
			   <cf_img icon="select">			    
			</TD>
			<TD>#LastName#, #FirstName# #MiddleName#</TD>
			<TD><A title="View profile" HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo#</A></TD>
			<TD>#Nationality#</TD>
			<TD>#Gender#</TD>
			<TD>#DateFormat(BirthDate, CLIENT.DateFormatShow)#</TD>
			<TD>#Dateformat(OrganizationStart, CLIENT.DateFormatShow)#</TD>
		
		</TR>
					
	</CFOUTPUT>
	
	</TABLE>
	
	</cf_divscroll>

</tr></td>
</table>

