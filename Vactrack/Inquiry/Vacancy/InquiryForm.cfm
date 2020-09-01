
<cf_screentop height="100%" jquery="Yes" scroll="Yes" html="No" >

<cf_dialogPosition>
<cf_calendarScript>

<script language="JavaScript">

	function Selected(no,description) {	
	    document.getElementById('functionaltitle').value = description
		document.getElementById('functionno').value = no	
		try { ColdFusion.Window.destroy('myfunction',true) } catch(e) {}				
	}

</script>

<cfajaximport tags="cfwindow">

<cfquery name="CandidateStatus"
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_Status
	WHERE Class = 'Candidate'
</cfquery>

<cfquery name="Edition"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM  Ref_SubmissionEdition C
	WHERE SubmissionEdition IN (SELECT SubmissionEdition 
	                            FROM   FunctionOrganization B 
								WHERE  SubmissionEdition = C.SubmissionEdition
	                            AND    DocumentNo IN (SELECT DocumentNo 
								                      FROM   Vacancy.dbo.Document 
													  WHERE  DocumentNo = B.DocumentNo
													  AND    Operational = 1)
							   )
</cfquery>

<cfquery name="mission" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   Mission, count(*) as Total
FROM     Document
WHERE    Mission IN (SELECT Mission FROM Organization.dbo.Ref_Mission WHERE Operational = 1)	
AND      Status != '9'		   		
GROUP BY Mission
ORDER BY Mission
</cfquery>

<cfoutput>
<table width="95%" border="0">
<tr>
	<td width="40"></td>

	<td height="80" valign="middle" align="left" width="95%" style="top; padding-left:10px">
		<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
			<tr>
				<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
				</td>
			</tr>			
			<tr>
				<td style="z-index:5; position:absolute; top:13px; left:38px; ">
					<img src="#SESSION.root#/images/User.png" width="64" height="64">
				</td>
			</tr>
			<tr>
				<td style="z-index:3; position:absolute; top:18px; left:99px; color:45617d; font-size:28px; font-weight:200;">
					<cf_tl id="Recruitment Track">
				</td>
			</tr>
			<tr>
				<td style="position:absolute; top:5px; left:99px; color:e9f4ff; font-size:55px; font-weight:200; z-index:2">
					<cf_tl id="Recruitment Track">
				</td>
			</tr>
			
			<tr>
				<td style="position:absolute; top:48px; left:100px; color:45617d; font-size:14px; font-weight:200; z-index:4">
					<cf_tl id="Search for a recruitment track">
				</td>
			</tr>
			
		</table>
	</td>
</tr>
</table>
</cfoutput>

<!--- Search form --->
<cfform action="InquiryQuery.cfm" method="POST" enablecab="No" name="documententry">

<table border="0" cellspacing="0" cellpadding="0" valign="center" class="formpadding">

<tr><td style="padding-left:60px">

<table width="750" border="0" cellspacing="0" cellpadding="0" valign="center"  class="formpadding">

 <tr>
    <td height="26" class="labelmedium" style="padding-left:10px">
	  <cf_tl id="Search by any or all of the criteria below">:
	</td>
	<td align="right">
	<input class="button10g" style="width:110px" type="reset"  value="Reset">   
	</td>
 </tr> 	
 
<tr><td height="1" colspan="4" class="line"></td></tr>
  
<tr><td colspan="2">
  
