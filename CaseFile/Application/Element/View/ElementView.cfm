
<cf_dialogCaseFile>

<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<TR>
    <td width="3%"></td>
	<td width="100" height="18" class="labelit"><cf_tl id="No."></td>
	<td width="25%" class="labelit"><cf_tl id="Description"></td>
	<td width="70" class="labelit"><cf_tl id="Status"></td>	
	<td width="13%" class="labelit"><cf_tl id="Date"></td>
	<td width="10%" class="labelit"><cf_tl id="Type"></td>
	<td width="20%" class="labelit"><cf_tl id="Case"></td>	
</TR>
<tr><td class="line" colspan="8"></td></tr>

<cfquery name="SearchResult" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT 
	                  C.ClaimId, O.OrgUnit, O.OrgUnitName, C.DocumentNo, C.DocumentDate, C.DocumentSource, C.DocumentDescription,C.ClaimType, C.OfficerLastName, C.OfficerFirstName, 
	                  C.ClaimantEMail, C.ActionStatus, C.ClaimantEMail AS Expr1, S.Description AS status, C.CaseNo, 
	                  Ref_ClaimTypeClass.Description AS ClaimTypeClassDescription, C.Mission
		FROM    Claim C LEFT OUTER JOIN
	                  Ref_ClaimTypeClass ON C.ClaimType = Ref_ClaimTypeClass.ClaimType AND C.ClaimTypeClass = Ref_ClaimTypeClass.Code LEFT OUTER JOIN
	                  Organization.dbo.Organization O ON O.OrgUnit = C.OrgUnitClaimant LEFT OUTER JOIN
	                  Ref_Status S ON C.ActionStatus = S.Status AND S.StatusClass = 'clm'
		WHERE EXISTS
			(
				SELECT 'X'
				FROM 
				ClaimElement CL 
				WHERE 
				CL.ElementId = '#URL.ElementId#' 
				AND CL.ClaimId = C.ClaimId
			)
		ORDER BY C.CaseNo 
	</cfquery>
		
	<cfoutput>

		<cfset currrow = 0>

		<cfinvoke component="Service.Presentation.Presentation"
	       method="highlight"
	    returnvariable="stylescroll"/>		
		
		<cfset show = 0>
		
		<cfloop query="SearchResult">
		
			<cfinvoke component="Service.Access"  
    		 method="CaseFileManager" 
		     mission="#mission#" 
			 claimtype="#claimtype#"
		     returnvariable="access">

			<cfif access eq "READ" or access eq "EDIT" or access eq "ALL">
			
				<cfset show = show +1>
				
				<cfset currrow = currrow + 1>
				<tr id="r#currrow#" #stylescroll#>
						
			    <td width="1%">
					
					 &nbsp;&nbsp;
				 
				 	 <cfset c="#Client.VirtualDir#/Images/caution.gif">
					 <cfset i = "#Client.VirtualDir#/Images/pointer.gif">
					 <cfset t = "View claim">
				 
					 <img src="#i#"
					     alt="#t#"
					     name="img99_#currentrow#"
					     id="img99_#currentrow#"
					     border="0"
						 width="9"
						 height="9"
						 align="middle"
						 style="cursor: pointer;"
						 onClick="showclaim('#ClaimId#','#Mission#')"
					     onMouseOver="document.img99_#currentrow#.src='#Client.VirtualDir#/Images/button.jpg'"
					     onMouseOut="document.img99_#currentrow#.src='#i#'">
				</td>		


				<TD class="labelit"><a href="javascript:showclaim('#ClaimId#','#Mission#')"><font color="0080C0">#DocumentNo#</font></a></TD>			
				<TD class="labelit"><a href="javascript:showclaim('#ClaimId#','#Mission#')">#DocumentDescription#</a></TD>			
				<TD class="labelit">#Status#</a></TD>							
				<TD class="labelit">#DateFormat(DocumentDate, CLIENT.DateFormatShow)#</td>				
				<td class="labelit">#ClaimType#</td>
				<td class="labelit">#ClaimTypeClassDescription#</td>			
					
				</tr>			
		
			</cfif>
		
		</cfloop>	
		
		<cfif show eq 0>
			<tr><td colspan="8" align="center" class="labelmedium"> <cf_tl id="Your profile does not allow you to view this record."> </td></tr>
			<cfabort>
		</cfif>
		
		<tr><td class="line" colspan="8"></td></tr>
		
		</cfoutput>		

		<cfquery name="getElement" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Element 
			WHERE  ElementId = '#URL.ElementId#'  
		</cfquery>
				
		<cfquery name="getTopicList" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT    R.*
			     FROM      Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
				 WHERE     ElementClass = '#getelement.elementclass#'	
				 AND       Operational = 1
				 AND       R.TopicClass != 'Person'
				 ORDER BY  S.ListingOrder,R.ListingOrder
		</cfquery>
		
		<cfoutput query="getelement">	
						
		<TR>
			<TD colspan= "7">
			   <table width="97%" align="center" cellspacing="0" cellpadding="0">
			   
			   <tr>
				    <td class="labelit">								
									
					<cfparam name="colorlabel" default="gray">
					<cfparam name="fontsize"   default="2">
					<cfset element = url.elementid>				
					<cfinclude template="../Create/ElementViewCustom.cfm">	
					
					</td>
			   </tr>		   
						   
						 
				<cfquery name="Document" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    SourceElementId
				FROM      ClaimElement CE INNER JOIN
				          Element E ON CE.ElementId = E.ElementId INNER JOIN
				          Ref_ElementClass R ON E.ElementClass = R.Code								  
				AND       E.ElementId = '#url.elementid#'				
				AND       SourceElementId is not NULL
				</cfquery>
								
				<cfloop query="document">
					
					<tr>
					
						<td width="100%" colspan="6" height="2" bgcolor="FAFAFA"
					    style="padding:5px;border: 1px solid silver;" class="labelit"> 						  
							<cfdiv bind="url:#SESSION.root#/casefile/application/element/create/ElementView.cfm?key=#sourceelementid#">						 							 
						</td>
						
					</tr>	
									
				</cfloop>
				
				</table>
				
				</td>
				</tr>
						
		</cfoutput>		
		
		<!--- associations --->
		
		<cfquery name="Class" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT DISTINCT R.Code, R.Description, S.ElementClass
				FROM      ElementRelation E INNER JOIN
				          Ref_ElementRelation R ON E.RelationCode = R.Code INNER JOIN
				          Element S ON E.ElementIdChild = S.ElementId 
				WHERE     E.ElementId = '#url.elementid#' 
				ORDER BY S.ElementClass				
		</cfquery>			
		
		<cfif class.recordcount gte "1">
		
		<TR>
			<TD colspan="7">
							
			<table width="99%" align="center" cellspacing="0" cellpadding="0">
				
				<cfoutput query="Class" group="ElementClass">					
						
					<tr><td height="4"></td></tr>					
					<tr>
					<td height="24" style="padding-left:10px" class="labelit"><font face="Verdana" size="2">#Elementclass#</font></td>
					<td align="right">
					</td>
					</tr>
					<tr><td class="line" colspan="2"></td></tr>
					<tr>
					  <td id="#Elementclass#_ass" colspan="2">	
					    <table width="94%" align="center"><tr><td>						
					    <cfset url.mode = "view">		
					    <cfset url.elementclass = elementclass>				    
						<cfinclude template="../Association/AssociationListingDetail.cfm">		
						</td></tr></table>
					  </td>
					</tr>
					
				</cfoutput>

			</table>
			
			</td>
			
		</tr>	

		</cfif>	
		
	</TABLE>