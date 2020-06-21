
<table width="100%" border="0" cellpadding="0" align="center">
  			
	<cfif URL.EntityCode eq "VacDocument">
		
	   <cfquery name="Details" dbtype="query">
			SELECT  *
			FROM     DetailsDocument
			WHERE    PostGradeBudget = '#URL.Code#' 
			ORDER BY ActionCode, DocumentNo
		</cfquery>					
					
	   <cfoutput query="Details" Group = "ActionCode">
	   
		   <cfif Status eq "9">
		   	<cfset cl = "FDDFDB">
		   <cfelse>
		   	<cfset cl = "white">
		   </cfif>
		 				   
		   <tr>
			  <td align="left" height="22" bgcolor="f4f4f4" style="border:1px solid silver">&nbsp;&nbsp;<font face="Verdana" size="1" color="808080">step:&nbsp;<font face="Verdana" size="2" color="black">#ActionDescription#</b></font></td>
		   </tr>
			   
		   <tr class="navigation_row">
		   					   
		   <TD>
			   					   
			   <cf_tabletop size="100%" omit="true">
			   				   				 
				   <table width="100%" border="0" cellpadding="0" align="center">
				  
				   <cfoutput>
				   <tr bgcolor="#cl#" valign="top">
				      <td class="cellcontent" width="6%" align="center">#CurrentRow#</td> 
	  				  <td class="cellcontent" width="5%" style="padding-right:3px">#EntityClass#</td>
					  <cfif VAReferenceNo eq "">
				      <td class="cellcontent" width="30%" style="padding-right:3px" colspan = "2">
					  	<a href="javascript:showdocument('#DocumentNo#','')">#DocumentNo#</a>
					  </td>
					  <cfelse>
					  <td class="cellcontent" width="30%" style="padding-right:3px" colspan="2">
						  <a href="javascript:showdocument('#DocumentNo#','')">#VAReferenceNo#</a>
					  </td>
					  </cfif>
					  <td class="cellcontent" width="10%" style="padding-right:3px">#Postgrade#</td>
					  
					  <td width="10%" class="cellcontent" align="left" style="padding-right:3px">
					  
						  <cfquery name = "qPosition"
						       datasource = "AppsVacancy"
							   username="#SESSION.login#" 
							   password="#SESSION.dbpw#">
								SELECT       DP.PostNumber, DP.PositionNo,P.Mission,P.Mandateno
								FROM         DocumentPost DP 
								             INNER JOIN   Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
											 INNER JOIN   Employee.dbo.PositionParent PP ON PP.PositionParentId = P.PositionParentId
								WHERE        DocumentNo = '#DocumentNo#'
							</cfquery>	
							
							<table cellspacing="0" cellpadding="0">
					
							<cfloop query = "qPosition">					
								
									<tr>
									<td valign="top">
										<cfif PostNumber neq "">
											<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')">#PostNumber#</a>
										<cfelse>
											<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')">N/A</a>
										</cfif>
									</td>
									</tr>					
								
							</cfloop>	
							  
						    </table>							    
						   
					  </td>
					  
					  <td width="35%" class="cellcontent" style="padding-right:3px">#FunctionalTitle#</td>
					  <td width="8%" class="cellcontent" style="padding-right:3px">#DateFormat(DueDate, CLIENT.DateFormatShow)#</td>
					  
				   </tr>						   
				   
				   <cfif Details.recordcount neq CurrentRow>
						 <tr><td colspan="7" class="linedotted"></td></tr>
					</cfif>
			   
				   </cfoutput>
				   </TABLE>
				   
				<cf_TableBottom size="100%">
		   
			</TD>				   
			</TR>
	    </cfoutput>
						
	<cfelse>
		
	<cfquery name="Details" dbtype="query">
		SELECT  *
		FROM    DetailsCandidate
		WHERE   PostGradeBudget = '#URL.Code#' 
		</cfquery>
									
	   <cfoutput query="Details">
	   
		   <tr class="line">
		      <td width="6%" class="cellcontent" align="center">#CurrentRow#</td> 
			  <cfif VAReferenceNo eq "">
		      <td width="10%" colspan="2" class="cellcontent">
			  	<a href="javascript:showdocument('#DocumentNo#','')">#DocumentNo#</a>
			  </td>
			  <cfelse>
			  <td width="10%" colspan="2" class="cellcontent">
				  <a href="javascript:showdocument('#DocumentNo#','')">#VAReferenceNo#</a>
			  </td>
			  </cfif>
		      <td width="28%" class="cellcontent">
			     <A HREF ="javascript:showdocumentcandidate('#DocumentNo#','#PersonNo#')">#FirstName# #LastName# (#Nationality#)</a>
			   </td>
			  <td width="5%" class="cellcontent">#PostGrade#</td>
			  <td width="10%" class="cellcontent" align="left">
			  
					<cfquery name = "qPosition"
				       datasource = "AppsVacancy"
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
						SELECT       DP.PostNumber, DP.PositionNo,P.Mission,P.Mandateno
						FROM         DocumentPost DP INNER JOIN Employee.dbo.Position P ON DP.PositionNo = P.PositionNo
						INNER JOIN   Employee.dbo.PositionParent PP ON PP.PositionParentId = P.PositionParentId
						WHERE        DocumentNo = '#DocumentNo#'
					</cfquery>	
					
					<table cellspacing="0" cellpadding="0">
			
					<cfloop query = "qPosition">					
						
						<tr>
						<td class="cellcontent">
							<cfif PostNumber neq "">
								<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')">#PostNumber#</a>
							<cfelse>
								<a href="javascript:EditPosition('#Mission#','#MandateNo#','#PositionNo#')">N/A</a>
							</cfif>
						</td>
						</tr>					
						
					  </cfloop>	
					  
				    </table>					  
			     
			  </td>
	
			  <td width="40%" class="cellcontent">#FunctionalTitle#</td>
			  <td width="8%" class="cellcontent"></td>
			  
			</tr>
			
			<cfif Details.recordcount neq CurrentRow>			
				<tr><td height="1" colspan="7" class="line"></td></tr>				
			</cfif>
		
	    </cfoutput>
				
	</cfif>
				
</table>