<table width="95%" border="0" cellspacing="0" align="center" class="formpadding">

	<tr><td height="5" colspan="1" width="30%"></td></tr>

	<TR>
	
	<td colspan="1" class="labelmedium"><cf_tl id="Track No">:</td>
	
	<INPUT type="hidden" name="Crit3_FieldName" value="V.DocumentNo">
	<INPUT type="hidden" name="Crit3_FieldType" value="CHAR">
	    
	<td colspan="3">
	    <!---
	    <SELECT name="Crit3_Operator">
			<OPTION value="CONTAINS">contains
			<OPTION value="BEGINS_WITH">begins with
			<OPTION value="ENDS_WITH">ends with
			<OPTION value="EQUAL">is
			<OPTION value="NOT_EQUAL">is not
			<OPTION value="SMALLER_THAN">before
			<OPTION value="GREATER_THAN">after
		</SELECT>
		--->
		
	<INPUT class="regularxxl" type="text" name="Crit3_Value" size="10">
   	
	</TD>
	</tr>
		
	<tr>	
	<td colspan="1" class="labelmedium"><cf_tl id="Track Reference No">:</td>	    
	<td colspan="3">		
	<INPUT class="regularxxl" type="text" name="ReferenceNo" size="28">   	
	</TD>
	</tr>
			
	<tr>	
	<td style="min-width:180px" colspan="1" class="labelmedium"><cf_tl id="Entity">:</td>	
	<td colspan="3">
	
	    <select value="All" name="mission" size="1" class="regularxxl">
		
		<option value="All" selected><cf_tl id="Any"></option>
		
		
	    <cfoutput query="Mission">
		
		 <cfinvoke component="Service.Access"  
		          method="vacancytree" 
		    	  mission="#Mission#"
			      returnvariable="accessTree">
	   			
	 			 <cfif AccessTree neq "NONE">
				    <option value="'#Mission#'">#Mission# (#total#)</option>	
				 </cfif>	
				 
		</cfoutput>
				
	    </select>
				
	</td>	
	</tr>
		
	<tr>	
	<td colspan="1" class="labelmedium"><cf_tl id="Roster Edition">:</td>	
	<td colspan="3">
	
	    <select name="submissionedition" class="regularxxl">
		
		<option value="" selected>Any</option>
		
	    <cfoutput query="Edition">	 			
			    <option value="#SubmissionEdition#">#EditionDescription#</option>	
		</cfoutput>
		
	    </select>
				
	</td>	
	</tr>
		
	<tr>	
	<td colspan="1" class="labelmedium"><cf_tl id="Grade">:</td>	
	<td colspan="3"><cfdiv bind="url:InquiryFormGrade.cfm?mission={mission}" id="grade"></td>	
	</tr>
		
	<tr>	
	<td colspan="1" class="labelmedium"><cf_tl id="Hide Cancelled Tracks">:</td>	
	<td colspan="3">
	  <input type="checkbox" name="Operational" class="radiol" checked value="1" name="Operational">
	</td>
	
	</tr>
		
	<tr>
		
	<td colspan="1" class="labelmedium"><cf_tl id="Functional title">:</td>
	
    <TD>
	<cfoutput>
	
	  <table cellspacing="0" cellpadding="0"><tr>
	   <td>	
	   <input type="text"   id="functionaltitle" name="functionaltitle" class="regularxxl" size="50" maxlength="80" value="" readonly>				    
	   <input type="hidden" id="functionno" name="functionno" class="disabled" size="6" maxlength="6" value="" readonly>	
	   <input type="hidden" id="documentnotrigger" name="documentnotrigger" class="disabled" size="6" maxlength="6" readonly>	
	   
	   </td>
	   <td>
	   
			  <img src="<cfoutput>#SESSION.root#/Images/search.png</cfoutput>" onClick="selectfunction('webdialog','functionno','functionaltitle','','','')" alt="" name="img1" height="12" width="12" 
				  style="cursor: pointer;height:25;width:25" alt="" border="0" align="top">
	  
	   </td>
	   </tr></table>
   	  
	  </cfoutput>
	</TD>
	</TR>	
			
	<TR>
	
	<td colspan="1" class="labelmedium"><cf_tl id="Postnumber">:</td>
			    
	<td colspan="3">
	 
	<INPUT class="regularxxl" type="text" name="Post" size="10">
    	
	</TD>
	</tr>
		
	<tr>
	
	<td colspan="1" class="labelmedium"><cf_tl id="Due date">:</td>
	
	<td colspan="3">
	
		<table cellspacing="0" cellpadding="0"><tr><td>
	
			 <cf_intelliCalendarDate9
				FieldName="Start" 
				Default="#Dateformat(Now()-300, CLIENT.DateFormatShow)#"
				Class="regularxxl">
			
			</td>
			
			<td width="20" align="center">-</td>
			<td>
					
    	  <cf_intelliCalendarDate9
				FieldName="End" 
				Default="#Dateformat(Now()+90, CLIENT.DateFormatShow)#"
				Class="regularxxl">	
		
		</td></tr>
		</table>
				
	</td>
	
	</tr>
		
    <TR>
	
	<td colspan="1" class="labelmedium"><cf_tl id="Candidate name">:</td>	    
	<td colspan="3">    			
	<INPUT class="regularxxl" type="text" name="Name" size="30">	
	</TD>
	</tr>
		
	<tr>
	
	<td valign="top" style="padding-top:5px" colspan="1" class="labelmedium"><cf_tl id="Candidate status">:</td>
	
	<td colspan="3">
	   <cf_uiselect name="CandidateStatus" class="regularxxl"
	      multiple = "Yes" query="#CandidateStatus#" value="Status" Display="Description">
	   </cf_uiselect>
	</td>
	
	</tr>
			
	<tr>
	
	<td colspan="1" class="labelmedium"><cf_tl id="Candidate Track">:</td>	
	<td colspan="3">	
	    <cfdiv bind="url:InquiryFormTrack.cfm?mission={mission}" id="flow">	
	</td>	
	</tr>
			
	<tr><td height="1" colspan="4" class="line"></td></tr>
	<tr><td height="5" colspan="4"></td></tr>
	<tr><td colspan="4" align="center">
	   <input class="button10g" style="width:200;height:28;font-size:13px" type="submit" name="submit"  value="Submit">
	</td></tr>
	<tr><td height="5" colspan="4"></td></tr>
		
</TABLE>

</td></tr>

</table>

</td></tr>

</table>
	

</CFFORM>

<cf_screenbottom layout="webapp">
