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
<cfquery name="PositionParent" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PositionParent 
	WHERE  PositionParentId = '#URL.PositionParentId#'
</cfquery>

<cfquery name="Period" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_MissionPeriod
	WHERE  Mission   = '#PositionParent.Mission#'
	AND    MandateNo = '#PositionParent.MandateNo#'
</cfquery>

<cfquery name="Edition" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE  (
	         EditionId IN (SELECT EditionId 
	                     FROM   Organization.dbo.Ref_MissionPeriod 
						 WHERE  Mission   = '#PositionParent.mission#'
						   AND  MandateNo = '#PositionParent.mandateno#')
			OR
			
			 EditionId IN (SELECT EditionIdAlternate 
	                     FROM   Organization.dbo.Ref_MissionPeriod 
						 WHERE  Mission   = '#PositionParent.mission#'
						   AND  MandateNo = '#PositionParent.mandateno#')			   
		  )				   
						   
	AND   E.Version = V.Code 					 
</cfquery>	

<cfquery name="FundList" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Code
	FROM   Ref_AllotmentEditionFund EF, Ref_Fund E
	<cfif Edition.recordcount gte "1">
	WHERE  EditionId IN (#quotedvalueList(edition.editionid)#)
	<cfelse>
	WHERE  1=1
	</cfif>
	AND    Code = '#PositionParent.fund#'
	AND    EF.Fund = E.Code
</cfquery>			 

<cfif FundList.recordcount eq "0">
	
	<cfquery name="FundList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Code
		FROM   Ref_AllotmentEditionFund EF, Ref_Fund E
		<cfif Edition.recordcount gte "1">
		WHERE  EditionId IN (#quotedvalueList(edition.editionid)#)
		<cfelse>
		WHERE  1=1
		</cfif>
		AND    EF.Fund = E.Code
	</cfquery>			

</cfif>

<cfquery name="getPosFundLine" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	PositionParentFunding
		WHERE	PositionParentId = '#url.PositionParentId#'
		<cfif trim(url.FundingId) neq "">
		AND		FundingId = '#url.FundingId#'
		<cfelse>
		AND 	1=0
		</cfif>
</cfquery>

<cfoutput>
	<input name="lines" type="hidden" value="#url.lineId#">
	<table width="95%" align="center" class="formpadding">
		<tr>
			<td class="labelmedium" width="20px">#url.lineId#.</td>
			<td style="padding-left:8px;" width="10%">
			   <select name="fund_#url.lineId#" id="fund_#url.lineId#" class="regularxl">	
		           <cfloop query="FundList">
				     <option value="#Code#" <cfif getPosFundLine.fund eq code>selected</cfif>>#Code#</option>
				   </cfloop>
		   	   </select>
		    </td>
		    <td style="padding-left:10px;" width="75%">					

	    		  <cfquery name="Prg"
			          datasource="AppsProgram" 
			          username="#SESSION.login#" 
			          password="#SESSION.dbpw#">
			          SELECT *
				      FROM   Program P, ProgramPeriod Pe
				      WHERE  P.ProgramCode = '#getPosFundLine.ProgramCode#'
					  AND    P.ProgramCode = Pe.ProgramCode
					  AND    Pe.Period IN (SELECT  Period 
					                       FROM    Organization.dbo.Ref_MissionPeriod 
										   WHERE   Mission   = '#PositionParent.mission#'
										   AND     MandateNo = '#PositionParent.mandateno#')
				  </cfquery>	
									  
				  <cfif prg.recordcount eq "0">
				  					  
				    <cfquery name="Prg"
			          datasource="AppsProgram" 
			          username="#SESSION.login#" 
			          password="#SESSION.dbpw#">
			          SELECT *
				      FROM   Program P
				      WHERE  P.ProgramCode = '#getPosFundLine.ProgramCode#'						  				
				    </cfquery>	
					
				  </cfif>	

				  <table width="100%" cellspacing="0" cellpadding="0">
					  <tr>
						  <td width="1%">

							  <img src="#SESSION.root#/Images/search.png" 
								  alt="Select Program" 
								  name="img5" 
								  onMouseOver="document.img5.src='#SESSION.root#/Images/contract.gif'" 
								  onMouseOut="document.img5.src='#SESSION.root#/Images/search.png'"
								  style="cursor: pointer;" 
								  width="28" 
								  height="29" 
								  border="0" 
								  style="border-color:silver"						 
								  align="absmiddle" 
								  onClick="selectprogram('#PositionParent.mission#','#Period.PlanningPeriod#','applyprogramfunding','_#url.lineId#')">						  
							  
						  </td>
						  <td> 							 		  
							  <input type="text" id="programdescription_#url.lineId#" name="programdescription_#url.lineId#" value="#Prg.ProgramName#" class="regularxl" maxlength="60" style="width:90%;" readonly>
							  <input type="hidden" id="programcode_#url.lineId#" name="programcode_#url.lineId#" value="#getPosFundLine.ProgramCode#">
						  </td>
						  
					  </tr>					  
				  </table> 
		    </td>
		    <td style="padding-left:10px;" width="5%" align="right">
		    	<cfif getPosFundLine.percentage eq "">
			    	<cfset vPercentage = 0>
			    <cfelse>
			    	<cfset vPercentage = getPosFundLine.percentage*100>
		    	</cfif>
		    	<input type="text" name="percentage_#url.lineId#" id="percentage_#url.lineId#" class="regularxl clsFundingPercentage" size="1" style="text-align:right; padding-right:5px;" value="#vPercentage#">
		    </td>
			<td style="padding-left:10px; width:100px;">
				<table>
					<tr>
						<td>
							<cf_tl id="Remove line" var="1">
							<img src="#session.root#/images/delete_blueSquare.png" style="cursor:pointer;" class="clsRemoveButton" onclick="removeFundingLine('#url.lineId#');" title="#lt_text#">
						</td>
						<td>
							<cf_tl id="Add new line" var="1">
							<img src="#session.root#/images/add_blueSquare.png" style="cursor:pointer;" class="clsAddButton" onclick="addFundingLine('#url.PositionParentId#', '');" title="#lt_text#">
						</td>
					</tr>
				</table>
				
			</td>
		</tr>
	</table>
</cfoutput>


<cfset ajaxOnLoad("function() { doHighlight(); validateDisplayButtons(); }")>