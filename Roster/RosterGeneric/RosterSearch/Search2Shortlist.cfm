
<cfset Fun = "">

<cfquery name="OccGroup" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
     SELECT   DISTINCT O.*
     FROM     dbo.FunctionTitle F INNER JOIN
              dbo.FunctionOrganization F1 ON F.FunctionNo = F1.FunctionNo INNER JOIN
              dbo.Ref_Organization R ON F1.OrganizationCode = R.OrganizationCode INNER JOIN
              dbo.OccGroup O ON F.OccupationalGroup = O.OccupationalGroup
			  
     WHERE    F1.SubmissionEdition IN (SELECT SubmissionEdition
	                               	   FROM   Ref_SubmissionEdition
									   WHERE  SubmissionEdition = F1.SubmissionEdition
                                	   AND    EnableAsRoster = '1')
									   
     AND      F.FunctionNo = '#URL.FunctionNo#'						 
     ORDER BY Description
</cfquery>

<cfparam name="URL.ID1" default="#OccGroup.OccupationalGroup#">
<cfparam name="URL.mode" default="regular">

<cfif URL.DocNo neq "">

	<cfquery name="DefineOcc" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Vacancy.dbo.Document D
		WHERE  D.DocumentNo = '#URL.DocNo#'
	</cfquery>
	
	<cfset Fun = DefineOcc.FunctionNo>

</cfif>

<cfoutput>

<cfinclude template="../../../Vactrack/Application/Document/Dialog.cfm">

<script language="JavaScript">
	
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
		 	itm.className = "highLight2";
		 }else{		
		    itm.className = "regular";		
		 }
	  }
	  
	function showdocument(vacno) {
	    window.open("#SESSION.root#/Vactrack/Application/Document/DocumentEdit.cfm?ID=" + vacno, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", status=yes, toolbar=no, scrollbars=yes, resizable=yes");
	}  
	
	function reloadForm(occ) {
		window.location = "Search2.cfm?ID=#URL.ID#&ID1=" + occ
	}
	
	function fullsearch(owner) {    
	    ColdFusion.navigate('Search1.cfm?scope=embed&wparam=full&docno=#URL.DocNo#&functionno=#URL.functionno#&mode=#url.mode#&owner='+owner+'&Status=1','content') 	
	}		 
		 
	function first() {
	    window.location = "Search1.cfm?ID=#URL.ID#"
	}
 
</script> 

<cfquery name="Doc" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT D.*, F.OccupationalGroup as OccGroup
	    FROM   Document D, Applicant.dbo.FunctionTitle F
		WHERE  D.FunctionNo = F.FunctionNo
		AND    D.DocumentNo = '#URL.DocNo#'
</cfquery>

<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterOwner D
		WHERE D.Owner = '#Doc.Owner#'  
</cfquery>


		
<cf_screenTop height="100%" layout="webapp" banner="red" label="Short list" scroll="Yes" html="no">	

