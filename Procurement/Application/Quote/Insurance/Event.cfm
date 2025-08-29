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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->


<!--- SAT, procurement contract follow-up template
There are three fields which are custom fields. 
Please embed these fields ala Insight into this template 
after carolina informs you about the field reference number 
they have in SAT
 ---->



<cfquery name="JobEvent" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*
    FROM Job J,Ref_OrderClass R
	WHERE J.OrderClass = R.Code
	AND J.JobNo = '#URL.JobNo#'	
</cfquery>
<cfloop index="itm" list="001,ND014,FC014">	

	<cfquery name="qry_#itm#"
	   datasource="AppsOrganization"
	   username="#SESSION.login#"
	   password="#SESSION.dbpw#">
		  SELECT DocumentItemValue as value
		  FROM   OrganizationObjectInformation
		  WHERE  ObjectId in (SELECT ObjectId
						       FROM   OrganizationObject
						       WHERE  ObjectKeyValue1='#URL.JobNo#')							  
		  AND DocumentId IN
			     (SELECT   DocumentId
			      FROM  Ref_EntityDocument
			      WHERE EntityCode = 'ProcJob'
			      AND   DocumentCode = '#itm#')
				    
	  </cfquery>
			  
</cfloop>

<cfoutput>	

	<TR class="labelmedium">
	 <TD height="18"><cf_tl id="JobTrigger">:</TD>
	 <TD><font color="0080FF"><cfif qry_001.value eq "">--<cfelse>#qry_001.value#</cfif></TD>
	</TR>
	
	<TR class="labelmedium">
    <TD height="18"><cf_tl id="Event">:</TD>
    <TD class="labelit"><font color="0080FF">#JobEvent.Description#</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD height="18"><cf_tl id="Contract No">:</TD>	
	<TD><font color="0080FF"><cfif qry_ND014.value eq "">--<cfelse>#qry_ND014.value#</cfif></td>
	</TR>
	
	<TR class="labelmedium">
    <TD height="18"><cf_tl id="Subscription date">:</TD>	
	<TD><font color="0080FF"><cfif qry_FC014.value eq "">--<cfelse>#qry_FC014.value#</cfif></td>
	</TR>	
	
</cfoutput>		
