<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfinvoke component="Service.Presentation.Presentation" 
     	  method="highlight" 
	      returnvariable="stylescroll"/>
 
 <cfif url.programselect eq "">
 
 	<table cellspacing="0" cellpadding="0" class="formpadding" align="center">
	 <tr><td align="center" height="40" class="labelmedium">
	 <font color="808080">There are no items to show in this view.</font>
	 </td></tr>
	 </table>
 
	 <cfabort>
 
 </cfif> 
  	  
<cfquery name="GetEdition" 
		  datasource="AppsProgram" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">		  
		  SELECT * 
		  FROM   Ref_AllotmentEdition R, Ref_AllotmentVersion V
		  WHERE  R.Version = V.Code
		  AND    R.EditionId = '#url.editionid#'
</cfquery>		  
 
 <cfquery name="GetObject" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
  SELECT     R.Resource, 
             S.ListingOrder AS ListingorderSource, 
			 S.Description AS ResourceName, 
			 A.ObjectCode, 
			 R.ListingOrder, 
			 R.Description, 
             ISNULL(SUM(A.RequestAmountBase),0) AS Total

  FROM       ProgramAllotmentRequest AS A INNER JOIN
             ProgramPeriod AS Pe ON A.ProgramCode = Pe.ProgramCode AND A.Period = Pe.Period INNER JOIN
             Ref_Object AS R ON A.ObjectCode = R.Code INNER JOIN
             Ref_Resource AS S ON R.Resource = S.Code
				  
  WHERE      Pe.ProgramId IN (#preservesinglequotes(url.programselect)#)	
	
	AND      A.EditionId = '#URL.EditionId#'
	
	AND      A.Period    = '#url.period#' 
	
	<!--- valid or blocked requirements --->						
	
    AND     A.ActionStatus  IN ('0','1')

    <!--- not approved yet or not associated --->
   
    AND   (
	         A.RequirementId NOT IN  (
						    SELECT   RequirementId
   		                    FROM     ProgramAllotmentDetailRequest DR,
									 ProgramAllotmentDetail D
	       		            WHERE    DR.RequirementId = A.RequirementId
							AND      DR.TransactionId = D.TransactionId
							AND      D.Status = '1'     
						   )	
			 OR		
			 
			 A.RequirementId NOT IN (
						    SELECT   RequirementId
	     		            FROM     ProgramAllotmentDetailRequest DR															
	             		    WHERE    DR.RequirementId = A.RequirementId																										
						 )		   
			 )				 			
	
    AND      A.ObjectCode IN (SELECT Code 
				              FROM Ref_Object 
				  			  WHERE ObjectUsage = '#GetEdition.ObjectUsage#')
	
  GROUP BY   A.ObjectCode, 
             R.ListingOrder, 
			 R.Resource, 
			 R.Description, 
			 S.ListingOrder, 
			 S.Description		
			 
  ORDER BY   ListingorderSource, R.ListingOrder
					 		 
</cfquery>
				

 <cfif getObject.recordcount eq "0">
 
 	 <table cellspacing="0" cellpadding="0" align="center" class="formpadding">
		 <tr>
			 <td align="center" height="40" class="labelmedium">
			 <font color="808080">There are no items to show in this view.</td>
		 </tr>
	 </table>
	 
	 <cfabort>		
	 
 </cfif>
  
 <table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td colspan="2" height="10"></td></tr>
		
	<tr>
		<td class="labelit"><cf_tl id="Resource"></td>
		<td></td>
		<td class="labelit"><cf_tl id="Code"></td>				
		<td class="labelit"><cf_tl id="Name"></td>
		<td align="right" class="labelit"><cf_tl id="Total"></td>			
	</tr>
	<tr><td colspan="5" height="1" class="line"></td></tr>
	<tr><td height="5"></td></tr>
	
	<cfoutput query="GetObject" group="Resource">
			
		  <tr>
			<td colspan="3" height="25" class="labelit"><font size="2">#ResourceName#</b></td>
			<td></td>
			<td></td>
		  </tr>
		  
		  <tr><td colspan="5" height="1" class="line"></td></tr>
		
		  <cfoutput>
			
				<cfif abs(Total) gte 1>
				
					<cfif findNoCase(ObjectCode,url.objectselect)>
					  <cfset color = "yellow">
					<cfelse>
					  <cfset color = "transparent">
					</cfif>
				
					<tr #stylescroll# bgcolor="#color#">
					    <td width="20" bgcolor="white"></td>
						<td align="center">
						<input type="checkbox" 
						       onclick="hl(this,this.checked);showwhatif();ajaxsel('object',this.value,this.checked)" 
							   name="btn#objectcode#" 
							   value="#ObjectCode#"
							   <cfif findNoCase(ObjectCode,url.objectselect)>checked</cfif>>
							   								   
						</td>					
						<td class="labelit">#ObjectCode#</td>							
						<td class="labelit">#Description#</td>
						<td align="right" class="labelit">#numberformat(total,"__,__.__")#</td>
					</tr>
					
				</cfif>
			
		  </cfoutput>
		
		  <tr><td colspan="5" height="1" class="line"></td></tr>			
		  <tr><td height="8"></td></tr>
			
	</cfoutput>	
	
</table>
 