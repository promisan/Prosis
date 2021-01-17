 	
	<cfparam name="occ" default="">
	<cfparam name="url.wparam" default="full">
	
	<cfif url.mode eq "vacancy" or url.mode eq "ssa">
	
		<cf_screenTop height="100%" layout="webapp" banner="red" label="Short list" scroll="Yes" html="no">	
				
		<cfset occ = "">
		<cfset param = "">
		
		<cfif url.mode eq "vacancy">
		
			<!--- roster search from vactrack --->
			
			<cfquery name="DefineOcc" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT F.OccupationalGroup
			    FROM   FunctionTitle F, Vacancy.dbo.Document D
				WHERE  F.FunctionNo = D.FunctionNo
				AND    D.DocumentNo = '#URL.DocNo#' 
			</cfquery>
		
			<cfset Occ = DefineOcc.OccupationalGroup>
			
			<cfquery name="Group" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   OrganizationObject O, Ref_EntityClass R
				WHERE  ObjectKeyValue1 = '#URL.DocNo#' 
				AND    O.EntityCode    = R.EntityCode
				AND    O.EntityClass   = R.EntityClass
				AND    O.EntityCode    = 'VacDocument'		
			</cfquery>
			
			<cfset param = Group.EntityParameter>
			
		</cfif>
		
		<cfquery name="ShowEdition" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT R.*, (SELECT count(*) 
			             FROM FunctionOrganization 
						 WHERE SubmissionEdition = R.SubmissionEdition) as Buckets
		    FROM   Ref_SubmissionEdition R, 
			       Ref_ExerciseClass C
			WHERE  C.ExcerciseClass   = R.ExerciseClass
			AND    C.Roster           = 1 
			AND    R.Owner            = '#URL.Owner#' 
			<cfif param neq "">
			AND   (R.PostType = '#param#' or R.PostType is NULL)
			</cfif>
			AND    R.Operational      = 1
			AND    R.RosterSearchMode != '0'
			AND   ((R.DateExpiration >= getDate() 
			          OR R.DateExpiration is NULL 
					  OR R.DateExpiration = ''))  			  
		</cfquery>
		
		<cfset ed = "">
		<cfloop query="showedition">
			<cfif ed eq "">
			   <cfset ed = "'#SubmissionEdition#'">
			<cfelse>
			   <cfset ed = "#ed#,'#SubmissionEdition#'">   
			</cfif>
		</cfloop>
	
	</cfif>
		
	<cfform action="Search1Submit.cfm?wparam=#url.wparam#&mode=#URL.Mode#&Owner=#URL.Owner#&Status=#URL.Status#&DocNo=#URL.DocNo#" 
				method="post" style="height:98%"
				target="_self" 
				name="search1">
	
	<table width="99%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		   		
	    <TR style="height:95%" class="line">
						
		<td colspan="2" valign="top" align="left">
				
			<cfinvoke component="Service.Access"  
				 method="roster" 
				 returnvariable="rosterAccess"
				 role="'AdminRoster','RosterClear'">
				
				<cfquery name="OccGroup" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				     
					 SELECT  DISTINCT O.*
				  
				     FROM    dbo.FunctionTitle F 
					         INNER JOIN dbo.FunctionOrganization F1 ON F.FunctionNo = F1.FunctionNo 
							 INNER JOIN dbo.Ref_Organization R ON F1.OrganizationCode = R.OrganizationCode 
							 INNER JOIN dbo.OccGroup O ON F.OccupationalGroup = O.OccupationalGroup
				     WHERE   1=1 
					 <cfif occ neq "">
					 
					 AND     O.OccupationalGroup = '#occ#'	
					 				 
					 <cfelseif rosterAccess eq "NONE" and URL.Mode neq "Limited" and url.docNo eq "">	
					
					 <!--- give access to logical buckets for which a person has been granted access through one of more vacancies ---> 					 
					 AND     F1.FunctionId IN 	(SELECT Bucket.FunctionId
								   			     FROM   RosterAccessAuthorization A 
											            INNER JOIN FunctionOrganization FO ON A.FunctionId = FO.FunctionId 
													    INNER JOIN FunctionOrganization Bucket ON FO.FunctionNo = Bucket.FunctionNo AND FO.OrganizationCode = Bucket.OrganizationCode AND 
								                  	    FO.GradeDeployment = Bucket.GradeDeployment
											     WHERE  A.UserAccount = '#SESSION.acc#')		
											 			
					 </cfif>
					 
					 AND    F1.SubmissionEdition IN (#preservesingleQuotes(ed)#)
					 
					 <!--- ability to limit presentation using function and setting of PostSpecific = 0, Post specific is only a track for recruitment but not to 
					       set rostering of a person which is supported differently --->
					 
					 AND    (F.FunctionRoster = '1' OR F1.ReferenceNo IN ('Direct','direct') OR F1.PostSpecific = 0)		
					 
				     ORDER BY Description
					 
			</cfquery>
	
			<cfif OccGroup.recordcount eq "0">
			
				<cfquery name="Occ" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   OccGroup
					WHERE  OccupationalGroup = '#occ#'
				</cfquery>	
	
				<cfset cls = "hide">
				<table style="width:100%">
				<tr><td style="padding-top:10px;font-size:20px;color:red" class="labelmedium" align="center">
				
				<cfoutput>
				Problem : You have no access or there are no rostered candidates for occupational group <b>#Occ.Description#</b> in the editions #preservesingleQuotes(ed)#
				</cfoutput>
				
				</td></tr></table>
					
			<cfelse>		
								
					
				<table width="100%" align="center">
			
				<tr><td height="8"></td></tr>	
											
				<cfset cls = "regular">	
								
				<tr><td height="30" style="font-size:18px" class="labellarge"><cf_tl id="In the following available editions" class="Message">:</td></tr>	
				
				<tr><td height="7"></td></tr>
								
				<tr class="<cfoutput>#cls#</cfoutput>">
				
					<td align="center">
					
				<cfif ShowEdition.recordcount eq "0">
					
					<b><cf_tl id="No edition defined. Contact your administrator" class="Message"></b>
					
					<cfelse>
						
					<table width="96%" align="center" class="formpadding navigation_table">
					  <tr class="labelmedium line">
					  <td>&nbsp;</td>
					  <td colspan="2"><cf_tl id="Roster edition"></td>
					  <td><cf_tl id="Buckets"></td>
					  <td><cf_tl id="Owner"></td>
					  <td><cf_tl id="Expiration"></td>
					  <td></td>
				    </tr>
					
				    <cfoutput query="ShowEdition" group="ExerciseClass"> 
					
					    <cfset cl = ExerciseClass>
					  
						<cfoutput> 
					    	<TR class="navigation_row line labelmedium">
							     <td>&nbsp;</td>
					   			 <td colspan="2" align="left"><cfif cl eq "#ExerciseClass#">#ExerciseClass#/</cfif>#EditionDescription#</td>
					      		 <td>#Buckets#</td>
								 
								 <cfquery name="Own" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									  SELECT  *
									  FROM Ref_AuthorizationRoleOwner
									  WHERE Code = '#Owner#'				  
								  </cfquery>
								 				 
								 <TD>#Own.Description#</TD>
								 
								 <td>#dateformat(dateexpiration,CLIENT.DateFormatShow)#</td>
								
						    	 <!---  <TD class="regular">&nbsp;#EditionDescription#&nbsp;&nbsp;</TD> --->
					    	     <TD align="center">
								      <input type="checkbox" name="submissionedition" value="#SubmissionEdition#" class="radiol"
									  onClick="hl(this,this.checked)" <cfif showEdition.recordcount eq "1">checked</cfif>>			  
						         </TD>
							 </TR>	
							 <cfset cl = "">	
					    
						</CFOUTPUT> 
					
					</CFOUTPUT>
						
					</table>
						
					</td></tr>
					
					<tr><td height="5"></td></tr>
					
					</cfif>
												
				</table>
										
		    </td>
		</tr>
						
		<tr class="<cfoutput>#cls#</cfoutput>">
			
			<td height="40" colspan="1" align="center">
				  <button type="submit" name="Next" 
				  value="Select Buckets" class="button10g" style="width:330;height:32;font-size:13px">
				  Continue Selecting Roster Buckets <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/next.gif" border="0" align="absmiddle"> 
				  </button>
			</td>
		
		</tr>			
		   
   </cfif>
			
</table>	

 </cfform>

<cfset ajaxonload("doHighlight")>
	