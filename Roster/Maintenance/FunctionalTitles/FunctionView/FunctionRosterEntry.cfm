<HTML><HEAD>
	<TITLE>Function Roster - Entry Form</TITLE>
</HEAD>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_PreventCache>

<cfinclude template="FunctionViewHeader.cfm">

<script>

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld,no){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 itm2  = 'OrganizationCode_'+no
	 fld2 = document.getElementsByName(itm2)
	 
	 itm3  = 'Selection_'+no
	 fld3 = document.getElementsByName(itm3)
	 	 	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 fld2[0].className = "regular";
	 fld3[0].value = "1";
	 	 
	 
	 }else{
		
     itm.className = "regular";
	 fld2[0].className = "hide";	
	 fld3[0].value = "0";	
		 	
	 }
  }

</script>

<body onload="javascript: window.focus();">

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT     DISTINCT O.*, 
           S.SubmissionEdition as Edition, 
		   S.EditionDescription, 
		   S.ExerciseClass
   FROM    Ref_SubmissionEdition S LEFT OUTER JOIN FunctionOrganization O ON S.SubmissionEdition  = O.SubmissionEdition 
     AND   O.FunctionNo = '#URL.ID#'
   ORDER BY S.EditionDescription
</cfquery>

<cfquery name="Organization" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT *
   FROM Ref_Organization 
</cfquery>

<!--- Entry form --->
<cfform action="FunctionRosterEntrySubmit.cfm" method="POST" enablecab="No" name="action">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" style="border-collapse: collapse;">
  <tr>
  	<td height="30" valign="middle" class="BannerN">&nbsp;
	<b>Roster edition</b></td>
		
	<td class="BannerN" align="right"></td>
	
  </tr>
  
  <tr>
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse">
	
    <TR bgcolor="6688aa">

       <td height="20" colspan="1" class="topN">&nbsp;&nbsp;&nbsp;Select</td>
	   <td height="20" colspan="1" class="topN">Edition</td>
	   <td height="20" colspan="1" class="topN">Code</td>
	   <td height="20" colspan="1" class="topN">Class</td>
	   <td height="20" colspan="1" class="topN">App#</td>
	   	   <TD height="20" class="topN">&nbsp;Organization element</TD>
	  
   </TR>

   <cfset CLIENT.recordNo = 0>
   
   <cfoutput>
   <input type="hidden" name="FunctionNo" value="#URL.ID#">
    </cfoutput>
   
   <cfoutput query="Edition">
   
   <cfquery name="Check" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT count(functionId) as Counted
      FROM ApplicantFunction 
	  WHERE FunctionId = '#FunctionId#'
   </cfquery>
        
      
   <cfif #OrganizationCode# eq "">
             <TR class="regular">
   <cfelse>  <TR class="highlight1">
   </cfif>

   <td align="center" class="regular">&nbsp;
	    <cfif #OrganizationCode# eq "">
    		<cfset CLIENT.recordNo = #Client.recordNo# + 1>
        	<input type="checkbox" name="selected_#CLIENT.recordNo#" value="0" onClick="hl(this,this.checked,'#CLIENT.recordNo#')">
			<input type="hidden" name="selection_#CLIENT.recordNo#" value="0"> 
    	<cfelse>
		   <cfif #Check.counted# eq 0>
    		   <cfset CLIENT.recordNo = #Client.recordNo# + 1>
            	<input type="checkbox" name="selected_#CLIENT.recordNo#" value="1" checked onClick="hl(this,this.checked,'#CLIENT.recordNo#')">
                <input type="hidden" name="selection_#CLIENT.recordNo#" value="1"> 				
			</cfif>	
        </cfif>
   </td>
      
  
    <td class="regular">&nbsp;&nbsp;&nbsp;#EditionDescription#
	   <cfif #Check.counted# eq 0>
    	  <input type="hidden" name="ActionId_#CLIENT.recordNo#" value="#Edition#">
	   </cfif>	  
	</td>
	  
	<td class="regular">&nbsp;&nbsp;&nbsp;#Edition#</td>
	<td class="regular">&nbsp;&nbsp;&nbsp;#ExerciseClass#</td>
	
	<td class="regular">
             <cfif #Check.counted# gt 0>
                 #Check.counted#
			</cfif>
   </td>
	
	<td class="regular">&nbsp;
		
	  <cfset code = #OrganizationCode#>
	  <cfif #Check.counted# eq 0>
    	  <select name="OrganizationCode_#CLIENT.recordNo#"> <cfif #OrganizationCode# eq "">class="hide"<cfelse>class="regular"</cfif>>
	      <cfloop query="Organization">
    	  <option value="#Organization.OrganizationCode#" 
    	  <cfif #Organization.OrganizationCode# eq #code# and #code# neq "">selected</cfif>>
    	  #Organization.OrganizationDescription#</option>
	      </cfloop>
    	  </select>
	  <cfelse> 
	  
	  <cfquery name="OrganizationSelect" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT *
   FROM Ref_Organization 
   WHERE OrganizationCode = '#OrganizationCode#'
</cfquery>
	  
	  #OrganizationSelect.OrganizationDescription#
	  </cfif>	  
	</td>
	
	 </tr> 	  
  
  <tr><td colspan="6" class="top"></td></tr>
   
   </CFOUTPUT>
     

</TABLE>
</td>
</table>

 

<hr>

<input class="button1" type="button" value="   Cancel  " onClick="javascript:window.history.back()">
<INPUT class="button1" type="submit" value="Submit Data">


	
</CFFORM>

</BODY></HTML>