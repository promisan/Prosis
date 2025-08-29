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
<cfoutput>

<cfquery name="PeriodList" 
	      datasource="AppsProgram" 
    	  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, 
		          Organization.dbo.Ref_MissionPeriod M
	      WHERE   IncludeListing = 1
		  AND     R.Period IN (SELECT Period as Period
		                       FROM Purchase.dbo.RequisitionLine
							    WHERE Mission = '#URL.Mission#'
							   UNION 
							   SELECT DefaultPeriod as Period
							   FROM Purchase.dbo.Ref_ParameterMission 
							   WHERE Mission = '#URL.Mission#'
							   )
							   
	      AND     M.Mission = '#URL.Mission#'
	      AND    R.Period = M.Period
      </cfquery>
	  
	<table width="100%" align="center" id="periodlist">  
							
	<tr>
		   
	   <td width="70%">
	   
		    <table cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr>			
			  <td style="height:30px;padding-right:4px;padding-left:4px" class="labelit"></td>
			
			<cfoutput>
			<input type="hidden" name="periodsel" id="periodsel" value="#url.period#">
			</cfoutput>
			
		    <cfloop query="PeriodList">
			  <td style="padding-right:4px">
			  <input type="radio" 
			    onclick="document.getElementById('periodsel').value='#period#';reqsearch()" 
				name="Period" class="radiol"
				id="box#Period#"
				value="#Period#" <cfif url.period eq period>checked</cfif>>		
			  </td>
			  
			  <td style="cursor: pointer;padding-right:10px;padding-left:3px" class="labellarge" 
			      onclick="document.getElementById('box#Period#').click()">#Period#</td>
								  
			</cfloop>  
			
			<td class="hide">
		    
			 <input type="button" id="refreshbutton" name="refreshbutton" onclick="reqsearch()">					      		
		  
			</td>						
			</tr>
			
			</table>
		
	   </td>
	</tr>
	
	</table>
	
</cfoutput>	