<table width="100%">

	<tr><td id="content">

		<table width="100%" cellspacing="0" cellpadding="0" style="padding:10px" class="formpadding">
				
		<tr><td colspan="2">
		   
		<!--- identify matching functions --->
		
		<cfset cond = "F.OccupationalGroup = '#URL.ID1#'"> <!--- #Occgroup.SelectId#' --->
		
		 <cfquery name="Steps" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT   Status
				FROM     Ref_StatusCode
				WHERE    ID    = 'FUN'
				AND      Owner = '#Owner.Owner#' 
				AND      ShowRosterSearch = '1' 
		</cfquery>   
		
		 <cfquery name="getAssociatedBucket" 
		        datasource="AppsSelection" 
		        username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
		        SELECT   *
				FROM     FunctionOrganization FO, Ref_SubmissionEdition R
				WHERE    FO.Submissionedition = R.SubmissionEdition
				AND      DocumentNo = '#URL.DocNo#' 		
		</cfquery>   
			
		<cfquery name="FunctionAll" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT   DISTINCT F.FunctionNo,
				         F.FunctionDescription, 
				         O.OrganizationDescription, 
						 O.HierarchyOrder,  
		                 F1.GradeDeployment, 
						 F1.ReferenceNo,
						 F1.DocumentNo,
						 G.Description AS GradeDescription, 
						 F1.OrganizationCode,
						  <!--- find the number of candidate to be selected --->				 
						 (   SELECT count(*)
							 FROM   ApplicantFunction
							 WHERE  FunctionId = F1.FunctionId
							 AND    Status IN ( 
										  SELECT   Status
										  FROM     Ref_StatusCode
										  WHERE    ID    = 'FUN'
										  AND      Owner = '#Owner.Owner#') 
						 				 ) as Candidates,
						 <!--- find the number of candidate to be selected --->				 
						 (   SELECT count(*)
							 FROM   ApplicantFunction
							 WHERE  FunctionId = F1.FunctionId
							 AND    Status IN ( 
										  SELECT   Status
										  FROM     Ref_StatusCode
										  WHERE    ID    = 'FUN'
										  AND      Owner = '#Owner.Owner#' 
										  AND      (PreRosterStatus = 1 OR Status = '3')) 
						 				 ) as VettedCandidates
										 
				FROM     FunctionTitle F, 
				         FunctionOrganization F1, 
						 Ref_SubmissionEdition R, 
						 Ref_Organization O,
				         Ref_GradeDeployment  G
				WHERE    F1.SubmissionEdition = R.SubmissionEdition
				AND      F1.OrganizationCode = O.OrganizationCode
				AND      F.FunctionNo        = F1.FunctionNo
				AND      R.EnableAsRoster    = 1
				AND      F1.GradeDeployment  = G.GradeDeployment
				<cfif getAssociatedBucket.RosterSearchMode eq "0">
				AND      1=0 <!--- this will not likely happen --->
				<cfelseif getAssociatedBucket.RosterSearchMode eq "1">
				AND      F1.DocumentNo = '#Doc.DocumentNo#' 
				<cfelse>		
				AND      F1.GradeDeployment  IN ('#Doc.PostGrade#','#Doc.GradeDeployment#') 
				<!---
				AND     F.OccupationalGroup = '#Doc.OccGroup#' 
				--->		
				AND      F.FunctionClass     = '#Owner.FunctionClassSelect#'  
				AND      R.Owner = '#Owner.Owner#' 
				</cfif>
			</cfquery>		
			 
			<cfform action="Search2Submit.cfm?docno=#url.docno#&ID=#URL.ID#&owner=#Owner.Owner#&mode=vacancy&status=1" method="POST" name="functionselect">
			
			<table width="97%" border="0" align="center">
			
			 <tr class="labelmedium">
			    <td height="40" style="font-size:20px;padding-left:4px">Select one of more roster buckets for your search
				
				  <input type="hidden" id="OccupationalGroup" name="OccupationalGroup" value="<cfoutput>#Doc.OccupationalGroup#</cfoutput>">
				  
					<!---
			    	<select name="occupationalgroup" size="1" onChange="reloadForm(this.value)">
					<!--- <option value="" selected>All groups</option> --->
				    <cfoutput query="OccGroup">
					<option value="#OccupationalGroup#" <cfif #URL.ID1# eq #OccupationalGroup#>selected</cfif>>
			    		#Description# 
					</option>
					</cfoutput>
				    </select>
					--->
						  
				</td>
				<td align="right" style="padding-right:3px">
				<input class="button10g" type="reset"  value=" Reset  ">
				<input type="submit" name="Submit" value="  Continue  " class="button10g">	    
				</td>
			 </tr> 	
			   
			<tr><td colspan="2">
			
			<table width="100%" class="formpadding">
			
			<tr><td height="1" colspan="7" class="line"></td></tr>
			
			<TR class="labelmedium line">
			    <td height="23"><cf_tl id="Area"></td>
			    <TD><cf_tl id="Function"></TD>
			    <TD><cf_tl id="Level"></TD>
				<td><cf_tl id="Track"></td>
				<td><cf_tl id="VA"></td>
				<TD align="right" style="padding-right:5px"><cf_tl id="Applications"></TD>
				<TD align="right" style="padding-right:5px"><cf_tl id="Vetted"></TD>
				<TD></TD>
			</TR>
				
			<cfloop query="FunctionAll"> 
			
			<cfset rowClass="labelmedium line">
			<cfif url.docno neq "">
				<cfset rowClass= rowClass & " highLight2">
			</cfif>
			
			<TR class="#rowClass# line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f6f6f6'))#">
			
			    <TD style="padding-left:3px">#OrganizationDescription#</TD>
			    <TD>#FunctionDescription#</TD>
			    <TD>#GradeDescription#</TD>
				<td><A href="javascript:showdocument('#DocumentNo#')">#DocumentNo#</a></td>
				<td>#ReferenceNo#
				</td>
				<td style="padding-right:5px" align="right">#candidates#</td>
				<td style="padding-right:5px" align="right">#VettedCandidates#</td>
				<td align="right" style="padding-right:4px">
				
				<input type="hidden" id="function_#currentRow#"    name="function_#currentRow#" value="#FunctionNo#">
				<input type="hidden" id="grade_#currentRow#"       name="grade_#currentRow#"    value="#GradeDeployment#">
				<input type="hidden" id="org_#currentRow#"         name="org_#currentRow#"      value="#OrganizationCode#">
				<input type="hidden" id="referenceNo_#currentRow#" name="referenceNo_#currentRow#"      value="#ReferenceNo#">
				
				<input type="checkbox" 
					   class="radiol" 
					   id="bucket_#currentRow#" 
					   name="bucket_#currentRow#"  
					   value="1" 
					   onClick="hl(this,this.checked)"
					   <cfif url.docno neq ""> checked </cfif> >
				
				</TD>
			</TR>
					
			</cfloop>
				
			</table>
			
			</td></tr>
						
			<tr>
			<td colspan="6" align="center" valign="middle" height="39">	
			
			<button name="Prios" id="Prios" class="button10g" value="Prior" type="submit"> <b>Next</b> &nbsp;
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/next.gif" border="0" align="absmiddle"> 
			</button>
			
			<input type="hidden" 
			       name="No" 
				   value="<cfoutput>#FunctionAll.recordcount#</cfoutput>">	
			
			</td></tr>
			</table>
			
			</CFFORM>
		
		</td></tr>
		
		</table>

	</td></tr>

</table>

</cfoutput>
