<cfparam name="URL.section" default = "">

<cfquery name="Topic" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_ParameterSkill
  WHERE  Code = '#URL.Topic#'
</cfquery>

<script>

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
	 
	 	 		 	
	 if (fld != "0"){
		
	 itm.className = "highLight1";

	 }else{
		
     itm.className = "header";		
	 }
  }
  
function minimize(itm,icon){
	 
	 se  = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 se.className = "hide";
	 icM.className = "hide";
	 icE.className = "regular";
			 
  }
  
function expand(itm,icon){
	 
	 se  = document.getElementById(itm)
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 se.className = "regular";
	 icM.className = "regular";
	 icE.className = "hide";
			
  }    

</script>

<cfajaximport>

<cfset count = 0>

<cfif url.entryScope eq "Backoffice">

	<cfinvoke component="Service.Access"  
		method="roster" 
		role="'AdminRoster','CandidateProfile','RosterClear'"
		returnvariable="Access">	
		
<cfelseif url.entryScope eq "Portal">

	<cfset Access = "ALL">

</cfif>

<cfoutput>
   <form action="#SESSION.root#/roster/candidate/details/Computing/ComputingEntrySubmit.cfm?applicantno=#url.applicantno#&section=#url.section#&entryScope=#url.entryScope#&ID=#URL.ID#&ID2=#URL.ID2#&source=#url.source#&Topic=<cfoutput>#URL.Topic#</cfoutput>" method="post">
   <input type="hidden" name="PersonNo"     value = "#URL.ID#">
   <cfparam name="URL.ID1" default="">
   <input type="hidden" name="ExperienceId" value = "#URL.ID1#">
</cfoutput>


<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td>
   
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td height="23" class="labellarge"><cf_tl id="Computing skills"></b></td></tr> 

<tr><td height="4"></td></tr>

<tr><td class="labelit">
	<cf_tl id="Indicate by clicking on the appropriate choice">, <cf_tl id="your frequency of use of the software and systems below">. 
</td></tr>
<tr><td class="labelit">Note : <b>"<cf_tl id="Occ">."</b> <cf_tl id="means occasional">.</td></tr>

<tr><td height="4"></td></tr>

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT distinct C.ExperienceClass, C.Description
  FROM   Ref_ExperienceClass C, 
         Ref_Experience E
  WHERE  C.Parent = 'Miscellaneous'
  AND    E.ExperienceClass = C.ExperienceClass
</cfquery>

<cfloop query="Master">

        <cfset ar = Master.ExperienceClass>
		<cfset val = "">
				
		<cfsavecontent variable="base">
		    <cfoutput>
		    SELECT    C.ExperienceId,C.ExperienceLevel,C.ApplicantNo,C.ExperienceFieldId			
		    FROM      ApplicantBackgroundField C, ApplicantSubmission S
			WHERE     S.ApplicantNo = C.ApplicantNo
			AND       C.Status != '9'			
			AND 	  S.Source = '#URL.Source#'
			AND       S.PersonNo = '#URL.ID#' 
			</cfoutput>
		</cfsavecontent>
						
		<cfquery name="GroupAll" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    F.*, 
					  S.ExperienceId,	
			          S.ExperienceLevel, 
				      S.ApplicantNo, 
				      S.ExperienceFieldId as Selected
			FROM      (#preservesingleQuotes(base)#) as S RIGHT OUTER JOIN 
			          Ref_Experience F ON S.ExperienceFieldId = F.ExperienceFieldId
			WHERE     F.ExperienceClass = '#Ar#'
			AND       F.Status = 1
			ORDER BY  F.ListingOrder
		</cfquery>
		
		
	<tr><td>
					
       <table width="100%">
						
		<cfoutput>						
	    <tr><td align="left" class="labellarge" style="padding-left:5px;padding-bottom:3px">#Description#</td></tr>			
		</cfoutput>
							
   		<TR><td width="100%">
								
		    <cfoutput>
						
			<table width="100%" border="0" align="right" class="regular" id="#Ar#">
			
			<tr>
			
    			<td width="30" valign="top">&nbsp;<img src="#SESSION.root#/Images/join.gif" alt=""></td>
				<td width="100%">
				<table width="98%" style="border:1px dotted silver" cellspacing="0" cellpadding="0" align="left" bgcolor="ECF5F9">
			
					</cfoutput>
									
					<tr class="labelit">
						<td></td>						
						<td style="height:25px;padding-left:10px;">No</td>
						<td style="padding-left:5px">Occ.</td>
						<td style="padding-left:5px">Daily</td>
					</tr>	
									
					<cfoutput query="GroupAll">
					
					<cfif experienceid neq "">
					   <cfif val eq "">
					    <cfset val = "'#experienceid#'">
					   <cfelse>
					   <cfset val = "#val#,'#experienceid#'">
					   </cfif>
					</cfif>
					
					<cfset count = count + 1>						
					  											   
						<cfif Selected eq "">
						          <TR class="regular">
						<cfelse>  <TR class="highlight1">
						</cfif>
						<td class="labelmedium" style="height:20px;padding-left:10px">#Description#</font></td>
						
						<input type="hidden" name="FieldId_#count#" value="#ExperienceFieldId#">
						
						<td style="width:40px;padding-left:10px; height:20px;"><input class="radiol" type="radio" name="Level_#count#" value=""checked onClick="hl(this,'0')"></td>
						<td style="width:40px;padding-left:5px"><input type="radio" class="radiol" name="Level_#count#" value="1" <cfif ExperienceLevel eq "1">checked</cfif> onClick="hl(this,'1')"></td>
						<td style="width:40px;padding-left:5px"><input type="radio" class="radiol" name="Level_#count#" value="2" <cfif ExperienceLevel eq "2">checked</cfif> onClick="hl(this,'1')"></td>
						</tr>											
					
					</CFOUTPUT>
												
			    </table>
				
				</td></tr>
				
				</table>
									
			</td></tr>
							
		</table>
		
	</td></tr>
	
	<tr><td height="5"></td></tr>
			
	<cfquery name="get" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT TOP 1 *
	  FROM   ApplicantBackground 
	  <cfif val neq "">
	  WHERE  ExperienceId IN (#preservesinglequotes(val)#) 
	  <cfelse>
	  WHERE 1=0
	  </cfif>
	</cfquery>	
				
	<cfoutput query="get">
	<tr><td class="linedotted"></td></tr>
	<tr><td height="30" style="padding-left:30">Last updated by : #get.OfficerFirstName# #get.OfficerLastName# on #dateformat(get.updated,CLIENT.DateFormatShow)# #timeformat(get.updated,"HH:MM")#</td></tr>
	<tr><td class="linedotted"></td></tr>
	</cfoutput>
			
</cfloop>		

<cfif access eq "EDIT" or access eq "ALL">

    <cfoutput>

		<cf_tl id="Save" var="save">
		<tr><td height="35" align="center"><INPUT class="button10g" style="height:25;width:150" type="submit" value="#save#"></td></tr>
	
	</cfoutput>
	
</cfif>

<input type="hidden" name="counted" value="<cfoutput>#count#</cfoutput>">
			
</table>

</td>
</tr>

</table>

<!---

<cfif URL.Topic eq "All">

<cfoutput>

	<script language="JavaScript">
	
	{
	frm  = parent.document.getElementById("icomputing");
	he = 25+#cnt#;
	frm.height = he;
	}
	
	</script>

</cfoutput>

</cfif>

--->

</BODY></HTML>